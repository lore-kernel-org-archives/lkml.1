Return-Path: <linux-kernel-owner+w=401wt.eu-S1756352AbZKUPVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352AbZKUPVo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 10:21:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756310AbZKUPVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 10:21:42 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:63090 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756256AbZKUPVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 10:21:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=okzhVyYw57ceFEJ/w5Lrs8vmyjAlCNVhzWVWmUCHynCyICYFPWcxI37N2gKJX98I03
         psZPni2xxhfOFzeIjqOzTslksC0FdhWG1js1akK7U4m2fyBuMn7A9r78QDegP/ObNypw
         Ngro8ushob3Zd1xOKg7OvjWUrumIF56qQnJic=
Message-ID: <4B08088C.8050305@gmail.com>
Date: Sat, 21 Nov 2009 16:34:36 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] JFFS2: min/max confusion?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAX_SUMMARY_SIZE was meant as a limit, not as a minimum

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 fs/jffs2/summary.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

unless I am mistaken?

diff --git a/fs/jffs2/summary.c b/fs/jffs2/summary.c
index 6caf1e1..800171d 100644
--- a/fs/jffs2/summary.c
+++ b/fs/jffs2/summary.c
@@ -23,7 +23,7 @@
 
 int jffs2_sum_init(struct jffs2_sb_info *c)
 {
-	uint32_t sum_size = max_t(uint32_t, c->sector_size, MAX_SUMMARY_SIZE);
+	uint32_t sum_size = min_t(uint32_t, c->sector_size, MAX_SUMMARY_SIZE);
 
 	c->summary = kzalloc(sizeof(struct jffs2_summary), GFP_KERNEL);
 
