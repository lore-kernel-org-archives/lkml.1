Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932884Ab0BENwq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 08:52:46 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:60383 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932444Ab0BENwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 08:52:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qXgYBbE70wr0VEZ693+yKHbp2rmhDY6BWQukP/48X9Bp53nSGg5dnahiNy1RM5OEdm
         Y1qHRP4+/J/FlavvFx7LYXcc6iiorp9jed7qRUl07j7ZvDNHbBt+SwopjUzZulPI/BXF
         EEklmpX0mLzfTDvVkW24RkqlM0yOF7+0m8oHo=
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu,
       Dan Williams <dan.j.williams@intel.com>,
       Maciej Sosnowski <maciej.sosnowski@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 1/4] dmaengine: correct onstack wait_queue_head declaration
Date: Fri,  5 Feb 2010 21:52:37 +0800
Message-Id: <b1dccd762d3d04ab75d79d1d9b097d593a89f32a.1265375697.git.yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1265377920-5898-1-git-send-email-yong.zhang0@gmail.com>
References: <1265377920-5898-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use DECLARE_WAIT_QUEUE_HEAD_ONSTACK to make lockdep happy

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Maciej Sosnowski <maciej.sosnowski@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/dma/dmatest.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index 8b90516..948d563 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -467,7 +467,7 @@ err_srcs:
 
 	if (iterations > 0)
 		while (!kthread_should_stop()) {
-			DECLARE_WAIT_QUEUE_HEAD(wait_dmatest_exit);
+			DECLARE_WAIT_QUEUE_HEAD_ONSTACK(wait_dmatest_exit);
 			interruptible_sleep_on(&wait_dmatest_exit);
 		}
 
-- 
1.6.3.3

