Return-Path: <linux-kernel-owner+w=401wt.eu-S1753355Ab0ADDNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab0ADDNn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 22:13:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753068Ab0ADDNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 22:13:39 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:56424 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917Ab0ADDHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 22:07:17 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Sun, 03 Jan 2010 19:04:43 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 05/29] x86: check range in update range
In-reply-to: <1262574307-17040-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1262574307-17040-6-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1262574307-17040-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fend off wrong range

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 kernel/range.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/kernel/range.c b/kernel/range.c
index 46a10c8..71e0021 100644
--- a/kernel/range.c
+++ b/kernel/range.c
@@ -13,6 +13,9 @@
 
 int add_range(struct range *range, int az, int nr_range, u64 start, u64 end)
 {
+	if (start > end)
+		return nr_range;
+
 	/* Out of slots: */
 	if (nr_range >= az)
 		return nr_range;
@@ -30,6 +33,9 @@ int add_range_with_merge(struct range *range, int az, int nr_range,
 {
 	int i;
 
+	if (start > end)
+		return nr_range;
+
 	/* Try to merge it with old one: */
 	for (i = 0; i < nr_range; i++) {
 		u64 final_start, final_end;
@@ -59,6 +65,9 @@ void subtract_range(struct range *range, int az, u64 start, u64 end)
 {
 	int i, j;
 
+	if (start > end)
+		return;
+
 	for (j = 0; j < az; j++) {
 		if (!range[j].end)
 			continue;
-- 
1.6.4.2

