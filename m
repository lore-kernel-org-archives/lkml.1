Return-Path: <linux-kernel-owner+w=401wt.eu-S932423AbYGRAlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423AbYGRAlr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 20:41:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755286AbYGRAlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 20:41:39 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:61038 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbYGRAli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 20:41:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=smbA1aoOr6ffkQVm5QUgsVjKgmzLaysSdB96E+UBp9REJO5jkwibMKpF8ZNN6Fo3Fx
         YtLc+c68Ms0rsepwws2+InzKSTwpY02nSdrybCQ9yJ5qznHTLhtVUmZUH/NcLth8yopx
         uisU5m7BwN2oTaSTGRA2cVGjqK6I6ixyGkLMI=
Subject: [PATCH] lockd: trivial sparse endian annotations
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 17:41:35 -0700
Message-Id: <1216341695.6029.133.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/lockd/svcproc.c:115:11: warning: incorrect type in initializer (different base types)
fs/lockd/svcproc.c:115:11:    expected int [signed] rc
fs/lockd/svcproc.c:115:11:    got restricted __be32 [usertype] <noident>
... and so on...

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 fs/lockd/svc4proc.c |    4 ++--
 fs/lockd/svcproc.c  |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/lockd/svc4proc.c b/fs/lockd/svc4proc.c
index 3994446..4a714f6 100644
--- a/fs/lockd/svc4proc.c
+++ b/fs/lockd/svc4proc.c
@@ -83,7 +83,7 @@ nlm4svc_proc_test(struct svc_rqst *rqstp, struct nlm_args *argp,
 {
 	struct nlm_host	*host;
 	struct nlm_file	*file;
-	int rc = rpc_success;
+	__be32 rc = rpc_success;
 
 	dprintk("lockd: TEST4        called\n");
 	resp->cookie = argp->cookie;
@@ -116,7 +116,7 @@ nlm4svc_proc_lock(struct svc_rqst *rqstp, struct nlm_args *argp,
 {
 	struct nlm_host	*host;
 	struct nlm_file	*file;
-	int rc = rpc_success;
+	__be32 rc = rpc_success;
 
 	dprintk("lockd: LOCK          called\n");
 
diff --git a/fs/lockd/svcproc.c b/fs/lockd/svcproc.c
index 76019d2..76262c1 100644
--- a/fs/lockd/svcproc.c
+++ b/fs/lockd/svcproc.c
@@ -112,7 +112,7 @@ nlmsvc_proc_test(struct svc_rqst *rqstp, struct nlm_args *argp,
 {
 	struct nlm_host	*host;
 	struct nlm_file	*file;
-	int rc = rpc_success;
+	__be32 rc = rpc_success;
 
 	dprintk("lockd: TEST          called\n");
 	resp->cookie = argp->cookie;
@@ -146,7 +146,7 @@ nlmsvc_proc_lock(struct svc_rqst *rqstp, struct nlm_args *argp,
 {
 	struct nlm_host	*host;
 	struct nlm_file	*file;
-	int rc = rpc_success;
+	__be32 rc = rpc_success;
 
 	dprintk("lockd: LOCK          called\n");
 
-- 
1.5.6.3.569.ga9185



