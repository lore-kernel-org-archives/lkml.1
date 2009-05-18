Return-Path: <linux-kernel-owner+w=401wt.eu-S1754360AbZEROIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360AbZEROIv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 10:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752221AbZEROIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 10:08:42 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:3740 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbZEROIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 10:08:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=hkGSGOUGLWf/kS/7YoCEJdsteEw6t9V0MvxgJkAX8kcf3/sixkK2uTRGKe9kuxydxl
         DqmvlNr6dD0BO0nZOsokjdhd1IzYqZ3vgSn22Rdk8lGrpR91GUIWX2CUlteETRl1P0PR
         gAuG3mJOxYx6I5F+bcBJxOY9/7VsIIoOWibTE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 0/6] drivers/ide Convert printk(KERN_<foo> to pr_<foo>(
Date: Mon, 18 May 2009 16:12:43 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3-00442-ga3668b0; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <cover.1242609803.git.joe@perches.com>
In-Reply-To: <cover.1242609803.git.joe@perches.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200905181612.43632.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 May 2009 04:21:08 Joe Perches wrote:
> Mostly mechanical conversion of printk's

[...]

Hmm.. less mechanical conversion using also dev_*() macros where suitable
would be much better...

> Joe Perches (6):
>   drivers/ide: Convert printk(KERN_DEBUG to pr_debug(

How's about fixing pr_devel() which currently doesn't seem to be used
by anything inside kernel to not depend on DEBUG in separate pre-patch
and then using it instead of pr_debug()?

>   drivers/ide: Convert printk(KERN_INFO to pr_info(
>   drivers/ide: Convert printk(KERN_ERR to pr_err(
>   drivers/ide: Convert printk(KERN_WARNING to pr_warning(
>   drivers/ide: Convert printk(KERN_CONT to pr_cont(
>   drivers/ide: Convert printk(KERN_NOTICE to pr_notice(

Please re-do it so we have per-file patches instead of per-pr_.

Preferably with some files grouped together so we have only three patches:

* core code: ide-acpi.c, ide-atapi.c, ide.c, ide-devsets.c, ide-dma*.c,
  ide-eh.c, ide-io*.c, ide-legacy.c, ide-lib.c, ide-park.c, ide-pio*.c,
  ide-pm.c, ide-probe.c, ide-proc.c, ide-scan-pci.c, ide-sysfs.c,
  ide-taskfile.c, ide-timings.c, ide-xfer-mode.c and setup-pci.c

* device drivers: ide-cd*, ide-disk*, ide-gd*, ide-floppy* and ide-tape.c

* host drivers: all the rest

It would make patches easier to review and would greatly help when it
comes to merging them (i.e. I could apply changes to host drivers right
know but I don't want to interfere too much with the on-going work on
device drivers).

Thanks.
Bart
