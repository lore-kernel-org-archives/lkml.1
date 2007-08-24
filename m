Return-Path: <linux-kernel-owner+w=401wt.eu-S1765741AbXHXAVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765741AbXHXAVc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 20:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932946AbXHXAVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 20:21:22 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:15196 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932168AbXHXAVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 20:21:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:resent-from:resent-to:resent-date:resent-message-id:message-id:in-reply-to:references:from:date:subject:to:cc:mime-version:content-transfer-encoding:content-disposition;
        b=lPA8T0A9m2nEZY9Iaa9dLYSZ4nZn4l0MEIwuSh1pYz0KlsD65hO2HT/nywNpaabYiwjNgTHK2wel8A5eBt++w+P8l/cPK7vP627vpzCOvAwrAnLR7EyZ9+Oe+v9oVI9H9NqBj4TRge+sEuAfZwoFa+Z0KCFZd4YBpEM4r6miiL4=
Message-Id: <40043332e9d997f833d65e8a230a6ed7dd9105fc.1187912217.git.jesper.juhl@gmail.com>
In-Reply-To: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
From: Jesper Juhl <jesper.juhl@gmail.com>
Date: Fri, 24 Aug 2007 02:18:26 +0200
Subject: [PATCH 21/30] oss: Remove unneeded vmalloc() return value casts in OSS
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Takashi Iwai <tiwai@suse.de>, Hannu Savolainen <hannu@opensound.com>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

vmalloc() returns a void pointer that we don't need to cast.
This patch should clean this up in sound/oss/.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---
 sound/oss/midibuf.c   |    4 ++--
 sound/oss/pss.c       |    6 +++---
 sound/oss/sequencer.c |    4 ++--
 sound/oss/sscape.c    |    2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/sound/oss/midibuf.c b/sound/oss/midibuf.c
index a40be0c..66f8a7f 100644
--- a/sound/oss/midibuf.c
+++ b/sound/oss/midibuf.c
@@ -177,7 +177,7 @@ int MIDIbuf_open(int dev, struct file *file)
 		return err;
 
 	parms[dev].prech_timeout = MAX_SCHEDULE_TIMEOUT;
-	midi_in_buf[dev] = (struct midi_buf *) vmalloc(sizeof(struct midi_buf));
+	midi_in_buf[dev] = vmalloc(sizeof(struct midi_buf));
 
 	if (midi_in_buf[dev] == NULL)
 	{
@@ -187,7 +187,7 @@ int MIDIbuf_open(int dev, struct file *file)
 	}
 	midi_in_buf[dev]->len = midi_in_buf[dev]->head = midi_in_buf[dev]->tail = 0;
 
-	midi_out_buf[dev] = (struct midi_buf *) vmalloc(sizeof(struct midi_buf));
+	midi_out_buf[dev] = vmalloc(sizeof(struct midi_buf));
 
 	if (midi_out_buf[dev] == NULL)
 	{
diff --git a/sound/oss/pss.c b/sound/oss/pss.c
index ece428b..b140584 100644
--- a/sound/oss/pss.c
+++ b/sound/oss/pss.c
@@ -872,7 +872,7 @@ static int pss_coproc_ioctl(void *dev_info, unsigned int cmd, void __user *arg,
 			return 0;
 
 		case SNDCTL_COPR_LOAD:
-			buf = (copr_buffer *) vmalloc(sizeof(copr_buffer));
+			buf = vmalloc(sizeof(copr_buffer));
 			if (buf == NULL)
 				return -ENOSPC;
 			if (copy_from_user(buf, arg, sizeof(copr_buffer))) {
@@ -884,7 +884,7 @@ static int pss_coproc_ioctl(void *dev_info, unsigned int cmd, void __user *arg,
 			return err;
 		
 		case SNDCTL_COPR_SENDMSG:
-			mbuf = (copr_msg *)vmalloc(sizeof(copr_msg));
+			mbuf = vmalloc(sizeof(copr_msg));
 			if (mbuf == NULL)
 				return -ENOSPC;
 			if (copy_from_user(mbuf, arg, sizeof(copr_msg))) {
@@ -908,7 +908,7 @@ static int pss_coproc_ioctl(void *dev_info, unsigned int cmd, void __user *arg,
 
 		case SNDCTL_COPR_RCVMSG:
 			err = 0;
-			mbuf = (copr_msg *)vmalloc(sizeof(copr_msg));
+			mbuf = vmalloc(sizeof(copr_msg));
 			if (mbuf == NULL)
 				return -ENOSPC;
 			data = (unsigned short *)mbuf->data;
diff --git a/sound/oss/sequencer.c b/sound/oss/sequencer.c
index 5c215f7..cfe3dd0 100644
--- a/sound/oss/sequencer.c
+++ b/sound/oss/sequencer.c
@@ -1649,13 +1649,13 @@ void sequencer_init(void)
 {
 	if (sequencer_ok)
 		return;
-	queue = (unsigned char *)vmalloc(SEQ_MAX_QUEUE * EV_SZ);
+	queue = vmalloc(SEQ_MAX_QUEUE * EV_SZ);
 	if (queue == NULL)
 	{
 		printk(KERN_ERR "sequencer: Can't allocate memory for sequencer output queue\n");
 		return;
 	}
-	iqueue = (unsigned char *)vmalloc(SEQ_MAX_QUEUE * IEV_SZ);
+	iqueue = vmalloc(SEQ_MAX_QUEUE * IEV_SZ);
 	if (iqueue == NULL)
 	{
 		printk(KERN_ERR "sequencer: Can't allocate memory for sequencer input queue\n");
diff --git a/sound/oss/sscape.c b/sound/oss/sscape.c
index 30c36d1..9d6b9b0 100644
--- a/sound/oss/sscape.c
+++ b/sound/oss/sscape.c
@@ -573,7 +573,7 @@ static int sscape_coproc_ioctl(void *dev_info, unsigned int cmd, void __user *ar
 			return 0;
 
 		case SNDCTL_COPR_LOAD:
-			buf = (copr_buffer *) vmalloc(sizeof(copr_buffer));
+			buf = vmalloc(sizeof(copr_buffer));
 			if (buf == NULL)
 				return -ENOSPC;
 			if (copy_from_user(buf, arg, sizeof(copr_buffer))) 
-- 
1.5.2.2

