Return-Path: <linux-kernel-owner+w=401wt.eu-S1760731AbZAJBGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760731AbZAJBGf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 20:06:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752879AbZAJBG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 20:06:27 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:43569 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbZAJBG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 20:06:26 -0500
Date: Fri, 9 Jan 2009 17:01:49 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH] resources: fix parameter name and kernel-doc
Message-Id: <20090109170149.797d6382.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4967F486.01B4:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix __request_region() parameter kernel-doc notation and
parameter name:

Warning(linux-2.6.28-git10//kernel/resource.c:627): No description found for parameter 'flags'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 include/linux/ioport.h |    3 ++-
 kernel/resource.c      |    1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

--- linux-next-20090109.orig/include/linux/ioport.h
+++ linux-next-20090109/include/linux/ioport.h
@@ -143,7 +143,8 @@ static inline unsigned long resource_typ
 
 extern struct resource * __request_region(struct resource *,
 					resource_size_t start,
-					resource_size_t n, const char *name, int relaxed);
+					resource_size_t n,
+					const char *name, int flags);
 
 /* Compatibility cruft */
 #define release_region(start,n)	__release_region(&ioport_resource, (start), (n))
--- linux-next-20090109.orig/kernel/resource.c
+++ linux-next-20090109/kernel/resource.c
@@ -620,6 +620,7 @@ resource_size_t resource_alignment(struc
  * @start: resource start address
  * @n: resource region size
  * @name: reserving caller's ID string
+ * @flags: IO resource flags
  */
 struct resource * __request_region(struct resource *parent,
 				   resource_size_t start, resource_size_t n,
