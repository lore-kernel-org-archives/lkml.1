Return-Path: <linux-kernel-owner+w=401wt.eu-S1755603AbZKBQDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603AbZKBQDz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 11:03:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755367AbZKBQDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 11:03:54 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:50127 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755236AbZKBQDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 11:03:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=U3irtm6mPcjG6TxjLz61/zQGK1g5RgF75Av2hn9w4A1cwQI6viQe3vMnfjXElur4nQ
         liwi5hHhwLMkeWASG5aTU7npFP8g2ZbIsKCTQTvGPUciKHW56wDdqrGe1KB3fchRq9gm
         hHOYPIdBxUPxE10mXKCgdw/tiL7zBJKYZ1mPI=
Message-ID: <4AEF0572.9020609@gmail.com>
Date: Mon, 02 Nov 2009 17:14:42 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] sh: Make sure indexes are positive
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The indexes are signed, make sure they are not negative
when we read array elements.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 arch/sh/boards/mach-highlander/setup.c |    2 +-
 arch/sh/boards/mach-r2d/irq.c          |    2 +-
 arch/sh/mm/numa.c                      |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

Found by code analysis, is this required?

diff --git a/arch/sh/boards/mach-highlander/setup.c b/arch/sh/boards/mach-highlander/setup.c
index 566e69d..f663c14 100644
--- a/arch/sh/boards/mach-highlander/setup.c
+++ b/arch/sh/boards/mach-highlander/setup.c
@@ -384,7 +384,7 @@ static unsigned char irl2irq[HL_NR_IRL];
 
 static int highlander_irq_demux(int irq)
 {
-	if (irq >= HL_NR_IRL || !irl2irq[irq])
+	if (irq >= HL_NR_IRL || irq < 0 || !irl2irq[irq])
 		return irq;
 
 	return irl2irq[irq];
diff --git a/arch/sh/boards/mach-r2d/irq.c b/arch/sh/boards/mach-r2d/irq.c
index c70fece..78d7b27 100644
--- a/arch/sh/boards/mach-r2d/irq.c
+++ b/arch/sh/boards/mach-r2d/irq.c
@@ -116,7 +116,7 @@ static unsigned char irl2irq[R2D_NR_IRL];
 
 int rts7751r2d_irq_demux(int irq)
 {
-	if (irq >= R2D_NR_IRL || !irl2irq[irq])
+	if (irq >= R2D_NR_IRL || irq < 0 || !irl2irq[irq])
 		return irq;
 
 	return irl2irq[irq];
diff --git a/arch/sh/mm/numa.c b/arch/sh/mm/numa.c
index 9b784fd..6c52444 100644
--- a/arch/sh/mm/numa.c
+++ b/arch/sh/mm/numa.c
@@ -60,7 +60,7 @@ void __init setup_bootmem_node(int nid, unsigned long start, unsigned long end)
 	unsigned long bootmem_paddr;
 
 	/* Don't allow bogus node assignment */
-	BUG_ON(nid > MAX_NUMNODES || nid == 0);
+	BUG_ON(nid > MAX_NUMNODES || nid <= 0);
 
 	start_pfn = start >> PAGE_SHIFT;
 	end_pfn = end >> PAGE_SHIFT;
