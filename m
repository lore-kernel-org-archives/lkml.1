Return-Path: <linux-kernel-owner+w=401wt.eu-S1422656AbXBUQmM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422656AbXBUQmM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 11:42:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422666AbXBUQmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 11:42:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:51994 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422656AbXBUQmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 11:42:11 -0500
Message-ID: <45DC75A3.3090303@redhat.com>
Date: Wed, 21 Feb 2007 11:38:59 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/21] 2.6.19-stable review
References: <20070221013619.GA30227@kroah.com>
In-Reply-To: <20070221013619.GA30227@kroah.com>
Content-Type: multipart/mixed;
 boundary="------------000009020005020007030906"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000009020005020007030906
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Greg KH wrote:
> This is the start of the stable review cycle for the 2.6.19.5 release.
> 
> This will probably be the last release of the 2.6.19-stable series, so
> if there are patches that you feel should be applied to that tree,
> please let me know.

The attached patch is in 2.6.20 and fixes problems with
no sound from certain Intel HDA adapters.

--------------000009020005020007030906
Content-Type: text/plain;
 name="snd_hda_si3054_fix_oops.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="snd_hda_si3054_fix_oops.patch"

# HG changeset patch
# User Takashi Iwai <tiwai@suse.de>
# Date 1166601341 -3600
# Node ID d53318ba5eb26fbefb63d85c402cb368096436f3
# Parent e20d24388f86121d3ac6f58560e3b7acd686fd39
[ALSA] hda-codec - Don't return error at initialization of modem codec

Some modem codec seem to fail in the initialization, and this
stopped loading of the whole module although the audio is OK.
Since it's usually a non-fatal issue, the driver tries to proceed
to initialize now.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jaroslav Kysela <perex@suse.cz>

committer: Jaroslav Kysela <perex@server.perex.cz> 1166601341 +0100

--- a/sound/pci/hda/patch_si3054.c	Wed Dec 20 08:55:39 2006 +0100
+++ b/sound/pci/hda/patch_si3054.c	Wed Dec 20 08:55:41 2006 +0100
@@ -243,7 +243,8 @@ static int si3054_init(struct hda_codec 
 
 	if((val&SI3054_MEI_READY) != SI3054_MEI_READY) {
 		snd_printk(KERN_ERR "si3054: cannot initialize. EXT MID = %04x\n", val);
-		return -EACCES;
+		/* let's pray that this is no fatal error */
+		/* return -EACCES; */
 	}
 
 	SET_REG(codec, SI3054_GPIO_POLARITY, 0xffff);


--------------000009020005020007030906--
