Return-Path: <linux-kernel-owner+w=401wt.eu-S965655AbXIKVFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965655AbXIKVFl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 17:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755370AbXIKVFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 17:05:33 -0400
Received: from 251.4.221.87.dynamic.jazztel.es ([87.221.4.251]:39656 "EHLO
	traven.no-ip.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755325AbXIKVFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 17:05:31 -0400
X-Greylist: delayed 537 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Sep 2007 17:05:30 EDT
Date: Tue, 11 Sep 2007 23:05:32 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: perex@suse.cz, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 1/4] Generic AC97 mixer/modem (OSS): Use list_for_each_entry
Message-ID: <20070911210532.GG8592@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	perex@suse.cz, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20070911205632.GF8592@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070911205632.GF8592@traven>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Generic AC97 mixer/modem (OSS): Use list_for_each_entry instead of
list_for_each

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/sound/oss/ac97_codec.c b/sound/oss/ac97_codec.c
index fef56ca..0a3033b 100644
--- a/sound/oss/ac97_codec.c
+++ b/sound/oss/ac97_codec.c
@@ -815,7 +815,6 @@ int ac97_probe_codec(struct ac97_codec *codec)
 	int i;
 	char cidbuf[CODEC_ID_BUFSZ];
 	u16 f;
-	struct list_head *l;
 	struct ac97_driver *d;
 	
 	/* wait for codec-ready state */
@@ -891,8 +890,7 @@ int ac97_probe_codec(struct ac97_codec *codec)
 	mutex_lock(&codec_mutex);
 	list_add(&codec->list, &codecs);
 
-	list_for_each(l, &codec_drivers) {
-		d = list_entry(l, struct ac97_driver, list);
+	list_for_each_entry(d, &codec_drivers, list) {
 		if ((codec->model ^ d->codec_id) & d->codec_mask)
 			continue;
 		if(d->probe(codec, d) == 0)
@@ -1400,14 +1398,12 @@ EXPORT_SYMBOL(ac97_set_adc_rate);
 
 static int swap_headphone(int remove_master)
 {
-	struct list_head *l;
 	struct ac97_codec *c;
 	
 	if (remove_master) {
 		mutex_lock(&codec_mutex);
-		list_for_each(l, &codecs)
+		list_for_each_entry(c, &codecs, list)
 		{
-			c = list_entry(l, struct ac97_codec, list);
 			if (supported_mixer(c, SOUND_MIXER_PHONEOUT))
 				c->supported_mixers &= ~SOUND_MASK_PHONEOUT;
 		}

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

              We build too many walls and not enough bridges
                             (Isaac Newton)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
