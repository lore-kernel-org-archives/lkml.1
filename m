Return-Path: <linux-kernel-owner+w=401wt.eu-S1756191AbYJZUZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191AbYJZUZg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 16:25:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754381AbYJZUZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 16:25:28 -0400
Received: from ik-out-1112.google.com ([66.249.90.183]:56277 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305AbYJZUZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 16:25:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=V7eVVBkHd5ae2y6hTX/ZXzzGVK8nmxDQbd+TNZ5C/xo34Nbje+ptxKV27lFPG0miNo
         q1hTNvLbH8rOVH1ohNonH9W8U1goiUoVWo7POPO7nOjcE2phY+cObomlrqw+ELfUbbuO
         1OFW2WqHstPGkMRDyBWJDzDRKJAOBAFVfJBIs=
Message-ID: <6e4284620810261325n643cba26v129f2b076888bac9@mail.gmail.com>
Date: Sun, 26 Oct 2008 21:25:25 +0100
From: "Vlada Peric" <vlada.peric@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] isdn: fix section mismatch warnings in isdn/hisax
Cc: kkeil@suse.de, kai.germaschewski@gmx.de
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m9QKPedq020050

I am not subscribed to the list, please CC me directly.
Fix the following warnings (6 total):WARNING: drivers/isdn/hisax/hisax.o(.text+0x9c5): Section mismatch inreference from the function HiSax_inithardware() to the function.devinit.text:hisax_cs_setup_card()The function HiSax_inithardware() referencesthe function __devinit hisax_cs_setup_card().This is often because HiSax_inithardware lacks a __devinitannotation or the annotation of hisax_cs_setup_card is wrong.
WARNING: drivers/isdn/hisax/hisax.o(.text+0xb45): Section mismatch inreference from the function hisax_init_pcmcia() to the function.devinit.text:hisax_cs_setup_card()The function hisax_init_pcmcia() referencesthe function __devinit hisax_cs_setup_card().This is often because hisax_init_pcmcia lacks a __devinitannotation or the annotation of hisax_cs_setup_card is wrong.
Signed-off-by: Vlada Periæ <vlada.peric <at> gmail.com>Cc: Karsten Keil <kkeil <at> suse.de>Cc: Kai Germaschewski <kai.germaschewski <at> gmx.de>--- drivers/isdn/hisax/config.c |    4 ++-- 1 files changed, 2 insertions(+), 2 deletions(-)
diff --git a/drivers/isdn/hisax/config.c b/drivers/isdn/hisax/config.cindex 84d75a3..db2aebc 100644--- a/drivers/isdn/hisax/config.c+++ b/drivers/isdn/hisax/config.c@@ -1213,7 +1213,7 @@ static void HiSax_shiftcards(int idx) 		memcpy(&cards[i], &cards[i + 1], sizeof(cards[i])); }
-static int HiSax_inithardware(int *busy_flag)+static int __devinit HiSax_inithardware(int *busy_flag) { 	int foundcards = 0; 	int i = 0;@@ -1542,7 +1542,7 @@ static void __exit HiSax_exit(void) 	printk(KERN_INFO "HiSax module removed\n"); }
-int hisax_init_pcmcia(void *pcm_iob, int *busy_flag, struct IsdnCard *card)+int __devinit hisax_init_pcmcia(void *pcm_iob, int *busy_flag, structIsdnCard *card) { 	u_char ids[16]; 	int ret = -1;-- 1.6.0.3ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
