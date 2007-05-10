Return-Path: <linux-kernel-owner+w=401wt.eu-S1761561AbXEJMsY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761561AbXEJMsY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 08:48:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758515AbXEJMsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 08:48:15 -0400
Received: from [81.2.110.250] ([81.2.110.250]:59544 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758127AbXEJMsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 08:48:13 -0400
Date: Thu, 10 May 2007 13:51:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: HDIO_DRIVE_CMD and hdparm
Message-ID: <20070510135153.5f6d62f8@the-village.bc.nu>
In-Reply-To: <Pine.LNX.4.62.0705101327170.759@pademelon.sonytel.be>
References: <Pine.LNX.4.62.0705101327170.759@pademelon.sonytel.be>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>   - SCSI doesn't handle HDIO_DRIVE_CMD(null), and returns EINVAL
>     => fine for hdparm
>   - If a block device doesn't support the ioctl, blkdev_driver_ioctl() returns
>     ENOTTY
>     => hdparm error message

Those are both correct
	-ENOTTY 		I don't know this ioctl
	-EINVAL			I know this ioctl, usage wrong
	0			Hey it worked

	ENOIOCTLCMD		Internal (not user exposed)
				for fallthrough

	ENOSYS			CD-ROM being weird.

