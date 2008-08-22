Return-Path: <linux-kernel-owner+w=401wt.eu-S1755523AbYHVIDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523AbYHVIDz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 04:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752613AbYHVIDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 04:03:39 -0400
Received: from [93.163.65.50] ([93.163.65.50]:5527 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752058AbYHVIDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 04:03:36 -0400
Date: Fri, 22 Aug 2008 10:03:34 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: xiphmont@xiph.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SG_IO block filter whitelist missing MMC SET READ AHEAD command
Message-ID: <20080822080334.GU20055@kernel.dk>
References: <806dafc20808220036k3c1360e6l1b5fea9b659592b3@mail.gmail.com> <806dafc20808220041y7b79e501p774195f201d5e3f8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <806dafc20808220041y7b79e501p774195f201d5e3f8@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(apologies to Monty who will receive this email twice)

> Hi Jens,
> 
> I have another request for the block filter SG_IO command whitelist,
> specifically the MMC streaming command set SET READ AHEAD command.
> The command applies only to MMC CDROM/DVDROM drives with the streaming
> optional feature set.  The command is useful to cdparanoia in that it
> allows explicit cache control side effects that are, on many drives,
> cdparanoia's most efficient way to flush/disable the media cache on
> cdrom drives. I am aware of no reason why it should not be accessible
> from usespace.
> 
> Also note that the command is already fully accessible through the
> SCSI-native version of the SG_IO ioctl as well as the traditional SG
> interface.  The command is only being refused on block devices.  That
> means that on a typical stock distro, the command is available through
> /dev/sg* but not /dev/scd* although both are typically available and
> accessible.  Filtering the command is not providing any protection,
> only a confusing inconsistency.
> 
> For convenience's sake, trivial patch below.
> 
> diff -ru linux-2.6.26.3/block/scsi_ioctl.c
> linux-2.6.26.3-monty/block/scsi_ioctl.c
> --- linux-2.6.26.3/block/scsi_ioctl.c   2008-08-20 14:11:37.000000000 -0400
> +++ linux-2.6.26.3-monty/block/scsi_ioctl.c     2008-08-22
> 04:17:56.194248000 -0400
> @@ -188,6 +188,7 @@
>                safe_for_write(GPCMD_PREVENT_ALLOW_MEDIUM_REMOVAL),
>                safe_for_write(GPCMD_LOAD_UNLOAD),
>                safe_for_write(GPCMD_SET_STREAMING),
> +               safe_for_write(GPCMD_SET_READ_AHEAD),
>        };
>        unsigned char type = cmd_type[cmd[0]];

Looks harmless enough to me, I've adapted your patch for current -git.
Note that with 2.6.27, you can actually modify the command table at
runtime as well. But we should still have sane defaults.

-- 
Jens Axboe

