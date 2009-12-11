Return-Path: <linux-kernel-owner+w=401wt.eu-S935163AbZLKXlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935163AbZLKXlK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:41:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935130AbZLKXlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:41:03 -0500
Received: from hera.kernel.org ([140.211.167.34]:57314 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933686AbZLKXgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:36:48 -0500
Message-ID: <4B22D733.1010500@kernel.org>
Date: Fri, 11 Dec 2009 15:35:15 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: [PATCH 2/7] x86/range: check range in update range
References: <4B22D4DA.2000104@kernel.org>
In-Reply-To: <4B22D4DA.2000104@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fend off wrong range

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 kernel/range.c |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux-2.6/kernel/range.c
===================================================================
--- linux-2.6.orig/kernel/range.c
+++ linux-2.6/kernel/range.c
@@ -13,6 +13,9 @@
 
 int add_range(struct range *range, int az, int nr_range, u64 start, u64 end)
 {
+	if (start > end)
+		return nr_range;
+
 	/* Out of slots: */
 	if (nr_range >= az)
 		return nr_range;
@@ -30,6 +33,9 @@ int add_range_with_merge(struct range *r
 {
 	int i;
 
+	if (start > end)
+		return nr_range;
+
 	/* Try to merge it with old one: */
 	for (i = 0; i < nr_range; i++) {
 		u64 final_start, final_end;
@@ -59,6 +65,9 @@ void subtract_range(struct range *range,
 {
 	int i, j;
 
+	if (start > end)
+		return;
+
 	for (j = 0; j < az; j++) {
 		if (!range[j].end)
 			continue;

