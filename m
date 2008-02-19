Return-Path: <linux-kernel-owner+w=401wt.eu-S1763168AbYBSWPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763168AbYBSWPm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 17:15:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757746AbYBSWNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 17:13:45 -0500
Received: from smtp3-g19.free.fr ([212.27.42.29]:54078 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755112AbYBSWNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 17:13:42 -0500
From: Jim Meyering <jim@meyering.net>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Markus Armbruster <armbru@redhat.com>, Jim Meyering <jim@meyering.net>
Subject: [PATCH] usbaudio: handle kcalloc failure
Date: Tue, 19 Feb 2008 23:13:39 +0100
Message-Id: <1203459219-14719-7-git-send-email-jim@meyering.net>
X-Mailer: git-send-email 1.5.4.2.134.g82883
In-Reply-To: <1203459219-14719-6-git-send-email-jim@meyering.net>
References: <1203459219-14719-1-git-send-email-jim@meyering.net>
 <1203459219-14719-2-git-send-email-jim@meyering.net>
 <1203459219-14719-3-git-send-email-jim@meyering.net>
 <1203459219-14719-4-git-send-email-jim@meyering.net>
 <1203459219-14719-5-git-send-email-jim@meyering.net>
 <1203459219-14719-6-git-send-email-jim@meyering.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* sound/usb/usbaudio.c (check_hw_params_convention): Handle kcalloc failure.

Signed-off-by: Jim Meyering <meyering@redhat.com>
---
 sound/usb/usbaudio.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/sound/usb/usbaudio.c b/sound/usb/usbaudio.c
index 8fa9356..b61533d 100644
--- a/sound/usb/usbaudio.c
+++ b/sound/usb/usbaudio.c
@@ -1735,6 +1735,8 @@ static int check_hw_params_convention(struct snd_usb_substream *subs)

 	channels = kcalloc(MAX_MASK, sizeof(u32), GFP_KERNEL);
 	rates = kcalloc(MAX_MASK, sizeof(u32), GFP_KERNEL);
+	if (!channels || !rates)
+		goto __out;

 	list_for_each(p, &subs->fmt_list) {
 		struct audioformat *f;
-- 
1.5.4.2.134.g82883

