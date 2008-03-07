Return-Path: <linux-kernel-owner+w=401wt.eu-S1765870AbYCGUg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765870AbYCGUg5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 15:36:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761544AbYCGUgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 15:36:49 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:46020 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761423AbYCGUgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 15:36:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Hesg/vHw1GS6pnpU1p1Wq1sD1A9IMp4MBMm8kkqxUbM7jdueEk4WvrCWK8kf5DnlYJBdD/X6A6yZy/Ihk/F6l/q9tnFZxWLENxKlnO9EXpl4LK3wiqt01CTNzbJ9j+sjebNdrVMfCHBOg2BW7LLWfkixXH24EJ05SC1hdd5a8bA=
Message-ID: <878847400803071236w47178fa4r79f50d537b383843@mail.gmail.com>
Date: Fri, 7 Mar 2008 21:36:48 +0100
From: "Pierre Peiffer" <peifferp@gmail.com>
To: akpm@linux-foundation.org, "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: [PATCH 2.6.25-rc3-mm1] IPC: fix a kernel-doc warning
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch fixes this warning produced by kernel-doc (thanks Randy Dunlap):

Warning(linux-2.6.25-rc3-mm1//ipc/util.c:845):
No description found for parameter 'extrat_perm'

It is due to an inconsistency in a variable name between the C-code and
the associated comment.

Signed-off-by: Pierre Peiffer <peifferp@gmail.com>
---
 ipc/util.c |    4 ++--
 ipc/util.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

Index: b/ipc/util.c
===================================================================
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -841,7 +841,7 @@
  *    or an err-code without any lock held otherwise.
  */
 struct kern_ipc_perm *ipcctl_pre_down(struct ipc_ids *ids, int id, int cmd,
-				      struct ipc64_perm *perm, int extrat_perm)
+				      struct ipc64_perm *perm, int extra_perm)
 {
 	struct kern_ipc_perm *ipcp;
 	int err;
@@ -858,7 +858,7 @@
 		goto out_unlock;

 	if (cmd == IPC_SET) {
-		err = audit_ipc_set_perm(extrat_perm, perm->uid,
+		err = audit_ipc_set_perm(extra_perm, perm->uid,
 					 perm->gid, perm->mode);
 		if (err)
 			goto out_unlock;
Index: b/ipc/util.h
===================================================================
--- a/ipc/util.h
+++ b/ipc/util.h
@@ -114,7 +114,7 @@
 void ipc64_perm_to_ipc_perm(struct ipc64_perm *in, struct ipc_perm *out);
 void ipc_update_perm(struct ipc64_perm *in, struct kern_ipc_perm *out);
 struct kern_ipc_perm *ipcctl_pre_down(struct ipc_ids *ids, int id, int cmd,
-				      struct ipc64_perm *perm, int extrat_perm);
+				      struct ipc64_perm *perm, int extra_perm);

 #if defined(__ia64__) || defined(__x86_64__) || defined(__hppa__) ||
defined(__XTENSA__)
   /* On IA-64, we always use the "64-bit version" of the IPC structures.  */

-- 
Pierre
