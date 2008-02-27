Return-Path: <linux-kernel-owner+w=401wt.eu-S1764375AbYB0C7F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764375AbYB0C7F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 21:59:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755038AbYB0C6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 21:58:53 -0500
Received: from mail.gmx.net ([213.165.64.20]:33107 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754674AbYB0C6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 21:58:52 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+Wwu87UWqWbmwEwesX7WtjdOagfYOKm0D7xtvNB6
	W79r7qMMS+ESN6
Subject: Re: regression: CD burning (k3b) went broke
From: Mike Galbraith <efault@gmx.de>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>,
       Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org
In-Reply-To: <47C4B2D4.109@garzik.org>
References: <1203583379.6244.27.camel@homer.simson.net>
	 <20080222073228.GZ23197@kernel.dk>
	 <1203752563.5225.4.camel@homer.simson.net>
	 <1203839683.17463.9.camel@homer.simson.net>
	 <1204019283.8731.11.camel@homer.simson.net>
	 <1204033003.11828.22.camel@homer.simson.net>
	 <20080226150845.2196bc1a.akpm@linux-foundation.org>
	 <47C4B2D4.109@garzik.org>
Content-Type: text/plain
Date: Wed, 27 Feb 2008 03:58:48 +0100
Message-Id: <1204081128.26640.20.camel@homer.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-02-26 at 19:46 -0500, Jeff Garzik wrote:

> I would love to get an answer as to what data_len (and of course 
> raw_data_len) should be set to AFTER the command completes, which is 
> what is going on here.

Yeah, blk_complete_sghdr_rq() used to do hdr->resid = irq->data_len,
which is modified down lower.  How/where that hdr->resid percolates back
up, and turns into a retry/nogo, I don't know.

	-Mike

