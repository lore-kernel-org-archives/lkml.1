Return-Path: <linux-kernel-owner+w=401wt.eu-S1758077AbYGDAs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077AbYGDAs1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 20:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754222AbYGDAsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 20:48:19 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:62868 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127AbYGDAsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 20:48:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=BkXIOfdXOtKp7N/MdFSQrWIRtyG+cfFFxCv7oBgtnNKUXHgFhqoAXcj6AQmmnFbYth
         y9FfgxoEBLjRbCP6RBt8t81x50wYuiHbQaW0535kvJlX0MGYKpko/XKfCD5SSl5a05UO
         EJIFN/5iKkabQEmxvuYmjxIC4bGj8T1XfU1e0=
Subject: [PATCH 2/2] input: ads7846.c sparse lock annotation
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 03 Jul 2008 17:47:09 -0700
Message-Id: <1215132429.16647.47.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/input/touchscreen/ads7846.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/input/touchscreen/ads7846.c b/drivers/input/touchscreen/ads7846.c
index 4d06032..d8aaea1 100644
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -739,6 +739,8 @@ static irqreturn_t ads7846_irq(int irq, void *handle)
 
 /* Must be called with ts->lock held */
 static void ads7846_disable(struct ads7846 *ts)
+__acquires(&ts->lock)
+__releases(&ts->lock)
 {
 	if (ts->disabled)
 		return;
-- 
1.5.6.1.281.g1087e

