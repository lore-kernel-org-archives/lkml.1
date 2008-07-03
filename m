Return-Path: <linux-kernel-owner+w=401wt.eu-S1757535AbYGCW4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535AbYGCW4Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 18:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755906AbYGCWz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 18:55:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50723 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756157AbYGCWz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 18:55:56 -0400
Date: Thu, 3 Jul 2008 18:54:53 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 1/2] Avoid bio_endio recursion
In-Reply-To: <20080703220449.20688451@lxorguk.ukuu.org.uk>
Message-ID: <Pine.LNX.4.64.0807031843480.10463@engineering.redhat.com>
References: <Pine.LNX.4.64.0806240118250.24220@engineering.redhat.com>
 <20080624080744.GL20851@kernel.dk> <Pine.LNX.4.64.0806241017390.23052@engineering.redhat.com>
 <20080625082421.GU20851@kernel.dk> <Pine.LNX.4.64.0806252008380.11130@engineering.redhat.com>
 <20080626070723.GL20851@kernel.dk> <Pine.LNX.4.64.0807020001290.9097@engineering.redhat.com>
 <20080702082511.GF20055@kernel.dk> <Pine.LNX.4.64.0807031704120.20244@engineering.redhat.com>
 <20080703220449.20688451@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Jul 2008, Alan Cox wrote:

>> I use the old IDE driver, I don't see a reason why driver should create
>> SCSI requests and lower layer translate them to ATA commands.
>
> Because modern drives are basically SCSI devices. Once you turn on NCQ
> and stuff you need all the midlayer queueing magic ...

There is no piece of SCSI protocol in SATA disks. The command and response 
FIS of SATA standard contain legacy IDE registers, there's nothing about 
SCSI. Even the NCQ commands are done via IDE registers, not SCSI command 
block. It seems like someone wanted to save few weeks of coding by reusing 
the SCSI disk queuing ... and created a lot of other problems (example: if 
you have disk error with IDE driver, it dumps IDE registers into log ... 
if you have disk error with SATA driver, it dumps sense key ... but 
there's no sense key in SATA standard ... the driver just had to make up 
one because it pretends to be SCSI).

Mikulas
