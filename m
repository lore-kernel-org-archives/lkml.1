Return-Path: <linux-kernel-owner+w=401wt.eu-S1757726AbXLLU5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757726AbXLLU5c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 15:57:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756515AbXLLU5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 15:57:12 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:46380 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754790AbXLLU5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 15:57:11 -0500
Date: Wed, 12 Dec 2007 14:57:05 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Linux Containers <containers@lists.osdl.org>,
       lkml <linux-kernel@vger.kernel.org>
Cc: tungstengraphics.com@sergelap.austin.ibm.com, zwane@infradead.org,
       hugh@veritas.com, airlied@linux.ie
Subject: [RFC] [PATCH -mm] agp: remove uid comparison as security check
Message-ID: <20071212205704.GA24708@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From d4ca1a9749c5b40325ec2db9fcde2f2cbd0e0978 Mon Sep 17 00:00:00 2001
From: serue@us.ibm.com <serue@us.ibm.com>
Date: Wed, 5 Dec 2007 13:55:36 -0800
Subject: [RFC] [PATCH -mm] agp: remove uid comparison as security check

In the face of containers and user namespaces, a uid==0 check for
security is not safe.  Switch to a capability check.

I'm not sure I picked the right capability, but this being AGP
CAP_SYS_RAWIO seemed to make sense.

Signed-off-by: Serge Hallyn <serue@us.ibm.com>
---
 drivers/char/agp/frontend.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/agp/frontend.c b/drivers/char/agp/frontend.c
index 9bd5a95..55d7a82 100644
--- a/drivers/char/agp/frontend.c
+++ b/drivers/char/agp/frontend.c
@@ -689,7 +689,7 @@ static int agp_open(struct inode *inode, struct file *file)
 	set_bit(AGP_FF_ALLOW_CLIENT, &priv->access_flags);
 	priv->my_pid = current->pid;
 
-	if ((current->uid == 0) || (current->suid == 0)) {
+	if (capable(CAP_SYS_RAWIO)) {
 		/* Root priv, can be controller */
 		set_bit(AGP_FF_ALLOW_CONTROLLER, &priv->access_flags);
 	}
-- 
1.5.1

