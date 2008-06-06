Return-Path: <linux-kernel-owner+w=401wt.eu-S1759719AbYFFOnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759719AbYFFOnB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 10:43:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756879AbYFFOmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 10:42:51 -0400
Received: from smtp.movial.fi ([62.236.91.34]:47570 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755984AbYFFOmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 10:42:50 -0400
Message-ID: <48494CF0.4090604@movial.fi>
Date: Fri, 06 Jun 2008 17:42:56 +0300
From: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Organization: Movial Creative Technologies
User-Agent: Icedove 1.5.0.14eol (X11/20080509)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 6
References: <20080606183527.d3b39ecd.sfr@canb.auug.org.au>	<4848F9E5.20005@movial.fi> <20080606211151.b36ed703.sfr@canb.auug.org.au>
In-Reply-To: <20080606211151.b36ed703.sfr@canb.auug.org.au>
Content-Type: multipart/mixed;
 boundary="------------030605030601010607070101"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030605030601010607070101
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Stephen Rothwell wrote:
> Hi Dmitri,
> 
> On Fri, 06 Jun 2008 11:48:37 +0300 Dmitri Vorobiev <dmitri.vorobiev@movial.fi> wrote:
>> Please see http://lkml.org/lkml/2008/6/4/152 where you'll find the
>> description of how I built a MIPS cross-toolchain and a working MIPS config.
> 
> Thanks for that.  Sorry I didn't respond sooner.
> 
> We have managed to make a working tool chain and I will
> add some MIPS builds soon.  Was the attached config just the
> malta_defconfig in the kernel tree, or there something special about it.
> I noticed that a straight defconfig build works for mips and mipsel.
> Would you expect all{no,mod}config to work?  What would be a good 64 bit
> test config?

The config I attached in my previous email differs from the
malta_defconfig. The former is pretty minimal, and contains only the
stuff which is just necessary and sufficient to boot up the Timesys
userspace. I also use this config to boot a Debian-based system.

As for the allnoconfig, it usually builds for me, and I use allnoconfig
as one of the sanity tests in the context of my own development process.

The allmodconfig has been broken for some time, and you need to manually
disable several options (the diff between the allmodconfig and the
buildable configuration is attached to this email).

To get a buildable config out of allyesconfig, one needs to manually
disable the CONFIG_VORTEX option.

I have no 64-bit MIPS hardware, so I can't help with these platforms,
unfortunately.

> 
> It is easier for us if we just use the configs out of the kernel tree,
> but others are possible (its just harder to keep them up to date).
> 

I just checked malta_defconfig. Current Linus' tree built without
errors, and I also was able to boot a Qemu-based system. So, I believe
that malta_defconfig can be used for the linux-next test builds instead
of (or along with) the config that I sent earlier.

Dmitri

--------------030605030601010607070101
Content-Type: text/x-patch;
 name="allmodconfig.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="allmodconfig.patch"

--- .config.allmodconfig	2008-06-06 15:28:18.000000000 +0300
+++ .config	2008-06-06 15:28:59.000000000 +0300
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
 # Linux kernel version: 2.6.26-rc5
-# Fri Jun  6 14:22:13 2008
+# Fri Jun  6 15:28:59 2008
 #
 CONFIG_MIPS=y
 
@@ -1317,7 +1317,7 @@
 CONFIG_EL2=m
 CONFIG_EL16=m
 CONFIG_EL3=m
-CONFIG_VORTEX=m
+# CONFIG_VORTEX is not set
 CONFIG_NET_VENDOR_SMC=y
 CONFIG_WD80x3=m
 CONFIG_ULTRA=m
@@ -2735,14 +2735,9 @@
 CONFIG_EXT3_FS_XATTR=y
 CONFIG_EXT3_FS_POSIX_ACL=y
 CONFIG_EXT3_FS_SECURITY=y
-CONFIG_EXT4DEV_FS=m
-CONFIG_EXT4DEV_FS_XATTR=y
-CONFIG_EXT4DEV_FS_POSIX_ACL=y
-CONFIG_EXT4DEV_FS_SECURITY=y
+# CONFIG_EXT4DEV_FS is not set
 CONFIG_JBD=m
 CONFIG_JBD_DEBUG=y
-CONFIG_JBD2=m
-CONFIG_JBD2_DEBUG=y
 CONFIG_FS_MBCACHE=m
 CONFIG_REISERFS_FS=m
 CONFIG_REISERFS_CHECK=y

--------------030605030601010607070101--
