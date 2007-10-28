Return-Path: <linux-kernel-owner+w=401wt.eu-S1753880AbXJ1Dny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbXJ1Dny (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 23:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056AbXJ1Dnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 23:43:46 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47658 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbXJ1Dnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 23:43:46 -0400
Date: Sun, 28 Oct 2007 03:43:43 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, jdike@karaya.com,
       user-mode-linux-devel@lists.sourceforge.net, sam@ravnborg.org
Subject: Re: UML building failed in current Linus-tree
Message-ID: <20071028034343.GV8181@ftp.linux.org.uk>
References: <20071028032441.GB2502@hacking>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071028032441.GB2502@hacking>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2007 at 11:24:41AM +0800, WANG Cong wrote:
> 
> Hi, Jeff, Sam!
> 
> I just pulled from Linus-tree, and got the following error when building uml.
> 
> $ make defconfig ARCH=um
> /home/wangcong/projects/linux-2.6/arch/um/Makefile-i386:32: /home/wangcong/projects/linux-2.6/arch/i386/Makefile.cpu: No such file or directory
> make: *** No rule to make target `/home/wangcong/projects/linux-2.6/arch/i386/Makefile.cpu'.  Stop.
> 
> Is this a known problem? Yesterday's Linus-tree was fine.

diff --git a/arch/um/Kconfig.i386 b/arch/um/Kconfig.i386
index 9876d80..e0ac74e 100644
--- a/arch/um/Kconfig.i386
+++ b/arch/um/Kconfig.i386
@@ -1,6 +1,6 @@
 menu "Host processor type and features"
 
-source "arch/i386/Kconfig.cpu"
+source "arch/x86/Kconfig.cpu"
 
 endmenu
 
diff --git a/arch/um/Makefile-i386 b/arch/um/Makefile-i386
index 08433f8..b01dfb0 100644
--- a/arch/um/Makefile-i386
+++ b/arch/um/Makefile-i386
@@ -28,7 +28,7 @@ CONFIG_X86_32		:= y
 export CONFIG_X86_32
 
 # First of all, tune CFLAGS for the specific CPU. This actually sets cflags-y.
-include $(srctree)/arch/i386/Makefile.cpu
+include $(srctree)/arch/x86/Makefile_32.cpu
 
 # prevent gcc from keeping the stack 16 byte aligned. Taken from i386.
 cflags-y += $(call cc-option,-mpreferred-stack-boundary=2)
