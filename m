Return-Path: <linux-kernel-owner+w=401wt.eu-S1754758AbYHIW5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbYHIW5P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 18:57:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752908AbYHIW47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 18:56:59 -0400
Received: from wf-out-1314.google.com ([209.85.200.169]:55948 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847AbYHIW47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 18:56:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=wR1YZGpjHofVLnDhPWrcErZxaZtkEuEEw62/xE/3g31CGXrhzDzV8RhfuEKuCNZpkx
         ccRiCYt52CXrMkJq2hHrJncKtEeOmgHhK2rgTAUPB8QjtpIuLcLf4zshTApn/hCLkKk1
         SohifiDsgzcJWlglUumg+4gm9Dy1aeU3JAan4=
Subject: [PATCH] cred: add static, remove extern on function definitions
From: Harvey Harrison <harvey.harrison@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 09 Aug 2008 15:56:59 -0700
Message-Id: <1218322619.24441.6.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/cred.c:460:13: warning: function 'revert_creds' with external linkage has definition
kernel/cred.c:72:6: warning: symbol 'put_tgcred' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Introduced between next-20080729 and next-20080808

 kernel/cred.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cred.c b/kernel/cred.c
index f89c5e5..d91cb06 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -69,7 +69,7 @@ static void put_tgcred_rcu(struct rcu_head *rcu)
 /*
  * Release a set of thread group credentials.
  */
-void put_tgcred(struct thread_group_cred *tgcred)
+static void put_tgcred(struct thread_group_cred *tgcred)
 {
 	if (atomic_dec_and_test(&tgcred->usage))
 		call_rcu(&tgcred->rcu, put_tgcred_rcu);
@@ -457,7 +457,7 @@ EXPORT_SYMBOL(override_creds);
  * Revert a temporary set of override subjective credentials to an old set,
  * discarding the override set.
  */
-extern void revert_creds(const struct cred *old)
+void revert_creds(const struct cred *old)
 {
 	const struct cred *override = current->cred;
 
-- 
1.6.0.rc1.278.g9c632

