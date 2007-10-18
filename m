Return-Path: <linux-kernel-owner+w=401wt.eu-S932954AbXJRBxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932954AbXJRBxt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 21:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760784AbXJRBxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 21:53:39 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:45351 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760336AbXJRBxi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 21:53:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=hWrLKYQDKdMuIbnDcbi2V8Dx3ttTcgVqLziXQVL5LiCwAAZsKpdcfPcCzpOMM4HcDFSzFaWjoku07H0moVMnFcInLhaHho8glRdcW3/Q/mWkAqpS7VIRuAZ2XPWM/1Hv9/IyXaoUgWSOBDW+49TsI6aUjU2KZGTKqSmsl7riLSw=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Thomas Meyer <thomas@m3y3r.de>
Subject: Re: hda-intel: no soundcard with current linus' git tree
Date: Thu, 18 Oct 2007 03:53:08 +0200
User-Agent: KMail/1.9.6
Cc: Takashi Iwai <tiwai@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       alsa-devel@alsa-project.org
References: <471538C2.80806@m3y3r.de> <471651C4.20907@m3y3r.de> <200710180351.50618.maximlevitsky@gmail.com>
In-Reply-To: <200710180351.50618.maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200710180353.08638.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 0824b077b75c19253b45c5a455775c331acd54ee Mon Sep 17 00:00:00 2001
From: Maxim Levitsky <maximlevitsky@gmail.com>
Date: Thu, 18 Oct 2007 03:35:37 +0200
Subject: [PATCH] [HDA] [STAC] Since there is now a master volume control,
don't call the headphone output "Master", it isn't strictly correct anyway

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 pci/hda/patch_sigmatel.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/pci/hda/patch_sigmatel.c b/pci/hda/patch_sigmatel.c
index 6dffa54..7f157a6 100644
--- a/pci/hda/patch_sigmatel.c
+++ b/pci/hda/patch_sigmatel.c
@@ -1907,12 +1907,7 @@ static int stac92xx_auto_create_hp_ctls(struct hda_codec *codec,
 			return err;
 	}
 	if (spec->multiout.hp_nid) {
-		const char *pfx;
-		if (old_num_dacs == spec->multiout.num_dacs)
-			pfx = "Master";
-		else
-			pfx = "Headphone";
-		err = create_controls(spec, pfx, spec->multiout.hp_nid, 3);
+		err = create_controls(spec, "Headphone", spec->multiout.hp_nid, 3);
 		if (err < 0)
 			return err;
 	}
-- 
1.5.3.4

