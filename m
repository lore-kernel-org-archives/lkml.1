Return-Path: <linux-kernel-owner+w=401wt.eu-S1754892AbZC2P7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbZC2P7d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 11:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750850AbZC2P7X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 11:59:23 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:63114 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbZC2P7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 11:59:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Z7npDM3xhlZK6jF4x0S1l4n4cEx26j50yPzHlM3M/Gt//m3B2LrqglARpjOGETuHNB
         6nvbH+WfKLfc9Ik/r85uISUbo8CaCiIZpzdf3aVmRXgrQQ/ngslsvHxhgPjYTDtxZUf6
         CXHHiKihs3b8/1q7KBwoYnbxYnWj2r8bF5tL0=
Date: Sun, 29 Mar 2009 19:59:13 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH] Staging: line6: convert to snd_card_create()
Message-ID: <20090329155913.GK11056@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 drivers/staging/line6/audio.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/line6/audio.c b/drivers/staging/line6/audio.c
index 3aa9468..e2ac8d6 100644
--- a/drivers/staging/line6/audio.c
+++ b/drivers/staging/line6/audio.c
@@ -27,11 +27,12 @@ int line6_init_audio(struct usb_line6 *line6)
 {
 	static int dev;
 	struct snd_card *card;
+	int err;
 
-	card = snd_card_new(line6_index[dev], line6_id[dev], THIS_MODULE, 0);
-
-	if (card == NULL)
-		return -ENOMEM;
+	err = snd_card_create(line6_index[dev], line6_id[dev], THIS_MODULE, 0,
+			      &card);
+	if (err < 0)
+		return err;
 
 	line6->card = card;
 
