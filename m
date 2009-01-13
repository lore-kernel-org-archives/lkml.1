Return-Path: <linux-kernel-owner+w=401wt.eu-S1759375AbZAMBc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759375AbZAMBc7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 20:32:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758161AbZAMB3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 20:29:06 -0500
Received: from kroah.org ([198.145.64.141]:36013 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757289AbZAMB3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 20:29:04 -0500
Date: Mon, 12 Jan 2009 17:27:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Stanley Miao <stanley.miao@windriver.com>,
       Jarkko Nikula <jarkko.nikula@nokia.com>, Takashi Iwai <tiwai@suse.de>
Subject: [patch 11/21] ALSA: Fix a Oops bug in omap soc driver.
Message-ID: <20090113012711.GL4512@kroah.com>
References: <20090113012006.063755472@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-fix-a-oops-bug-in-omap-soc-driver.patch"
In-Reply-To: <20090113012633.GA4512@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stanley Miao <stanley.miao@windriver.com>

commit 19b3f31609dc8be3a56c78dcb7da723f10f7009c upstream.

There will be a Oops or frequent underrun messages when playing music with
omap soc driver, this is because a data region is incorretly sized, other data
region will be overwriten when writing to this data region.

Signed-off-by: Stanley Miao <stanley.miao@windriver.com>
Acked-by: Jarkko Nikula <jarkko.nikula@nokia.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/soc/omap/omap-pcm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/omap/omap-pcm.c
+++ b/sound/soc/omap/omap-pcm.c
@@ -231,7 +231,7 @@ static int omap_pcm_open(struct snd_pcm_
 	if (ret < 0)
 		goto out;
 
-	prtd = kzalloc(sizeof(prtd), GFP_KERNEL);
+	prtd = kzalloc(sizeof(*prtd), GFP_KERNEL);
 	if (prtd == NULL) {
 		ret = -ENOMEM;
 		goto out;

