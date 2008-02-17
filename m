Return-Path: <linux-kernel-owner+w=401wt.eu-S1756911AbYBQRRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911AbYBQRRf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 12:17:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752695AbYBQRR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 12:17:27 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:34277 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbYBQRR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 12:17:26 -0500
Date: Sun, 17 Feb 2008 12:17:20 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] linux/hdsmart.h: fix goofups
In-Reply-To: <200802171807.57983.bzolnier@gmail.com>
Message-ID: <alpine.LFD.1.00.0802171214380.3515@localhost.localdomain>
References: <200802171807.57983.bzolnier@gmail.com>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Feb 2008, Bartlomiej Zolnierkiewicz wrote:

> Fix goofups of commit 76166952bbc81dda1c8a8c14e75a2aa06f6c052c
> ("<linux/hdsmart.h> is not used by kernel code").
>
> Reported-by: "Robert P. J. Day" <rpjday@crashcourse.ca>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  include/linux/hdsmart.h |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> Index: b/include/linux/hdsmart.h
> ===================================================================
> --- a/include/linux/hdsmart.h
> +++ b/include/linux/hdsmart.h
> @@ -17,7 +17,7 @@
>  #ifndef _LINUX_HDSMART_H
>  #define _LINUX_HDSMART_H
>
> -#ifndef __KERNEL
> +#ifndef __KERNEL__
>  #define OFFLINE_FULL_SCAN		0
>  #define SHORT_SELF_TEST			1
>  #define EXTEND_SELF_TEST		2
> @@ -121,6 +121,6 @@ typedef struct ata_smart_selftestlog_s {
>  	unsigned char			resevered[2];
>  	unsigned char			chksum;
>  } __attribute__ ((packed)) ata_smart_selftestlog_t;
> -#endif /* __KERNEL__ *
> +#endif /* __KERNEL__ */
>
>  #endif	/* _LINUX_HDSMART_H */

if that header file isn't used by any kernel code, why bother having a
check for __KERNEL__ in the first place?  it's being exported to
userspace unchecked:

  include/linux/Kbuild:header-y += hdsmart.h

so why not just toss that check entirely?  otherwise, you're going to
get a header file exported to userspace that has a superfluous
__KERNEL__ test in it.

rday
--


========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
