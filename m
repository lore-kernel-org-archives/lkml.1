Return-Path: <linux-kernel-owner+w=401wt.eu-S1759523AbYH0N6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759523AbYH0N6j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 09:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757593AbYH0Nuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:50:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49426 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756448AbYH0Nus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:50:48 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 54/59] CRED: Wrap task credential accesses in the SunRPC
	protocol
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Serge Hallyn <serue@us.ibm.com>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
       linux-nfs@vger.kernel.org
Date: Wed, 27 Aug 2008 14:50:21 +0100
Message-ID: <20080827135021.19980.77243.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
References: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap access to task credentials so that they can be separated more easily from
the task_struct during the introduction of COW creds.

Change most current->(|e|s|fs)[ug]id to current_(|e|s|fs)[ug]id().

Change some task->e?[ug]id to task_e?[ug]id().  In some places it makes more
sense to use RCU directly rather than a convenient wrapper; these will be
addressed by later patches.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: James Morris <jmorris@namei.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: J. Bruce Fields <bfields@fieldses.org>
Cc: Neil Brown <neilb@suse.de>
Cc: linux-nfs@vger.kernel.org
---

 net/sunrpc/auth.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/net/sunrpc/auth.c b/net/sunrpc/auth.c
index 436bf1b..fc2bb08 100644
--- a/net/sunrpc/auth.c
+++ b/net/sunrpc/auth.c
@@ -349,8 +349,8 @@ struct rpc_cred *
 rpcauth_lookupcred(struct rpc_auth *auth, int flags)
 {
 	struct auth_cred acred = {
-		.uid = current->fsuid,
-		.gid = current->fsgid,
+		.uid = current_fsuid(),
+		.gid = current_fsgid(),
 		.group_info = current->group_info,
 	};
 	struct rpc_cred *ret;

