Return-Path: <linux-kernel-owner+w=401wt.eu-S1753176Ab0AGP5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab0AGP5P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 10:57:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753007Ab0AGP5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 10:57:13 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:37015 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159Ab0AGP5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 10:57:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Akf5ooqXrMS9X3Ruc0XOtLBPIhEqt7i4ZcTAShibs22cPebqEg2B8IFVbitxhN+thv
         xLYaj8vAUjJ7QzsePjNjQuwdYShfQizg5XOCNoiY/VuAgG+sDCW4KnfykfBVh3tg8N/z
         wufeuEZ2wztzJKyntmUTWIoF677mCj5J1ZjEw=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Beregalov <a.beregalov@gmail.com>, Jeff Dike <jdike@addtoit.com>
Subject: [PATCH] uml: line.c: avoid NULL pointer dereference
Date: Thu,  7 Jan 2010 18:57:03 +0300
Message-Id: <1262879823-23438-1-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assign tty only if line is not NULL.

Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 arch/um/drivers/line.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
index cf8a97f..4a46253 100644
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -18,10 +18,12 @@ static irqreturn_t line_interrupt(int irq, void *data)
 {
 	struct chan *chan = data;
 	struct line *line = chan->line;
-	struct tty_struct *tty = line->tty;
+	struct tty_struct *tty;
 
-	if (line)
+	if (line) {
+		tty = line->tty;
 		chan_interrupt(&line->chan_list, &line->task, tty, irq);
+	}
 	return IRQ_HANDLED;
 }
 
-- 
1.6.6

