Return-Path: <linux-kernel-owner+w=401wt.eu-S1755112Ab0AVX0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112Ab0AVX0m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 18:26:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753767Ab0AVX0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 18:26:21 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:49676 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756193Ab0AVX0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 18:26:07 -0500
Message-Id: <97c85bac1af80625e1130b68e4a362a59927b3c1.1264201408.git.jan.kiszka@web.de>
In-Reply-To: <cover.1264201406.git.jan.kiszka@web.de>
References: <cover.1264201406.git.jan.kiszka@web.de>
From: Jan Kiszka <jan.kiszka@web.de>
To: David Miller <davem@davemloft.net>, Karsten Keil <isdn@linux-pingi.de>
Cc: linux-kernel@vger.kernel.org, i4ldeveloper@listserv.isdn4linux.de,
       isdn4linux@listserv.isdn4linux.de, netdev@vger.kernel.org
Date: Fri, 8 Jan 2010 12:39:05 +0100
Subject: [PATCH 23/31] CAPI: Rename datahandle_queue -> ackqueue_entry
X-Provags-ID: V01U2FsdGVkX19pDwXJEWuToJPpt7iq9RXYHNHsWjbMNP5Kodbi
	f6vfgBZUuk9/B9kR0VlOZ9jJE/kdUF6r5IEGC4UE0XxX0mnN7G
	p36dGQ6sg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This struct is describing a queue entry, not the queue itself.

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
---
 drivers/isdn/capi/capi.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
index e880639..b8019a1 100644
--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -77,7 +77,7 @@ struct capidev;
 struct capincci;
 struct capiminor;
 
-struct datahandle_queue {
+struct ackqueue_entry {
 	struct list_head	list;
 	u16			datahandle;
 };
@@ -156,7 +156,7 @@ static LIST_HEAD(capiminor_list);
 
 static int capiminor_add_ack(struct capiminor *mp, u16 datahandle)
 {
-	struct datahandle_queue *n;
+	struct ackqueue_entry *n;
 	unsigned long flags;
 
 	n = kmalloc(sizeof(*n), GFP_ATOMIC);
@@ -175,7 +175,7 @@ static int capiminor_add_ack(struct capiminor *mp, u16 datahandle)
 
 static int capiminor_del_ack(struct capiminor *mp, u16 datahandle)
 {
-	struct datahandle_queue *p, *tmp;
+	struct ackqueue_entry *p, *tmp;
 	unsigned long flags;
 
 	spin_lock_irqsave(&mp->ackqlock, flags);
@@ -194,7 +194,7 @@ static int capiminor_del_ack(struct capiminor *mp, u16 datahandle)
 
 static void capiminor_del_all_ack(struct capiminor *mp)
 {
-	struct datahandle_queue *p, *tmp;
+	struct ackqueue_entry *p, *tmp;
 	unsigned long flags;
 
 	spin_lock_irqsave(&mp->ackqlock, flags);
-- 
1.6.0.2

