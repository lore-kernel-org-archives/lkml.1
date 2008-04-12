Return-Path: <linux-kernel-owner+w=401wt.eu-S1754019AbYDLPJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbYDLPJx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 11:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752624AbYDLPJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 11:09:44 -0400
Received: from qb-out-0506.google.com ([72.14.204.239]:61675 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbYDLPJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 11:09:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:message-id:to:cc:subject:from:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=GwVfsNU9+a9tTXs97WDDcvM35IFKisoxetnBKULDjQFkHiw+narHVJhK6+TWHzDDLuFR65uGmOETj9w5Vugjlt7cHFC6BhiEy9SRMuC0MUBSSNgTvEUFx1IHXk8P5MAIeppSFWKM8wZwSdgTvnz/mJw4hJywYdAp2Xc9xWEtbFA=
Date: Sat, 12 Apr 2008 23:05:58 +0800 (CST)
Message-Id: <20080412.230558.258868812.xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, jdike@addtoit.com,
       user-mode-linux-devel@lists.sourceforge.net
Subject: [Patch] UML: Make a function static
From: WANG Cong <xiyou.wangcong@gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


arch/um/drivers/chan_kern.c::open_chan() can become static.

Compile testing passed.

Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: WANG Cong <wangcong@zeuux.org>

---
 arch/um/drivers/chan_kern.c |    2 +-
 arch/um/include/chan_kern.h |    1 -
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/um/drivers/chan_kern.c b/arch/um/drivers/chan_kern.c
index db3082b..de22a10 100644
--- a/arch/um/drivers/chan_kern.c
+++ b/arch/um/drivers/chan_kern.c
@@ -125,7 +125,7 @@ static int open_one_chan(struct chan *chan)
 	return 0;
 }
 
-int open_chan(struct list_head *chans)
+static int open_chan(struct list_head *chans)
 {
 	struct list_head *ele;
 	struct chan *chan;
diff --git a/arch/um/include/chan_kern.h b/arch/um/include/chan_kern.h
index 624b510..de5f697 100644
--- a/arch/um/include/chan_kern.h
+++ b/arch/um/include/chan_kern.h
@@ -31,7 +31,6 @@ extern void chan_interrupt(struct list_head *chans, struct delayed_work *task,
 			   struct tty_struct *tty, int irq);
 extern int parse_chan_pair(char *str, struct line *line, int device,
 			   const struct chan_opts *opts, char **error_out);
-extern int open_chan(struct list_head *chans);
 extern int write_chan(struct list_head *chans, const char *buf, int len,
 			     int write_irq);
 extern int console_write_chan(struct list_head *chans, const char *buf, 
-- 
1.5.2.4

