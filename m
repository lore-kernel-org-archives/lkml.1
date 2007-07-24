Return-Path: <linux-kernel-owner+w=401wt.eu-S932675AbXGXUvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932675AbXGXUvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 16:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755341AbXGXUvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 16:51:09 -0400
Received: from sccrmhc14.comcast.net ([204.127.200.84]:37952 "EHLO
	sccrmhc14.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759508AbXGXUvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 16:51:07 -0400
Date: Tue, 24 Jul 2007 13:51:03 -0700
From: Deepak Saxena <dsaxena@plexity.net>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH -rt] Disable lpptest on !Linux hosts
Message-ID: <20070724205103.GA32043@plexity.net>
Reply-To: dsaxena@plexity.net
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Plexity Networks
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Sadly people keep wanting to build kernels on non-Linux hosts
(cygwin & solaris) and testlpp really doesn't like to build on 
those. I have a separate patch to testlpp.c that fixes this, 
but it really makes no sense to build the tool to run on your 
cygwin host as it's meant to be run on Linux with the testlpp
module loaded.

Even this patch isn't really the right solution b/c you really want 
to cross-build the may be cross-building for another architecture from 
Linux you want cross-compile, not host compile but there's no really easy
way to cross-compile a userland binary from the kernel build w/o some 
makefile uglyiness AFAICT.

Is there some sort of -rt userland package this could move to instead 
of being in the kernel itself...?

Signed-off-by: Deepak Saxena <dsaxena@mvista.com>

Index: linux-2.6/scripts/Makefile
===================================================================
--- linux-2.6.orig/scripts/Makefile
+++ linux-2.6/scripts/Makefile
@@ -13,9 +13,12 @@ hostprogs-$(CONFIG_LOGO)         += pnmt
 hostprogs-$(CONFIG_VT)           += conmakehash
 hostprogs-$(CONFIG_PROM_CONSOLE) += conmakehash
 hostprogs-$(CONFIG_IKCONFIG)     += bin2c
+HOST_OS := $(shell uname)
+ifeq ($(HOST_OS),Linux)
 ifdef CONFIG_LPPTEST
 hostprogs-y      += testlpp
 endif
+endif
 
 always		:= $(hostprogs-y) $(hostprogs-m)
 

-- 
Deepak Saxena - dsaxena@plexity.net - http://www.plexity.net 

"Americans think their danger is terrorists. They don't understand 
the terrorists cannot take away habeas corpus, the Bill of Rights, 
the Constitution. ... The terrorists are not anything like the threat 
that we face to the Bill of Rights and the Constitution from our own
government in the name of fighting terrorisim."
  - Paul Craig Roberts
