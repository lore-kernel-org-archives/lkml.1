Return-Path: <linux-kernel-owner+w=401wt.eu-S1756986AbZBJXma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756986AbZBJXma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 18:42:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754017AbZBJXmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 18:42:19 -0500
Received: from exprod6og112.obsmtp.com ([64.18.1.29]:55201 "HELO
	exprod6og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753823AbZBJXmS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 18:42:18 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] mm: fix build  warning
Date: Tue, 10 Feb 2009 18:42:12 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090120C425@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] mm: fix build  warning
Thread-Index: AcmL2TI9gwGiSVBHQlyLcnZwWBflxw==
From: "hartleys" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 10 Feb 2009 23:42:13.0524 (UTC) FILETIME=[32EBAD40:01C98BD9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch fixes a build warning in mm/sparse.c

mm/sparse.c: In function '__section_nr':
mm/sparse.c:131: warning: 'root' is used uninitialized in this function

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/mm/sparse.c b/mm/sparse.c
index 083f5b6..467edc1 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -117,7 +117,7 @@ static inline int sparse_index_init(unsigned long
section_nr, int nid)
 int __section_nr(struct mem_section* ms)
 {
 	unsigned long root_nr;
-	struct mem_section* root;
+	struct mem_section* root = NULL;
 
 	for (root_nr = 0; root_nr < NR_SECTION_ROOTS; root_nr++) {
 		root = __nr_to_section(root_nr * SECTIONS_PER_ROOT); 
