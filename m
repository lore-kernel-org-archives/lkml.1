Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934986Ab0BZB4Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 20:56:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934924Ab0BZB4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 20:56:22 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] SELinux: Make selinux_kernel_create_files_as() shouldn't just
	always return 0
To: jmorris@namei.org
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Fri, 26 Feb 2010 01:56:16 +0000
Message-ID: <20100226015616.24445.64210.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make selinux_kernel_create_files_as() return an error when it gets one, rather
than unconditionally returning 0.

Without this, cachefiles doesn't return an error if the SELinux policy doesn't
let it create files with the label of the directory at the base of the cache.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 security/selinux/hooks.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 9a2ee84..99a7707 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3334,7 +3334,7 @@ static int selinux_kernel_create_files_as(struct cred *new, struct inode *inode)
 
 	if (ret == 0)
 		tsec->create_sid = isec->sid;
-	return 0;
+	return ret;
 }
 
 static int selinux_kernel_module_request(char *kmod_name)

