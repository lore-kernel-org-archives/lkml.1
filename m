Return-Path: <linux-kernel-owner+w=401wt.eu-S1762081AbZBYVah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762081AbZBYVah (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 16:30:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762495AbZBYV3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 16:29:54 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:41784 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762456AbZBYV3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 16:29:53 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 7/7] sound/oss: fix sparse warning: symbol shadows an earlier
	one
To: Takashi Iwai <tiwai@suse.de>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 25 Feb 2009 22:29:47 +0100
Message-ID: <20090225212937.9226.18355.stgit@vmbox.hanneseder.net>
In-Reply-To: <20090225212551.9226.64699.stgit@vmbox.hanneseder.net>
References: <20090225212551.9226.64699.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: Move variable to a more inner scope.

Fix this sparse warning:
  sound/oss/sequencer.c:235:29: warning: symbol 'err' shadows an earlier one
  sound/oss/sequencer.c:215:13: originally declared here

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 sound/oss/sequencer.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/sound/oss/sequencer.c b/sound/oss/sequencer.c
index 5c215f7..c798746 100644
--- a/sound/oss/sequencer.c
+++ b/sound/oss/sequencer.c
@@ -212,7 +212,6 @@ int sequencer_write(int dev, struct file *file, const char __user *buf, int coun
 {
 	unsigned char event_rec[EV_SZ], ev_code;
 	int p = 0, c, ev_size;
-	int err;
 	int mode = translate_mode(file);
 
 	dev = dev >> 4;
@@ -285,7 +284,7 @@ int sequencer_write(int dev, struct file *file, const char __user *buf, int coun
 		{
 			if (!midi_opened[event_rec[2]])
 			{
-				int mode;
+				int err, mode;
 				int dev = event_rec[2];
 
 				if (dev >= max_mididev || midi_devs[dev]==NULL)

