Return-Path: <linux-kernel-owner+w=401wt.eu-S1760270AbYH0OIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760270AbYH0OIU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 10:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758867AbYH0Nz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:55:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59711 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758858AbYH0Nz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:55:56 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 53/59] CRED: Wrap task credential accesses in the ROSE protocol
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Serge Hallyn <serue@us.ibm.com>, Ralf Baechle <ralf@linux-mips.org>,
       linux-hams@vger.kernel.org
Date: Wed, 27 Aug 2008 14:50:16 +0100
Message-ID: <20080827135015.19980.44538.stgit@warthog.procyon.org.uk>
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
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-hams@vger.kernel.org
---

 net/rose/af_rose.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index a7f1ce1..d902e2d 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -690,7 +690,7 @@ static int rose_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 
 	source = &addr->srose_call;
 
-	user = ax25_findbyuid(current->euid);
+	user = ax25_findbyuid(current_euid());
 	if (user) {
 		rose->source_call = user->call;
 		ax25_uid_put(user);
@@ -791,7 +791,7 @@ static int rose_connect(struct socket *sock, struct sockaddr *uaddr, int addr_le
 			goto out_release;
 		}
 
-		user = ax25_findbyuid(current->euid);
+		user = ax25_findbyuid(current_euid());
 		if (!user) {
 			err = -EINVAL;
 			goto out_release;

