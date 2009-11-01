Return-Path: <linux-kernel-owner+w=401wt.eu-S1752505AbZKANfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505AbZKANfY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 08:35:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752395AbZKANfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 08:35:22 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:41471 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbZKANfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 08:35:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=aQrx6cxifZe/1YKzdqoIL7cwux69boevcLfywBgUq2CGUnYYx8PsB/SF0Ah6DaRwGk
         /DZRuASZ7nbDZ7V6130wIAkVUlxFVmRZA25tKyGBVobBBRb2hPaspdYvYy6wzEWtlQZZ
         sGMWi+gwXV4HkhSvfNctage+4Zxt20WqMmeF4=
Message-ID: <4AED9132.2060507@gmail.com>
Date: Sun, 01 Nov 2009 14:46:26 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Mikael Starvik <starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-cris-kernel@axis.com,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] CRIS v32: Should index be positive?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

`port' is used as index for writing to pins during
allocation/deallocation. It should be positive.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 arch/cris/arch-v32/kernel/pinmux.c  |    4 ++--
 arch/cris/arch-v32/mach-a3/pinmux.c |    2 +-
 arch/cris/arch-v32/mach-fs/pinmux.c |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

Found by code analysis, is it required?

diff --git a/arch/cris/arch-v32/kernel/pinmux.c b/arch/cris/arch-v32/kernel/pinmux.c
index 6eb54ea..f6f3637 100644
--- a/arch/cris/arch-v32/kernel/pinmux.c
+++ b/arch/cris/arch-v32/kernel/pinmux.c
@@ -54,7 +54,7 @@ crisv32_pinmux_alloc(int port, int first_pin, int last_pin, enum pin_mode mode)
 
 	crisv32_pinmux_init();
 
-	if (port > PORTS)
+	if (port > PORTS || port < 0)
 		return -EINVAL;
 
 	spin_lock_irqsave(&pinmux_lock, flags);
@@ -197,7 +197,7 @@ crisv32_pinmux_dealloc(int port, int first_pin, int last_pin)
 
 	crisv32_pinmux_init();
 
-	if (port > PORTS)
+	if (port > PORTS || port < 0)
 		return -EINVAL;
 
 	spin_lock_irqsave(&pinmux_lock, flags);
diff --git a/arch/cris/arch-v32/mach-a3/pinmux.c b/arch/cris/arch-v32/mach-a3/pinmux.c
index 0a28c9b..18648ef 100644
--- a/arch/cris/arch-v32/mach-a3/pinmux.c
+++ b/arch/cris/arch-v32/mach-a3/pinmux.c
@@ -242,7 +242,7 @@ crisv32_pinmux_dealloc(int port, int first_pin, int last_pin)
 
 	crisv32_pinmux_init();
 
-	if (port > PORTS)
+	if (port > PORTS || port < 0)
 		return -EINVAL;
 
 	spin_lock_irqsave(&pinmux_lock, flags);
diff --git a/arch/cris/arch-v32/mach-fs/pinmux.c b/arch/cris/arch-v32/mach-fs/pinmux.c
index d722ad9..38f29ee 100644
--- a/arch/cris/arch-v32/mach-fs/pinmux.c
+++ b/arch/cris/arch-v32/mach-fs/pinmux.c
@@ -54,7 +54,7 @@ crisv32_pinmux_alloc(int port, int first_pin, int last_pin, enum pin_mode mode)
 
 	crisv32_pinmux_init();
 
-	if (port > PORTS)
+	if (port > PORTS || port < 0)
 		return -EINVAL;
 
 	spin_lock_irqsave(&pinmux_lock, flags);
@@ -195,7 +195,7 @@ int crisv32_pinmux_dealloc(int port, int first_pin, int last_pin)
 
 	crisv32_pinmux_init();
 
-	if (port > PORTS)
+	if (port > PORTS || port < 0)
 		return -EINVAL;
 
 	spin_lock_irqsave(&pinmux_lock, flags);
