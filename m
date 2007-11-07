Return-Path: <linux-kernel-owner+w=401wt.eu-S1759404AbXKGOkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759404AbXKGOkB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 09:40:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758519AbXKGOjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 09:39:52 -0500
Received: from wx-out-0506.google.com ([66.249.82.231]:9435 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758524AbXKGOjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 09:39:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=L1IKMY3WpNZd1PkPle/G53ZslxUVWAIZCQYcxsmS8Ca6BF2rbpGb6eVeLZegUxFLnr9XjSYGgJT7p+DIYZvW2khuThVMA5Xw+8ZUcYvXMiOzD+nOmHylNLFVISWX4W23XSPDXbcmDFUReGVIu4jON2snCzJ6e51CWqZZOysZKSg=
Message-ID: <961aa3350711070639p18cb51f9gc2a3f31e264b7e27@mail.gmail.com>
Date: Wed, 7 Nov 2007 23:39:49 +0900
From: "Akinobu Mita" <akinobu.mita@gmail.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>,
       "Christoph Lameter" <clameter@sgi.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] slab: fix typo in allocation failure handling
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes wrong array index in allocation failure handling.

Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 mm/slab.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: 2.6-git/mm/slab.c
===================================================================
--- 2.6-git.orig/mm/slab.c
+++ 2.6-git/mm/slab.c
@@ -1043,7 +1043,7 @@ static struct array_cache **alloc_alien_
 			}
 			ac_ptr[i] = alloc_arraycache(node, limit, 0xbaadf00d);
 			if (!ac_ptr[i]) {
-				for (i--; i <= 0; i--)
+				for (i--; i >= 0; i--)
 					kfree(ac_ptr[i]);
 				kfree(ac_ptr);
 				return NULL;
