Return-Path: <linux-kernel-owner+w=401wt.eu-S1761820AbZCTXQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761820AbZCTXQy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 19:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759152AbZCTXNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 19:13:42 -0400
Received: from kroah.org ([198.145.64.141]:53085 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758939AbZCTXNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 19:13:40 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 20 15:27:10 2009
Message-Id: <20090320222710.351342480@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 20 Mar 2009 15:26:20 -0700
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
Subject: [patch 09/32] ALSA: pcm_oss, fix locking typo
References: <20090320222611.872315885@mini.kroah.org>
Content-Disposition: inline; filename=alsa-pcm_oss-fix-locking-typo.patch
In-Reply-To: <20090320231037.GA2732@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jiri Slaby <jirislaby@gmail.com>

commit 91054598f794fb5d8a0b1e747ff8e2e8fc2115b3 upstream.

s/mutex_lock/mutex_unlock/ on 2 fail paths in snd_pcm_oss_proc_write.
Probably a typo, lock should be unlocked when leaving the function.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/core/oss/pcm_oss.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/core/oss/pcm_oss.c
+++ b/sound/core/oss/pcm_oss.c
@@ -2854,7 +2854,7 @@ static void snd_pcm_oss_proc_write(struc
 			setup = kmalloc(sizeof(*setup), GFP_KERNEL);
 			if (! setup) {
 				buffer->error = -ENOMEM;
-				mutex_lock(&pstr->oss.setup_mutex);
+				mutex_unlock(&pstr->oss.setup_mutex);
 				return;
 			}
 			if (pstr->oss.setup_list == NULL)
@@ -2868,7 +2868,7 @@ static void snd_pcm_oss_proc_write(struc
 			if (! template.task_name) {
 				kfree(setup);
 				buffer->error = -ENOMEM;
-				mutex_lock(&pstr->oss.setup_mutex);
+				mutex_unlock(&pstr->oss.setup_mutex);
 				return;
 			}
 		}


