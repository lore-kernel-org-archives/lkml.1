Return-Path: <linux-kernel-owner+w=401wt.eu-S1755348AbZLNABn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348AbZLNABn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:01:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755194AbZLMX6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 18:58:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34648 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755178AbZLMX6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:58:38 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, perex@perex.cz, tiwai@suse.de,
       torvalds@linux-foundation.org
Subject: [PATCH 1/2] Constify struct snd_ac97_build_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 01:00:29 +0100
Message-Id: <b71b96b244a04491a124add5c4bb53e89a214e3d.1260663004.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260663004.git.re.emese@gmail.com>
References: <cover.1260663004.git.re.emese@gmail.com>
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>


Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 include/sound/ac97_codec.h |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/sound/ac97_codec.h b/include/sound/ac97_codec.h
index 4940045..b90d681 100644
--- a/include/sound/ac97_codec.h
+++ b/include/sound/ac97_codec.h
@@ -419,15 +419,15 @@
 struct snd_ac97;
 
 struct snd_ac97_build_ops {
-	int (*build_3d) (struct snd_ac97 *ac97);
-	int (*build_specific) (struct snd_ac97 *ac97);
-	int (*build_spdif) (struct snd_ac97 *ac97);
-	int (*build_post_spdif) (struct snd_ac97 *ac97);
+	int (* const build_3d) (struct snd_ac97 *ac97);
+	int (* const build_specific) (struct snd_ac97 *ac97);
+	int (* const build_spdif) (struct snd_ac97 *ac97);
+	int (* const build_post_spdif) (struct snd_ac97 *ac97);
 #ifdef CONFIG_PM
-	void (*suspend) (struct snd_ac97 *ac97);
-	void (*resume) (struct snd_ac97 *ac97);
+	void (* const suspend) (struct snd_ac97 *ac97);
+	void (* const resume) (struct snd_ac97 *ac97);
 #endif
-	void (*update_jacks) (struct snd_ac97 *ac97);	/* for jack-sharing */
+	void (* const update_jacks) (struct snd_ac97 *ac97);	/* for jack-sharing */
 };
 
 struct snd_ac97_bus_ops {
@@ -477,7 +477,7 @@ struct snd_ac97_template {
 
 struct snd_ac97 {
 	/* -- lowlevel (hardware) driver specific -- */
-	struct snd_ac97_build_ops * build_ops;
+	const struct snd_ac97_build_ops * build_ops;
 	void *private_data;
 	void (*private_free) (struct snd_ac97 *ac97);
 	/* --- */
-- 
1.6.5.3

