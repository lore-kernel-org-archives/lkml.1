Return-Path: <linux-kernel-owner+w=401wt.eu-S1765748AbYBTRba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765748AbYBTRba (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 12:31:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764603AbYBTRa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 12:30:58 -0500
Received: from orannis.acns.msu.edu ([35.8.3.59]:55560 "EHLO
	orannis.acns.msu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763426AbYBTRa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 12:30:57 -0500
X-Greylist: delayed 458 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Feb 2008 12:30:56 EST
From: Joshua Roys <roysjosh@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Joshua Roys <roysjosh@gmail.com>
Subject: [PATCH] Fix a compile warning under gcc-4.2.3.
Date: Wed, 20 Feb 2008 12:23:17 -0500
Message-Id: <1203528197-24227-1-git-send-email-roysjosh@gmail.com>
X-Mailer: git-send-email 1.5.4.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sound/core/init.c: In function ‘snd_card_disconnect’:
sound/core/init.c:307: warning: the address of ‘snd_shutdown_f_ops’ will always evaluate as ‘true’

Signed-off-by: Joshua Roys <roysjosh@gmail.com>
---
 sound/core/init.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/sound/core/init.c b/sound/core/init.c
index 2cb7099..1afc58b 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -304,7 +304,6 @@ int snd_card_disconnect(struct snd_card *card)
 		list_add(&mfile->shutdown_list, &shutdown_files);
 		spin_unlock(&shutdown_lock);
 
-		fops_get(&snd_shutdown_f_ops);
 		mfile->file->f_op = &snd_shutdown_f_ops;
 		
 		mfile = mfile->next;
-- 
1.5.4.2

