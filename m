Return-Path: <linux-kernel-owner+w=401wt.eu-S1752265AbYKWU5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265AbYKWU5r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 15:57:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750818AbYKWU5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 15:57:39 -0500
Received: from casper.infradead.org ([85.118.1.10]:55036 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbYKWU5j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 15:57:39 -0500
Date: Sun, 23 Nov 2008 12:58:35 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org
Subject: [PATCH] oops: increment the oops UUID every time we oops
Message-ID: <20081123125835.45b868c6@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From c9430c243c6cdd6c3152be79561b9febac193056 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Tue, 18 Nov 2008 12:41:03 -0800
Subject: [PATCH] oops: increment the oops UUID every time we oops

... because we do want repeated same-oops to be seen by automated
tools like kerneloops.org

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 kernel/panic.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index 6513aac..a1c05f0 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -297,6 +297,8 @@ static int init_oops_id(void)
 {
 	if (!oops_id)
 		get_random_bytes(&oops_id, sizeof(oops_id));
+	else
+		oops_id++;
 
 	return 0;
 }
-- 
1.6.0.3



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
