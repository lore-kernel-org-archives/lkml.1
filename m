Return-Path: <linux-kernel-owner+w=401wt.eu-S935911AbZDIWrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935911AbZDIWrA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 18:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759070AbZDIWqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 18:46:49 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:51736 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757274AbZDIWqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 18:46:49 -0400
X-Greylist: delayed 704 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Apr 2009 18:46:48 EDT
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: linux-kernel@vger.kernel.org
Subject: [PATCH]Silencing warning: passing argument 1 of 'get_new_cred' discards qualifiers from pointer target type
Date: Fri, 10 Apr 2009 01:46:28 +0300
User-Agent: KMail/1.9.10
Cc: David Howells <dhowells@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904100146.28826.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I do not know if that is worth the effort, but...

Silencing warning: passing argument 1 of 'get_new_cred' discards qualifiers from pointer target type

The proposed change is similar to that used in put_cred() function (few lines lower)

The patch is against 2.6.30-rc1, but should apply to 2.6.29(.1) too.

Signed-off-by: Marin Mitov mitov@issp.bas.bg
=============================================================
--- a/include/linux/cred.h	2009-04-05 19:59:19.000000000 +0300
+++ b/include/linux/cred.h	2009-04-05 22:49:22.000000000 +0300
@@ -185,7 +185,9 @@
  */
 static inline const struct cred *get_cred(const struct cred *cred)
 {
-	return get_new_cred((struct cred *) cred);
+	struct cred *_cred = (struct cred *) cred;
+
+	return get_new_cred(_cred);
 }
 
 /**
