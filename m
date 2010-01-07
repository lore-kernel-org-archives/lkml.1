Return-Path: <linux-kernel-owner+w=401wt.eu-S1756588Ab0AGBtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab0AGBtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 20:49:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756569Ab0AGBtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 20:49:07 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:54414 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756559Ab0AGBtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 20:49:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=fw8F4NcM2wcgFjnl7Ek9RtJQ4DHTxjOm4t4jWMLg+lvh2a4UbR9l5kSC/OjV+YcwX1
         zaflkfD0gtOIAp+1OlFMrbMwomW6I5FZKS4Ro+jl//bLKIq3Z/PRFK3+Nv2xKC162E4/
         rXaRuJYIv6xeqqCkmg+UrdS0/ysoaW4hz3Df8=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Beregalov <a.beregalov@gmail.com>, Jeff Dike <jdike@addtoit.com>
Subject: [PATCH 4/4] uml: line.c: avoid NULL pointer dereference
Date: Thu,  7 Jan 2010 04:48:41 +0300
Message-Id: <1262828921-29517-4-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1262828921-29517-3-git-send-email-a.beregalov@gmail.com>
References: <1262828921-29517-1-git-send-email-a.beregalov@gmail.com>
 <1262828921-29517-2-git-send-email-a.beregalov@gmail.com>
 <1262828921-29517-3-git-send-email-a.beregalov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assign tty only if line is not NULL.

Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 arch/um/drivers/line.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
index cf8a97f..8ebdc8c 100644
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -18,9 +18,10 @@ static irqreturn_t line_interrupt(int irq, void *data)
 {
 	struct chan *chan = data;
 	struct line *line = chan->line;
-	struct tty_struct *tty = line->tty;
+	struct tty_struct *tty;
 
 	if (line)
+		tty = line->tty;
 		chan_interrupt(&line->chan_list, &line->task, tty, irq);
 	return IRQ_HANDLED;
 }
-- 
1.6.6

