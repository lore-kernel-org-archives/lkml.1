Return-Path: <linux-kernel-owner+w=401wt.eu-S1761081AbZBYV2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761081AbZBYV2n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 16:28:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756606AbZBYV2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 16:28:34 -0500
Received: from mail-bw0-f178.google.com ([209.85.218.178]:41784 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755981AbZBYV2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 16:28:33 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 2/7] sound/usb/usx2y: fix sparse warning: do-while statement
	is not a compound ...
To: Takashi Iwai <tiwai@suse.de>
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 25 Feb 2009 22:28:26 +0100
Message-ID: <20090225212656.9226.49544.stgit@vmbox.hanneseder.net>
In-Reply-To: <20090225212551.9226.64699.stgit@vmbox.hanneseder.net>
References: <20090225212551.9226.64699.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this sparse warning:
  sound/usb/usx2y/usbusx2y.c:231:33: warning: do-while statement is not a compound statement

Signed-off-by: Hannes Eder <hannes@hanneseder.net>

---

This patch generates a checkpatch.pl warning (line is 84 characters long), but
the formating of the entire file is so broken, the longest line is >150 chars long,
so I leave it as is.

 sound/usb/usx2y/usbusx2y.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/usb/usx2y/usbusx2y.c b/sound/usb/usx2y/usbusx2y.c
index af8b849..5ce0da2 100644
--- a/sound/usb/usx2y/usbusx2y.c
+++ b/sound/usb/usx2y/usbusx2y.c
@@ -227,9 +227,9 @@ static void i_usX2Y_In04Int(struct urb *urb)
 	
 	if (usX2Y->US04) {
 		if (0 == usX2Y->US04->submitted)
-			do
+			do {
 				err = usb_submit_urb(usX2Y->US04->urb[usX2Y->US04->submitted++], GFP_ATOMIC);
-			while (!err && usX2Y->US04->submitted < usX2Y->US04->len);
+			} while (!err && usX2Y->US04->submitted < usX2Y->US04->len);
 	} else
 		if (us428ctls && us428ctls->p4outLast >= 0 && us428ctls->p4outLast < N_us428_p4out_BUFS) {
 			if (us428ctls->p4outLast != us428ctls->p4outSent) {

