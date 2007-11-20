Return-Path: <linux-kernel-owner+w=401wt.eu-S1757182AbXKTODE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182AbXKTODE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 09:03:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbXKTOCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 09:02:54 -0500
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:40268 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751621AbXKTOCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 09:02:53 -0500
Date: Tue, 20 Nov 2007 19:32:49 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org, tiwai@suse.de,
       perex@perex.cz, alsa-devel@alsa-project.org, apw@shadowen.org,
       balbir@linux.vnet.ibm.com
Subject: [PATCH] mm snapshot broken-out-2007-11-20-01-45 build failer tumbler/snapper
Message-ID: <20071120140249.GA4438@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <200711200953.lAK9qxjO030444@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200711200953.lAK9qxjO030444@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

The kernel build fails, with following error

  CC      sound/ppc/tumbler.o
sound/ppc/tumbler.c: In function ‘snapper_get_capture_source’:
sound/ppc/tumbler.c:812: error: ‘union <anonymous>’ has no member named ‘value’
sound/ppc/tumbler.c: In function ‘snapper_put_capture_source’:
sound/ppc/tumbler.c:824: error: ‘union <anonymous>’ has no member named ‘enuemerated’
make[2]: *** [sound/ppc/tumbler.o] Error 1
make[1]: *** [sound/ppc] Error 2
make: *** [sound] Error 2

Signed-off-by: Kamalesh Babulal <kamalesh@linx.vnet.ibm.com>
--
--- linux-2.6.24-rc3/sound/ppc/tumbler.c	2007-11-20 16:13:42.000000000 +0530
+++ linux-2.6.24-rc3/sound/ppc/~tumbler.c	2007-11-20 19:14:27.000000000 +0530
@@ -809,7 +809,7 @@ static int snapper_get_capture_source(st
 	struct pmac_tumbler *mix = chip->mixer_data;
 
 	snd_assert(mix, return -ENODEV);
-	ucontrol->value.enumerated.value[0] = mix->capture_source;
+	ucontrol->value.enumerated.item[0] = mix->capture_source;
 	return 0;
 }
 
@@ -821,7 +821,7 @@ static int snapper_put_capture_source(st
 	int change;
 
 	snd_assert(mix, return -ENODEV);
-	change = ucontrol->value.enuemerated.item[0] != mix->capture_source;
+	change = ucontrol->value.enumerated.item[0] != mix->capture_source;
 	if (change) {
 		mix->capture_source = !!ucontrol->value.enumerated.item[0];
 		snapper_set_capture_source(mix);


-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.

