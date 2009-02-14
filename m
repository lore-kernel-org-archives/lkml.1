Return-Path: <linux-kernel-owner+w=401wt.eu-S1764104AbZBNBoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764104AbZBNBoi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:44:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763440AbZBNBQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:16:51 -0500
Received: from kroah.org ([198.145.64.141]:50694 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763121AbZBNBQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:16:39 -0500
Date: Fri, 13 Feb 2009 17:13:43 -0800
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
       alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [patch 41/48] ALSA: mtpav - Fix initial value for input hwport
Message-ID: <20090214011343.GP17706@kroah.com>
References: <20090214010805.419403436@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="alsa-mtpav-fix-initial-value-for-input-hwport.patch"
In-Reply-To: <20090214011208.GA17706@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 32cf9a16f4af01573ddec1eb073111fc20a9d7d4 upstream.

Fix the initial value for input hwport.  The old value (-1) may cause
Oops when an realtime MIDI byte is received before the input port is
explicitly given.
Instead, now it's set to the broadcasting as default.

Tested-by: Holger Dehnhardt <dehnhardt@ahdehnhardt.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/drivers/mtpav.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/drivers/mtpav.c
+++ b/sound/drivers/mtpav.c
@@ -706,7 +706,6 @@ static int __devinit snd_mtpav_probe(str
 	mtp_card->card = card;
 	mtp_card->irq = -1;
 	mtp_card->share_irq = 0;
-	mtp_card->inmidiport = 0xffffffff;
 	mtp_card->inmidistate = 0;
 	mtp_card->outmidihwport = 0xffffffff;
 	init_timer(&mtp_card->timer);
@@ -719,6 +718,8 @@ static int __devinit snd_mtpav_probe(str
 	if (err < 0)
 		goto __error;
 
+	mtp_card->inmidiport = mtp_card->num_ports + MTPAV_PIDX_BROADCAST;
+
 	err = snd_mtpav_get_ISA(mtp_card);
 	if (err < 0)
 		goto __error;

