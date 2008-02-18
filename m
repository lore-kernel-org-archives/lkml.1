Return-Path: <linux-kernel-owner+w=401wt.eu-S1757695AbYBRBVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757695AbYBRBVS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 20:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbYBRBVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 20:21:06 -0500
Received: from science.horizon.com ([192.35.100.1]:11981 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750970AbYBRBVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 20:21:05 -0500
Message-ID: <20080218012103.31563.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
Date: Sun, 17 Feb 2008 20:21:03 -0500
To: mingo@elte.hu, linux-kernel@vger.kernel.org
Cc: linux@horizon.com
Subject: IO_DELAY documentation
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"make oldconfig" doesn't know how to display the per-item help, so
something like this is needed.  It was a squeeze to make all the help
text, plus option prompt, fit into 24 lines.  If you think that's not
a concern, some of the wording could be improved.

(Added text placed into the public domain; copyright abandoned.)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 864affc..8e2ceb6 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -157,6 +157,24 @@ config IO_DELAY_TYPE_NONE
 choice
 	prompt "IO delay type"
 	default IO_DELAY_0XED
+	help
+	  The original IBM PC required short pauses between consecutive
+	  accesses to its peripheral chips.  This can be provided four ways:
+
+	  * A dummy write to port 0x80 has been used for 15 years, but
+	    crashes the AMD64-based HP dv9000z laptop.  The safest option.
+	  * Port 0xED is also believed safe, and testing is requested.
+	  * Udelay is awkward to implement in the kernel due to processor
+	    speed variations, but should be extremely safe.
+	  * All but the very oldest PCs use emulations of the original
+	    peripheral chips built into a "Super I/O" chip, and usually
+	    do no need the delay at all.  The most efficient option.
+
+	  On the majority of machines, all four options should work.
+	  If you have a computer on which any of the four options
+	  (especially _0XED or _NONE) does not work, please report it,
+	  with a detailed description of the motherboard (and "lspci -nn"
+	  and "dmidecode" output), to linux-kernel@vger.kernel.org.
 
 config IO_DELAY_0X80
 	bool "port 0x80 based port-IO delay [recommended]"
