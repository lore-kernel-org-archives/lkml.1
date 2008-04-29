Return-Path: <linux-kernel-owner+w=401wt.eu-S1753380AbYD2V0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbYD2V0y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 17:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751533AbYD2V0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 17:26:42 -0400
Received: from avexch1.qlogic.com ([198.70.193.115]:8522 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbYD2V0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 17:26:40 -0400
Date: Tue, 29 Apr 2008 14:26:39 -0700
From: Andrew Vasquez <andrew.vasquez@qlogic.com>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-driver@qlogic.com,
       linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com
Subject: Re: Issue with qla2xxx_probe_one
Message-ID: <20080429212639.GC72811@plap4.qlogic.org>
References: <48175C3F.3000002@hp.com> <20080429174447.GL67096@plap4.qlogic.org> <48178143.2000308@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48178143.2000308@hp.com>
Organization: QLogic Corporation
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 29 Apr 2008 21:26:38.0616 (UTC) FILETIME=[B594F980:01C8AA3F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008, Alan D. Brunelle wrote:

> Andrew Vasquez wrote:
> > On Tue, 29 Apr 2008, Alan D. Brunelle wrote:
> >
> >> I /think/ that there is an issue with this routine /if/ the firmware
> >> images are not loaded properly - on a 16-way ia64 box I am starting to
> >> see this with an up-stream kernel (Jens Axboe's origin/io-cpu-affinity
> >> branch). In any event, it looks to me that :
> >>
> >>         if (qla2x00_initialize_adapter(ha)) {
> >>                 qla_printk(KERN_WARNING, ha,
> >>                     "Failed to initialize adapter\n");
> >>
> >>                 DEBUG2(printk("scsi(%ld): Failed to initialize
> adapter - "
> >>                     "Adapter flags %x.\n",
> >>                     ha->host_no, ha->device_flags));
> >>
> >>                 ret = -ENODEV;
> >>                 goto probe_failed;
> >>         }
> >>
> >> skips around:
> >>
> >>         ret = scsi_add_host(host, &pdev->dev);
> >>
> >> which is needed to properly initialize the freelist (via:
> >> scsi_setup_command_freelist).
> >
> > Wasn't something like this posted recently to linux-scsi:
> >
> > http://lkml.org/lkml/2008/4/27/333
> >
> > this is sitting in scsi-misc-2.6.git:
> >
> > [SCSI] bug fix for free list handling
> >
> http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commitdiff;h=a79cbe1aa5dd695f0ee012ecde1ff88b1192e326
> >
> > which I gather will be pushed soon...
> 
> My apologies for not having seeing that.
> 
> But after looking at it, doesn't it still have a hole?
> 
> o  scsi_setup_command_freelist initializes the free_list list.
> 
> o  It then invokes scsi_get_host_cmd_pool, if this fails there is no
> need to invoke scsi_put_host_cmd_pool (it wasn't gotten).
> 
> o  If scsi_get_host_cmd_pool succeeds but scsi_pool_alloc_command fails,
> it will (correctly) invoke scsi_put_host_cmd_pool.
...
<snip>

Hmm, I'll defer to James B. on that...

--
av
