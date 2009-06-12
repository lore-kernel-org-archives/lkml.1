Return-Path: <linux-kernel-owner+w=401wt.eu-S932541AbZFLQdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932541AbZFLQdn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 12:33:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764585AbZFLQZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 12:25:27 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39107 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760693AbZFLQZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 12:25:12 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 26/27] Blackfin: improve CLKIN_HZ config default
Date: Fri, 12 Jun 2009 12:24:44 -0400
Message-Id: <1244823885-22410-27-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
References: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most boards use 25000000 as the default HZ, so rather than add a whole
bunch more boards, make it the default for everyone.  This also fixes
randconfig builds as there was no default before.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/Kconfig |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 5bc1360..26e4858 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -414,12 +414,12 @@ comment "Clock/PLL Setup"
 
 config CLKIN_HZ
 	int "Frequency of the crystal on the board in Hz"
+	default "10000000" if BFIN532_IP0X
 	default "11059200" if BFIN533_STAMP
+	default "24576000" if PNAV10
+	default "25000000" # most people use this
 	default "27000000" if BFIN533_EZKIT
-	default "25000000" if (BFIN537_STAMP || BFIN527_EZKIT || H8606_HVSISTEMAS || BLACKSTAMP || BFIN526_EZBRD || BFIN538_EZKIT || BFIN518F-EZBRD)
 	default "30000000" if BFIN561_EZKIT
-	default "24576000" if PNAV10
-	default "10000000" if BFIN532_IP0X
 	help
 	  The frequency of CLKIN crystal oscillator on the board in Hz.
 	  Warning: This value should match the crystal on the board. Otherwise,
-- 
1.6.3.1

