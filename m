Return-Path: <linux-kernel-owner+w=401wt.eu-S1757227AbZECXZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227AbZECXZs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 19:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756800AbZECXZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 19:25:30 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:55356 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757101AbZECXZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 19:25:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=wrRnJOG06vgc/vMOw8SahRkoWvwyIThOBNyIRx8fi3Rdxtm+ZZlSAeU5kwRf2DYGP1
         boZQ+k/dffUSECskgpXoNkbUr1jJguhCzF153kTWbiYG7tnK59oObe/6QFO8EMBVi5hn
         Kro9bW1eryvZC7sZmcrPuzL1yKVRg1kGrMAaM=
Date: Mon, 4 May 2009 03:26:16 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: [PATCH 2/2] ipcns 2/2: extract create_ipc_ns()
Message-ID: <20090503232616.GC16631@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
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
