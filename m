Return-Path: <linux-kernel-owner+w=401wt.eu-S1765096AbZC0XxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765096AbZC0XxJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 19:53:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763644AbZC0Xdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 19:33:40 -0400
Received: from exprod6ob114.obsmtp.com ([64.18.1.32]:41392 "HELO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1763648AbZC0Xdi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 19:33:38 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] mm/sparse.c: fix build warning
Date: Fri, 27 Mar 2009 19:33:21 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE1909014E2C09@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] mm/sparse.c: fix build warning
Thread-Index: AcmvNGolsB0dpxOgQNGR/8G3dWyrwg==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 27 Mar 2009 23:33:34.0522 (UTC) FILETIME=[722901A0:01C9AF34]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix warning due to uninitialized variable.

mm/sparse.c: In function '__section_nr':
mm/sparse.c:132: warning: 'root' is used uninitialized in this function

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/mm/sparse.c b/mm/sparse.c
index 083f5b6..5657e92 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -117,7 +117,7 @@ static inline int sparse_index_init(unsigned long
section_nr, int nid)
 int __section_nr(struct mem_section* ms)
 {
 	unsigned long root_nr;
-	struct mem_section* root;
+	struct mem_section *uninitialized_var(root);
 
 	for (root_nr = 0; root_nr < NR_SECTION_ROOTS; root_nr++) {
 		root = __nr_to_section(root_nr * SECTIONS_PER_ROOT); 
