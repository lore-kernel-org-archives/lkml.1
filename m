Return-Path: <linux-kernel-owner+w=401wt.eu-S1761824AbXFTK1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761824AbXFTK1P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 06:27:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760954AbXFTKXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 06:23:50 -0400
Received: from mail.suse.de ([195.135.220.2]:48428 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757551AbXFTKXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 06:23:39 -0400
From: Andi Kleen <ak@suse.de>
References: <200706201223.443613000@suse.de>
In-Reply-To: <200706201223.443613000@suse.de>
To: geert@linux-m68k.org, zippel@linux-m68k.org, torvalds@osdl.org,
       linux-kernel@vger.kernel.org, patches@x86-64.org
Subject: [PATCH for 2.6.22] [5/10] x86_64: Quieten Atari keyboard warnings in Kconfig
Message-Id: <20070620102333.CFC9514ACF@wotan.suse.de>
Date: Wed, 20 Jun 2007 12:23:33 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Not directly related to x86, but I got tired of seeing these warnings on every
kconfig update when building on a non m68k box:

drivers/input/keyboard/Kconfig:170:warning: 'select' used by config symbol 'KEYBOARD_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'
drivers/input/mouse/Kconfig:182:warning: 'select' used by config symbol 'MOUSE_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'

I moved the definition of ATARI_KBD_CORE into drivers/input/keyboard/Kconfig 
so it's always seen by Kconfig.

Cc: geert@linux-m68k.org
Cc: zippel@linux-m68k.org

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/m68k/Kconfig              |    3 ---
 drivers/input/keyboard/Kconfig |    3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

Index: linux/drivers/input/keyboard/Kconfig
===================================================================
--- linux.orig/drivers/input/keyboard/Kconfig
+++ linux/drivers/input/keyboard/Kconfig
@@ -164,6 +164,9 @@ config KEYBOARD_AMIGA
 	  To compile this driver as a module, choose M here: the
 	  module will be called amikbd.
 
+config ATARI_KBD_CORE
+	bool
+
 config KEYBOARD_ATARI
 	tristate "Atari keyboard"
 	depends on ATARI
Index: linux/arch/m68k/Kconfig
===================================================================
--- linux.orig/arch/m68k/Kconfig
+++ linux/arch/m68k/Kconfig
@@ -418,9 +418,6 @@ config STRAM_PROC
 	help
 	  Say Y here to report ST-RAM usage statistics in /proc/stram.
 
-config ATARI_KBD_CORE
-	bool
-
 config HEARTBEAT
 	bool "Use power LED as a heartbeat" if AMIGA || APOLLO || ATARI || MAC ||Q40
 	default y if !AMIGA && !APOLLO && !ATARI && !MAC && !Q40 && HP300
