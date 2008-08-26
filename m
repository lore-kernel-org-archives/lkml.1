Return-Path: <linux-kernel-owner+w=401wt.eu-S1754403AbYHZAh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403AbYHZAh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 20:37:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752920AbYHZAhP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 20:37:15 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57503 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbYHZAhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 20:37:14 -0400
Date: Tue, 26 Aug 2008 10:37:08 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Travis Place <wishie@wishie.net>, Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: origin tree build failure
Message-Id: <20080826103708.3b4c3269.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next build (x86_64 allmodconfig) failed like this:

sound/pci/ca0106/ca0106_main.c:263: error: syntax error before '{' token
sound/pci/ca0106/ca0106_main.c:264: error: field name not in record or union initializer
sound/pci/ca0106/ca0106_main.c:264: error: (near initialization for 'ca0106_chip_details')
sound/pci/ca0106/ca0106_main.c:264: warning: missing braces around initializer
sound/pci/ca0106/ca0106_main.c:264: warning: (near initialization for 'ca0106_chip_details[10]')
sound/pci/ca0106/ca0106_main.c:264: warning: initialization makes integer from pointer without a cast
sound/pci/ca0106/ca0106_main.c:264: error: initializer element is not computable at load time
sound/pci/ca0106/ca0106_main.c:264: error: (near initialization for 'ca0106_chip_details[10].serial')
sound/pci/ca0106/ca0106_main.c:265: error: field name not in record or union initializer
sound/pci/ca0106/ca0106_main.c:265: error: (near initialization for 'ca0106_chip_details')
sound/pci/ca0106/ca0106_main.c:266: error: field name not in record or union initializer
sound/pci/ca0106/ca0106_main.c:266: error: (near initialization for 'ca0106_chip_details')
sound/pci/ca0106/ca0106_main.c:272: error: syntax error before '{' token

This is just Linus' tree (head commit
d25e26b61d59370eee8b7f2634641eb0fa76e952 "[x86] Clean up MAXSMP Kconfig,
and limit NR_CPUS to 512").

Introduced by commit c5d44423d55e3abca7b1d544af9e4c97ec203999 ("ALSA:
CA0106 on MSI K8N Diamond PLUS Motherboard").

I added the following patch.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 26 Aug 2008 10:33:32 +1000
Subject: [PATCH] ALSA: fix for CA0106 on MSI K8N Diamond PLUS Motherboard

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 sound/pci/ca0106/ca0106_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/pci/ca0106/ca0106_main.c b/sound/pci/ca0106/ca0106_main.c
index 03a274b..6abe8a3 100644
--- a/sound/pci/ca0106/ca0106_main.c
+++ b/sound/pci/ca0106/ca0106_main.c
@@ -254,7 +254,7 @@ static struct snd_ca0106_details ca0106_chip_details[] = {
 	   .name   = "MSI K8N Diamond MB",
 	   .gpio_type = 2,
 	   .i2c_adc = 1,
-	   .spi_dac = 2 }
+	   .spi_dac = 2 },
 	 /* Shuttle XPC SD31P which has an onboard Creative Labs
 	  * Sound Blaster Live! 24-bit EAX
 	  * high-definition 7.1 audio processor".
-- 
1.5.6.3

