Return-Path: <linux-kernel-owner+w=401wt.eu-S1762827AbZCNBdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762827AbZCNBdZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753863AbZCNBUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:20:36 -0400
Received: from kroah.org ([198.145.64.141]:35092 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753176AbZCNBUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:20:18 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:36 2009
Message-Id: <20090314011036.723675766@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:10:13 -0700
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
       alan@lxorguk.ukuu.org.uk, Steve Chen <schen@mvista.com>,
       Takashi Iwai <tiwai@suse.de>
Subject: [patch 036/114] ALSA: fix excessive background noise introduced by OSS emulation rate shrink
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=alsa-fix-excessive-background-noise-introduced-by-oss-emulation-rate-shrink.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Steve Chen <schen@mvista.com>

commit 5370d96f85962769ea3df3a81cc885f257c51589 upstream.

Incorrect variable was used to get the next sample which caused S2
to be stuck with the same value resulting in loud background noise.

Signed-off-by: Steve Chen <schen@mvista.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/core/oss/rate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/core/oss/rate.c
+++ b/sound/core/oss/rate.c
@@ -157,7 +157,7 @@ static void resample_shrink(struct snd_p
 		while (dst_frames1 > 0) {
 			S1 = S2;
 			if (src_frames1-- > 0) {
-				S1 = *src;
+				S2 = *src;
 				src += src_step;
 			}
 			if (pos & ~R_MASK) {


