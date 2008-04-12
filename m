Return-Path: <linux-kernel-owner+w=401wt.eu-S1754458AbYDLPQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458AbYDLPQJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 11:16:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752855AbYDLPP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 11:15:56 -0400
Received: from qb-out-0506.google.com ([72.14.204.232]:6848 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833AbYDLPP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 11:15:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:message-id:to:cc:subject:from:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=izKk+sn7VLNCz8BnjJL0Jn5c9XBuq7VYoRlg450ySiTxb2peS7nmo5i8hoJ/V5DrEUrK31sdhaiXbRnCEXTtLefnxkx5urll08hrIknabwEE2nFuqRui4QvMFE90LB6oIqmVb5ohO/i7kT6DBuc9/m8Aa8XrMTkcDcfMy6OmvIg=
Date: Sat, 12 Apr 2008 23:12:12 +0800 (CST)
Message-Id: <20080412.231212.103246256.xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, Jeff Dike <jdike@addtoit.com>,
       user-mode-linux-devel@lists.sourceforge.net
Subject: [Patch] UML: Remove a useless function
From: WANG Cong <xiyou.wangcong@gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


arch/um/drivers/chan_kern.c::chan_out_fd() is not used by anyone.
Remove it.

Compile testing passed.

Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: WANG Cong <wangcong@zeuux.org>

---
 arch/um/drivers/chan_kern.c |   13 -------------
 arch/um/include/chan_kern.h |    1 -
 2 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/arch/um/drivers/chan_kern.c b/arch/um/drivers/chan_kern.c
index de22a10..6e51424 100644
--- a/arch/um/drivers/chan_kern.c
+++ b/arch/um/drivers/chan_kern.c
@@ -583,19 +583,6 @@ int parse_chan_pair(char *str, struct line *line, int device,
 	return 0;
 }
 
-int chan_out_fd(struct list_head *chans)
-{
-	struct list_head *ele;
-	struct chan *chan;
-
-	list_for_each(ele, chans) {
-		chan = list_entry(ele, struct chan, list);
-		if (chan->primary && chan->output)
-			return chan->fd;
-	}
-	return -1;
-}
-
 void chan_interrupt(struct list_head *chans, struct delayed_work *task,
 		    struct tty_struct *tty, int irq)
 {
diff --git a/arch/um/include/chan_kern.h b/arch/um/include/chan_kern.h
index de5f697..1e65145 100644
--- a/arch/um/include/chan_kern.h
+++ b/arch/um/include/chan_kern.h
@@ -44,7 +44,6 @@ extern void close_chan(struct list_head *chans, int delay_free_irq);
 extern int chan_window_size(struct list_head *chans, 
 			     unsigned short *rows_out, 
 			     unsigned short *cols_out);
-extern int chan_out_fd(struct list_head *chans);
 extern int chan_config_string(struct list_head *chans, char *str, int size,
 			      char **error_out);
 
-- 
1.5.2.4

