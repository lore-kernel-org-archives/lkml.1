Return-Path: <linux-kernel-owner+w=401wt.eu-S1759800AbZBYVaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759800AbZBYVaH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 16:30:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761551AbZBYV3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 16:29:36 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:40301 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762135AbZBYV3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 16:29:35 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 6/7] sound/oss: fix sparse warnings: different signedness
To: Takashi Iwai <tiwai@suse.de>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 25 Feb 2009 22:29:29 +0100
Message-ID: <20090225212924.9226.68460.stgit@vmbox.hanneseder.net>
In-Reply-To: <20090225212551.9226.64699.stgit@vmbox.hanneseder.net>
References: <20090225212551.9226.64699.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Change signature of 'set_volume_stereo' and 'set_volume_mono'.

Fix this sparse warnings:
  sound/oss/pss.c:545:42: warning: incorrect type in argument 2 (different signedness)
  sound/oss/pss.c:546:42: warning: incorrect type in argument 3 (different signedness)
  sound/oss/pss.c:554:59: warning: incorrect type in argument 2 (different signedness)
  sound/oss/pss.c:560:59: warning: incorrect type in argument 2 (different signedness)
  sound/oss/pss.c:566:59: warning: incorrect type in argument 2 (different signedness)

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 sound/oss/pss.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/sound/oss/pss.c b/sound/oss/pss.c
index 902b39e..83f5ee2 100644
--- a/sound/oss/pss.c
+++ b/sound/oss/pss.c
@@ -457,10 +457,9 @@ static void pss_mixer_reset(pss_confdata *devc)
 	}
 }
 
-static int set_volume_mono(unsigned __user *p, int *aleft)
+static int set_volume_mono(unsigned __user *p, unsigned int *aleft)
 {
-	int left;
-	unsigned volume;
+	unsigned int left, volume;
 	if (get_user(volume, p))
 		return -EFAULT;
 	
@@ -471,10 +470,11 @@ static int set_volume_mono(unsigned __user *p, int *aleft)
 	return 0;
 }
 
-static int set_volume_stereo(unsigned __user *p, int *aleft, int *aright)
+static int set_volume_stereo(unsigned __user *p,
+			     unsigned int *aleft,
+			     unsigned int *aright)
 {
-	int left, right;
-	unsigned volume;
+	unsigned int left, right, volume;
 	if (get_user(volume, p))
 		return -EFAULT;
 

