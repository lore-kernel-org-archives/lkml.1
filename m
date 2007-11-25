Return-Path: <linux-kernel-owner+w=401wt.eu-S1753864AbXKYFUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbXKYFUs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 00:20:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750743AbXKYFUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 00:20:40 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:45242 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbXKYFUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 00:20:39 -0500
Date: Sun, 25 Nov 2007 00:17:42 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: "son of unifdef"
Message-ID: <alpine.LFD.0.9999.0711250012470.7266@localhost.localdomain>
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
X-Mailing-List: linux-kernel@vger.kernel.org


  just for the entertainment value, i ran "make headers_install" on my
x86 box using the newer "sunifdef" utility, which has the advantage
that it will remove parts of compound preprocessor conditionals.
here's the diff output between the old and the new generated header
directories:

diff -r include.orig/asm/posix_types_32.h include.sunifdef/asm/posix_types_32.h
42c42
< #if defined(__KERNEL__) || defined(__USE_ALL)
---
> #if defined(__USE_ALL)
49c49
< #if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
---
> #if !defined(__GLIBC__) || __GLIBC__ < 2
diff -r include.orig/linux/acct.h include.sunifdef/linux/acct.h
62d61
< #if !defined(CONFIG_M68K) || !defined(__KERNEL__)
64d62
< #endif
diff -r include.orig/linux/ext2_fs.h include.sunifdef/linux/ext2_fs.h
240c240
< #if defined(__KERNEL__) || defined(__linux__)
---
> #if defined(__linux__)
diff -r include.orig/linux/ext3_fs.h include.sunifdef/linux/ext3_fs.h
295c295
< #if defined(__KERNEL__) || defined(__linux__)
---
> #if defined(__linux__)
diff -r include.orig/linux/nfs3.h include.sunifdef/linux/nfs3.h
99c99
< #if defined(__KERNEL__) || defined(NFS_NEED_KERNEL_TYPES)
---
> #if defined(NFS_NEED_KERNEL_TYPES)
diff -r include.orig/linux/socket.h include.sunifdef/linux/socket.h
19c19
< #if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
---
> #if !defined(__GLIBC__) || __GLIBC__ < 2
diff -r include.orig/linux/soundcard.h include.sunifdef/linux/soundcard.h
1036c1036
< #if (!defined(__KERNEL__) && !defined(KERNEL) && !defined(INKERNEL) && !defined(_KERNEL)) || defined(USE_SEQ_MACROS)
---
> #if  !defined(KERNEL) && !defined(INKERNEL) && !defined(_KERNEL) || defined(USE_SEQ_MACROS)
diff -r include.orig/linux/stat.h include.sunifdef/linux/stat.h
5c5
< #if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
---
> #if !defined(__GLIBC__) || __GLIBC__ < 2
diff -r include.orig/linux/videodev.h include.sunifdef/linux/videodev.h
17d16
< #if defined(CONFIG_VIDEO_V4L1_COMPAT) || !defined (__KERNEL__)
297d295
< #endif /* CONFIG_VIDEO_V4L1_COMPAT */
diff -r include.orig/video/edid.h include.sunifdef/video/edid.h
4d3
< #if !defined(__KERNEL__) || defined(CONFIG_X86)
11d9
< #endif

  in addition, sunifdef whined as follows:

UNIFDEF include/linux/netlink.h
sunifdef: /home/rpjday/k/git/include/linux/netlink.h: line 205:
warning 0x02070: Garbage following preprocessor directive in "#if PAGE_SIZE < 8192UL" (#if line 152 depth 2)

  i'm guessing it's that "UL" suffix it doesn't like.

rday

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
