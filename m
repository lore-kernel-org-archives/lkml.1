Return-Path: <linux-kernel-owner+w=401wt.eu-S1750976AbZEVE4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750976AbZEVE4f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 00:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751886AbZEVEzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 00:55:36 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:3469 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbZEVEzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 00:55:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HH/3Ut7y9MEebsO3Iz0oykwFY6/lFO+Dhdvo8dtIJQmQY/My/rJqVwe58ZXYN/VRxg
         jlPD0/IkNpB+ZZ2Pthn7bdswzwCl3xNZvmc0U0YoElKnFIIsJWwKb2DKLFP28CHiPr4R
         UECuLrgynV2LXGKbtbe2JykSwn1EZfSat6uvY=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       torvalds@linux-foundation.org, xemul@parallels.com,
       orenl@cs.columbia.edu, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       mingo@elte.hu, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 04/38] ipcns 2/4: extract create_ipc_ns()
Date: Fri, 22 May 2009 08:54:58 +0400
Message-Id: <1242968132-1044-4-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1242968132-1044-1-git-send-email-adobriyan@gmail.com>
References: <1242968132-1044-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clone_ipc_ns() is misnamed, it doesn't clone anything and doesn't use passed
parameter. Rename it.

create_ipc_ns() will be used by C/R to create fresh ipcns.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
---
 ipc/namespace.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/ipc/namespace.c b/ipc/namespace.c
index a56fc59..231ee53 100644
--- a/ipc/namespace.c
+++ b/ipc/namespace.c
@@ -14,7 +14,7 @@
 
 #include "util.h"
 
-static struct ipc_namespace *clone_ipc_ns(struct ipc_namespace *old_ns)
+static struct ipc_namespace *create_ipc_ns(void)
 {
 	struct ipc_namespace *ns;
 	int err;
@@ -48,14 +48,9 @@ static struct ipc_namespace *clone_ipc_ns(struct ipc_namespace *old_ns)
 
 struct ipc_namespace *copy_ipcs(unsigned long flags, struct ipc_namespace *ns)
 {
-	struct ipc_namespace *new_ns;
-
 	if (!(flags & CLONE_NEWIPC))
 		return get_ipc_ns(ns);
-
-	new_ns = clone_ipc_ns(ns);
-
-	return new_ns;
+	return create_ipc_ns();
 }
 
 /*
-- 
1.5.6.5

