Return-Path: <linux-kernel-owner+w=401wt.eu-S1753404AbXLHUjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbXLHUjS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 15:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751977AbXLHUjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 15:39:11 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:33148 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbXLHUjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 15:39:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:content-transfer-encoding:user-agent;
        b=dtQNmUYxbVhZca73qiW6fSmrfRQQT/7x3Z7lRvX18J7vsLpzwDvmg8FhTLE6nccoV64+ZzK2pFuEfXAcHvkCmtxOvuExBgDv/d6lydcglks0do45MRTz/aiLEbIsE25FX0rZEdPYkfL2UggnRh7N5oQFnVkHq82jJJ0+ki20/PA=
Date: Sat, 8 Dec 2007 21:40:17 +0100
From: Marcin =?utf-8?Q?=C5=9Alusarz?= <marcin.slusarz@gmail.com>
To: perex@perex.cz
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] via82xx: minor optimization in snd_via82xx_free
Message-ID: <20071208204012.GB5087@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

via82xx: minor optimization in snd_via82xx_free

don't check X, when we just checked !X before goto

Signed-off-by: Marcin Ślusarz <marcin.slusarz@gmail.com>
---
 sound/pci/via82xx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/pci/via82xx.c b/sound/pci/via82xx.c
index c6b68cc..a4c87a1 100644
--- a/sound/pci/via82xx.c
+++ b/sound/pci/via82xx.c
@@ -2242,9 +2242,9 @@ static int snd_via82xx_free(struct via82xx *chip)
 	for (i = 0; i < chip->num_devs; i++)
 		snd_via82xx_channel_reset(chip, &chip->devs[i]);
 	synchronize_irq(chip->irq);
-__end_hw:
 	if (chip->irq >= 0)
 		free_irq(chip->irq, chip);
+__end_hw:
 	release_and_free_resource(chip->mpu_res);
 	pci_release_regions(chip->pci);

