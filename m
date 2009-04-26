Return-Path: <linux-kernel-owner+w=401wt.eu-S1752781AbZDZECs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbZDZECs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 00:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750871AbZDZECi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 00:02:38 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50359 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbZDZECh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 00:02:37 -0400
Message-ID: <49F3DCD5.2070909@garzik.org>
Date: Sun, 26 Apr 2009 00:02:29 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       unsik Kim <donari75@gmail.com>, linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: [PATCH 2/3] mg_disk: fix dependency on libata
References: <200904251509.11912.bzolnier@gmail.com> <49F3D994.7020304@kernel.org>
In-Reply-To: <49F3D994.7020304@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Bartlomiej Zolnierkiewicz wrote:
>> Add local copies of ata_id_string() and ata_id_c_string() to mg_disk
>> so there is no need for the driver to depend on ATA and SCSI.
>>
>> Cc: unsik Kim <donari75@gmail.com>
>> Cc: Tejun Heo <tj@kernel.org>
>> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> Ah.. right, that's a rather large dependency to pull in just for the
> string functions.  Yeah, I think it would be better to keep local
> copy at elast for now.
> 
> Acked-by: Tejun Heo <tj@kernel.org>

Actually...  NVMHCI[1] uses the same style of id string extraction, even 
though its command set is wholly new and unrelated to ATA.  I copied 
into drivers/block/nvmhci.c[2] id_string, id_c_string and another 
useful, generic routine: ata_wait_register.

So, once nvmhci goes upstream, that will be a third copy...  nvmhci 
still has rough edges, but it's mainly waiting on hardware "it works" 
verification at this point.

	Jeff



[1] http://download.intel.com/standards/nvmhci/spec.pdf

[2] 'nvmhci' branch of 
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git

