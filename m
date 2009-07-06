Return-Path: <linux-kernel-owner+w=401wt.eu-S1754763AbZGFNKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbZGFNKq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 09:10:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752428AbZGFNKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 09:10:37 -0400
Received: from ambarella-ex.ambarella.net ([63.164.14.166]:48436 "EHLO
	ambarella-ex.ambarella.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751995AbZGFNKh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 09:10:37 -0400
X-Greylist: delayed 909 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Jul 2009 09:10:37 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] sound dapm: fix check for external widgets bug (based on linux-2.6.30.1)
Date: Mon, 6 Jul 2009 05:55:27 -0700
Message-ID: <90B0CE4312136749B97EBEAF5764F87403C8F2D3@ambarella-ex.ambarella.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] sound dapm: fix check for external widgets bug (based on linux-2.6.30.1)
Thread-Index: Acn+OQjeqAf5NXmQT1KYnC8wh1LmrQ==
From: "Rongrong Cao" <rrcao@ambarella.com>
To: <broonie@opensource.wolfsonmicro.com>
Cc: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
       <trivial@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rongrong Cao rrcao@ambarella.com

This patch is based on linux-2.6.30.1
In SOC DAPM layer of SOUND subsystem, when add signal route (in the function snd_soc_dapm_add_route() ), 
the original code has wrong logic when dapm layer check each widget whether an external one.

---------------------------------------------------------------------------------------------------------

--- linux-2.6.30.1/sound/soc/soc-dapm.c.orig    2009-07-06 19:48:43.000000000 +0800
+++ linux-2.6.30.1/sound/soc/soc-dapm.c 2009-07-06 19:03:15.000000000 +0800
@@ -983,8 +983,8 @@ static int snd_soc_dapm_add_route(struct
        if (wsink->id == snd_soc_dapm_input) {
                if (wsource->id == snd_soc_dapm_micbias ||
                        wsource->id == snd_soc_dapm_mic ||
-                       wsink->id == snd_soc_dapm_line ||
-                       wsink->id == snd_soc_dapm_output)
+                       wsource->id == snd_soc_dapm_line ||
+                       wsource->id == snd_soc_dapm_output)
                        wsink->ext = 1;
        }
        if (wsource->id == snd_soc_dapm_output) {

---------------------------------------------------------------------------------------------------------

Signed-off-by: Rongrong Cao rrcao@ambarella.com

********************
Best regards!
Allen (Rongrong) Cao
Ambarella Shanghai Ltd.
Tel:   (86-21) 50942311
Fax:  (86-21) 50942321



