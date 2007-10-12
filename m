Return-Path: <linux-kernel-owner+w=401wt.eu-S1759615AbXJLHLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759615AbXJLHLS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 03:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756177AbXJLHLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 03:11:07 -0400
Received: from outbound0.mx.meer.net ([209.157.153.23]:2776 "EHLO
	outbound0.sv.meer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755700AbXJLHLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 03:11:06 -0400
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org
Subject: Re: 2.6.23-mm1 [PATCH] restore default ARCH
References: <9dktM-4YU-11@gated-at.bofh.it> <9dkWK-5Qx-7@gated-at.bofh.it>
From: Don Mullis <dwm@meer.net>
Date: Fri, 12 Oct 2007 00:10:43 -0700
In-Reply-To: <9dkWK-5Qx-7@gated-at.bofh.it> (KAMEZAWA Hiroyuki's message of "Fri\, 12 Oct 2007 07\:10\:10 +0200")
Message-ID: <87ve9c6c5o.fsf_-_@meer.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:

> [kamezawa@hannibal ref-2.6.23-mm1]$ make menuconfig
> Makefile:456: /home/kamezawa/ref-2.6.23-mm1/arch//Makefile: No such file or directory
> make: *** No rule to make target `/home/kamezawa/ref-2.6.23-mm1/arch//Makefile'.  Stop.
> ==
>
> $(ARCH) cannot be detected automatically...
>
> What information is useful for fixing this ?


This works for i386 on Ubuntu:



Definition of ARCH to the empty string defeated default native ARCH
assignment during initial run of make; eliminate said definition.

Signed-off-by: Don Mullis <dwm@meer.net>
---
 Makefile |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: linux-2.6.23-mm/Makefile
===================================================================
--- linux-2.6.23-mm.orig/Makefile       2007-10-11 23:28:43.000000000 -0700
+++ linux-2.6.23-mm/Makefile    2007-10-11 23:30:50.000000000 -0700
@@ -189,9 +189,8 @@
 # Default value for CROSS_COMPILE is not to prefix executables
 # Note: Some architectures assign CROSS_COMPILE in their arch/*/Makefile

-# The empty ARCH and CROSS_COMPILE statements exist so it is easy to
-# patch in hardcoded values for ARCH and CROSS_COMPILE
-ARCH           ?=
+# The empty CROSS_COMPILE statement exists so it is easy to
+# patch in a hardcoded value.
 CROSS_COMPILE  ?=

 # Kbuild save the ARCH and CROSS_COMPILE setting in .kbuild
