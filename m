Return-Path: <linux-kernel-owner+w=401wt.eu-S1752513AbZLXBTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513AbZLXBTX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 20:19:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbZLXBTW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 20:19:22 -0500
Received: from mailget.neusoft.com ([210.83.25.69]:19926 "EHLO
	mailgate.neusoft.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbZLXBTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 20:19:21 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5841"; a="5597892"
Date: Thu, 24 Dec 2009 09:21:29 +0800 (CST)
From: fengxiangjun <fengxiangjun@neusoft.com>
Subject: Re: 2.6.32.2 SATA link detect failed, 2.6.32.1 works fine
In-reply-to: <9c30dffe0912230402s5af415c3i83d6f5ba4f8f1841@mail.gmail.com>
X-X-Sender: fengxj@darkstar.example.net
To: Bjarke Istrup Pedersen <gurligebis@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Robert Hancock <hancockrwd@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Message-id: <alpine.LNX.2.00.0912240858050.1682@darkstar.example.net>
MIME-version: 1.0
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
References: <alpine.LNX.2.00.0912211855460.1689@darkstar.example.net>
 <4B30134C.1050609@gmail.com>
 <alpine.LNX.2.00.0912220859060.1686@darkstar.example.net>
 <51f3faa70912211708j200ab584wa835ffe50981415e@mail.gmail.com>
 <alpine.LNX.2.00.0912220955341.1696@darkstar.example.net>
 <4B31DB17.4050509@kernel.org>
 <alpine.LNX.2.00.0912231719440.1694@darkstar.example.net>
 <9c30dffe0912230402s5af415c3i83d6f5ba4f8f1841@mail.gmail.com>
Content-Transfer-Encoding: 7bit
Content-Type: TEXT/PLAIN; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, it's timing related.

I just tried booting with an initrd, and i want to capture the full error 
message, but with initrd, the problem went away.

The only difference between the two config is:

--- .config.old	2009-12-24 09:16:31.000000000 +0800
+++ .config	2009-12-23 19:05:17.000000000 +0800
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
 # Linux kernel version: 2.6.32.2
-# Mon Dec 21 18:42:50 2009
+# Wed Dec 23 19:05:17 2009
 #
 CONFIG_64BIT=y
 # CONFIG_X86_32 is not set
@@ -100,7 +100,11 @@
 # CONFIG_USER_NS is not set
 # CONFIG_PID_NS is not set
 # CONFIG_NET_NS is not set
-# CONFIG_BLK_DEV_INITRD is not set
+CONFIG_BLK_DEV_INITRD=y
+CONFIG_INITRAMFS_SOURCE=""
+CONFIG_RD_GZIP=y
+CONFIG_RD_BZIP2=y
+CONFIG_RD_LZMA=y
 CONFIG_CC_OPTIMIZE_FOR_SIZE=y
 CONFIG_SYSCTL=y
 CONFIG_ANON_INODES=y
@@ -1710,8 +1714,11 @@
 CONFIG_CRC32=y
 # CONFIG_CRC7 is not set
 # CONFIG_LIBCRC32C is not set
-CONFIG_ZLIB_INFLATE=m
+CONFIG_ZLIB_INFLATE=y
 CONFIG_ZLIB_DEFLATE=m
+CONFIG_DECOMPRESS_GZIP=y
+CONFIG_DECOMPRESS_BZIP2=y
+CONFIG_DECOMPRESS_LZMA=y
 CONFIG_HAS_IOMEM=y
 CONFIG_HAS_IOPORT=y
 CONFIG_HAS_DMA=y

Right now, I can reproduce this problem only when I
running 2.6.32.2 with a specific kernel config.

If I attach a serial console or use initrd to capture
the fail boot log, the problem disapeared. Even running
2.6.31.1 with the exactly same config, no problem. 

So I will say that it's very hard to reproduce this, it's very
subtly timing related. 

I remember when running 2.6.32-rc8 and 2.6.32, the same
problem happened twice, I just can't reproduce it.
And with 2.6.31.x, never running into this.

Oh well. 

On Wed, 23 Dec 2009, Bjarke Istrup Pedersen wrote:

> Hey,
> 
> Could it be an idea to do a bisect for the patch that makes it break? :)
> 
> /Bjarke
> 
---------------------------------------------------------------------------------------------------
Confidentiality Notice: The information contained in this e-mail and any accompanying attachment(s) 
is intended only for the use of the intended recipient and may be confidential and/or privileged of 
Neusoft Corporation, its subsidiaries and/or its affiliates. If any reader of this communication is 
not the intended recipient, unauthorized use, forwarding, printing,  storing, disclosure or copying 
is strictly prohibited, and may be unlawful.If you have received this communication in error,please 
immediately notify the sender by return e-mail, and delete the original message and all copies from 
your system. Thank you. 
---------------------------------------------------------------------------------------------------

