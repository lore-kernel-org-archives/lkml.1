Return-Path: <linux-kernel-owner+w=401wt.eu-S1752882AbXCEVBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbXCEVBf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 16:01:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933200AbXCEU6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 15:58:45 -0500
Received: from mbox.ssc.unict.it ([151.97.230.9]:46876 "EHLO ssc.unict.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933228AbXCEU6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 15:58:12 -0500
From: "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>
Subject: [PATCH 08/11] uml: mark both consoles as CON_ANYTIME
Date: Mon, 05 Mar 2007 21:49:07 +0100
To: Andrew Morton <akpm@osdl.org>
Cc: Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Message-Id: <20070305204906.9072.62771.stgit@americanbeauty.home.lan>
In-Reply-To: <20070305204229.9072.17032.stgit@americanbeauty.home.lan>
References: <20070305204229.9072.17032.stgit@americanbeauty.home.lan>
Content-Type: text/plain; charset=utf-8; format=fixed
User-Agent: StGIT/0.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by alpha.home.local id l25L2UZJ008317

From: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>

Since both UML consoles do not use percpu variables, they may be called when the
cpu is still offline, and they may be marked CON_ANYTIME (this is documented in
kernel/printk.c, grep for CON_ANYTIME to find mentions of this).

Works well in testing done with lock debug enabled, should be safe but is
not needed for next release.

This would probably help also stderr_console.c, but this is yet to test.

Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
---

 arch/um/drivers/ssl.c           |    2 +-
 arch/um/drivers/stdio_console.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/um/drivers/ssl.c b/arch/um/drivers/ssl.c
index fc22b9b..4b382a6 100644
--- a/arch/um/drivers/ssl.c
+++ b/arch/um/drivers/ssl.c
@@ -179,7 +179,7 @@ static struct console ssl_cons = {
 	.write		= ssl_console_write,
 	.device		= ssl_console_device,
 	.setup		= ssl_console_setup,
-	.flags		= CON_PRINTBUFFER,
+	.flags		= CON_PRINTBUFFER|CON_ANYTIME,
 	.index		= -1,
 };
 
diff --git a/arch/um/drivers/stdio_console.c b/arch/um/drivers/stdio_console.c
index 7ff0b0f..76d1f1c 100644
--- a/arch/um/drivers/stdio_console.c
+++ b/arch/um/drivers/stdio_console.c
@@ -153,7 +153,7 @@ static struct console stdiocons = {
 	.write		= uml_console_write,
 	.device		= uml_console_device,
 	.setup		= uml_console_setup,
-	.flags		= CON_PRINTBUFFER,
+	.flags		= CON_PRINTBUFFER|CON_ANYTIME,
 	.index		= -1,
 };
 


