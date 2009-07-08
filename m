Return-Path: <linux-kernel-owner+w=401wt.eu-S1759326AbZGHGL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759326AbZGHGL7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 02:11:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751540AbZGHGLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 02:11:50 -0400
Received: from ambarella-ex.ambarella.net ([63.164.14.166]:5526 "EHLO
	ambarella-ex.ambarella.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750980AbZGHGLt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 02:11:49 -0400
Content-class: urn:content-classes:message
Subject: [PATCH for-2.6.32] sound dapm: fix checking for external widgets bug 
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Date: Tue, 7 Jul 2009 23:11:46 -0700
X-MimeOLE: Produced By Microsoft Exchange V6.5
Message-ID: <90B0CE4312136749B97EBEAF5764F87403C8F77A@ambarella-ex.ambarella.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH for-2.6.32] sound dapm: fix checking for external widgets bug 
Thread-Index: Acn+OQjeqAf5NXmQT1KYnC8wh1LmrQBVo/oA
From: "Rongrong Cao" <rrcao@ambarella.com>
To: <broonie@opensource.wolfsonmicro.com>
Cc: <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>,
       <trivial@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rongrong Cao rrcao@ambarella.com

This patch is based on for-2.6.32
In SOC DAPM layer of SOUND subsystem, when add signal route (in the function snd_soc_dapm_add_route() ), 
the original code has wrong logic when dapm layer check each widget whether an external one.

---------------------------------------------------------------------------------------------------------

--- for-2.6.32/sound/soc/soc-dapm.c.orig        2009-07-08 13:33:41.000000000 +0800
+++ for-2.6.32/sound/soc/soc-dapm.c     2009-07-08 13:34:50.000000000 +0800
@@ -1290,8 +1290,8 @@ static int snd_soc_dapm_add_route(struct
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

Signed-off-by: Rongrong Cao <rrcao@ambarella.com>


********************
Best regards!
Allen (Rongrong) Cao
Ambarella Shanghai Ltd.
Tel:   (86-21) 50942311
Fax:  (86-21) 50942321



