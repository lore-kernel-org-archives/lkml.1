Return-Path: <linux-kernel-owner+w=401wt.eu-S1763317AbZCTX2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763317AbZCTX2V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 19:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762931AbZCTXYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 19:24:24 -0400
Received: from kroah.org ([198.145.64.141]:48509 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762929AbZCTXYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 19:24:23 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 20 15:29:23 2009
Message-Id: <20090320222923.800315181@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 20 Mar 2009 15:28:16 -0700
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
       alan@lxorguk.ukuu.org.uk, Jiri Slaby <jirislaby@gmail.com>,
       Takashi Iwai <tiwai@suse.de>
Subject: [patch 06/43] ALSA: mixart, fix lock imbalance
References: <20090320222810.386844059@mini.kroah.org>
Content-Disposition: inline; filename=alsa-mixart-fix-lock-imbalance.patch
In-Reply-To: <20090320232116.GA3375@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jiri Slaby <jirislaby@gmail.com>

commit 82f5d57163abed2e5ff271d03217b6f90c616eb8 upstream.

There is an omitted unlock in one snd_mixart_hw_params fail path. Fix it.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/mixart/mixart.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/mixart/mixart.c
+++ b/sound/pci/mixart/mixart.c
@@ -607,6 +607,7 @@ static int snd_mixart_hw_params(struct s
 	/* set the format to the board */
 	err = mixart_set_format(stream, format);
 	if(err < 0) {
+		mutex_unlock(&mgr->setup_mutex);
 		return err;
 	}
 


