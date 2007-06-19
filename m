Return-Path: <linux-kernel-owner+w=401wt.eu-S1759881AbXFSWrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759881AbXFSWrv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 18:47:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756494AbXFSWrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 18:47:35 -0400
Received: from outbound-fra.frontbridge.com ([62.209.45.174]:9649 "EHLO
	outbound4-fra-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759214AbXFSWrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 18:47:33 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: 8C3DB987-180B-4465-9446-45C15473FD3E
Date: Wed, 20 Jun 2007 00:48:15 +0200
From: "Andreas Herrmann" <andreas.herrmann3@amd.com>
To: linux-kernel@vger.kernel.org, geert@linux-m68k.org
Subject: [PATCH 1/12] m68k: fix annoying Kconfig warning
Message-ID: <20070619224815.GC5193@alberich.amd.com>
MIME-Version: 1.0
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 19 Jun 2007 22:47:19.0337 (UTC)
 FILETIME=[CAC12190:01C7B2C3]
X-WSS-ID: 6A6683701S4852137-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix Kconfig build warning:

scripts/kconfig/mconf arch/x86_64/Kconfig
drivers/input/keyboard/Kconfig:170:warning: 'select' used by config symbol 'KEYBOARD_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'
drivers/input/mouse/Kconfig:182:warning: 'select' used by config symbol 'MOUSE_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/m68k/Kconfig              |    3 ---
 drivers/input/keyboard/Kconfig |    4 ++++
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index 85cdd23..a86e2e9 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -418,9 +418,6 @@ config STRAM_PROC
 	help
 	  Say Y here to report ST-RAM usage statistics in /proc/stram.
 
-config ATARI_KBD_CORE
-	bool
-
 config HEARTBEAT
 	bool "Use power LED as a heartbeat" if AMIGA || APOLLO || ATARI || MAC ||Q40
 	default y if !AMIGA && !APOLLO && !ATARI && !MAC && !Q40 && HP300
diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index bd707b8..e89394c 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -164,6 +164,10 @@ config KEYBOARD_AMIGA
 	  To compile this driver as a module, choose M here: the
 	  module will be called amikbd.
 
+config ATARI_KBD_CORE
+	depends on ATARI
+	bool
+
 config KEYBOARD_ATARI
 	tristate "Atari keyboard"
 	depends on ATARI
-- 
1.5.0.7




