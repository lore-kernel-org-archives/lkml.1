Return-Path: <linux-kernel-owner+w=401wt.eu-S1752336AbZAIQPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336AbZAIQPW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 11:15:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752315AbZAIQOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 11:14:52 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58558 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137AbZAIQOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 11:14:50 -0500
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/2] CRED: Missing put_cred() in prepare_kernel_cred()
To: torvalds@osdl.org, jmorris@namei.org, akpm@linux-foundation.org
Cc: dhowells@redhat.com, steved@redhat.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Date: Fri, 09 Jan 2009 16:13:41 +0000
Message-ID: <20090109161341.13371.24540.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Missing put_cred() in the error handling path of prepare_kernel_cred().

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Steve Dickson <steved@redhat.com>
---

 kernel/cred.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/cred.c b/kernel/cred.c
index 480a61a..400e608 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -530,6 +530,7 @@ struct cred *prepare_kernel_cred(struct task_struct *daemon)
 
 error:
 	put_cred(new);
+	put_cred(old);
 	return NULL;
 }
 EXPORT_SYMBOL(prepare_kernel_cred);

