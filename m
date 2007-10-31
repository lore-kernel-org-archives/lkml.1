Return-Path: <linux-kernel-owner+w=401wt.eu-S1757522AbXJaOLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522AbXJaOLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 10:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755384AbXJaOLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 10:11:09 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:41281 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755124AbXJaOLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 10:11:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=TShD1P+5qsKJsXmNW0U/UfN06ddcgWVnY1oS09iQ2i9NVraCXRB4iSqNW5xszJ73VisA0+f84wHTfSKqzneCpG2GK6O/AQD6BZYuLN+s+IyjjiuXG+7Mi/nr9ld2i5voKz8pPI3VwFYddPEC/YjxmcGqT5NgcTneb9eH/Pyfkso=
Message-ID: <47288CF7.5010108@googlemail.com>
Date: Wed, 31 Oct 2007 15:11:03 +0100
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071004)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, perex@perex.cz
Subject: [PATCH] Fix format warning in sound/isa/ad1848/ad1848_lib.c
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I see this warning on current git head :

...

sound/isa/ad1848/ad1848_lib.c: In function 'snd_ad1848_mce_down':
sound/isa/ad1848/ad1848_lib.c:216: warning: format '%d' expects type 'int', but argument 4 has type 'long unsigned int'

...

Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>

---

 sound/isa/ad1848/ad1848_lib.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/isa/ad1848/ad1848_lib.c b/sound/isa/ad1848/ad1848_lib.c
index a901cd1..9a64035 100644
--- a/sound/isa/ad1848/ad1848_lib.c
+++ b/sound/isa/ad1848/ad1848_lib.c
@@ -213,7 +213,7 @@ static void snd_ad1848_mce_down(struct snd_ad1848 *chip)
 	for (timeout = 12000; timeout > 0 && (inb(AD1848P(chip, REGSEL)) & AD1848_INIT); timeout--)
 		udelay(100);
 
-	snd_printdd("(1) timeout = %d\n", timeout);
+	snd_printdd("(1) timeout = %ld\n", timeout);
 
 #ifdef CONFIG_SND_DEBUG
 	if (inb(AD1848P(chip, REGSEL)) & AD1848_INIT)

