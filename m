Return-Path: <linux-kernel-owner+w=401wt.eu-S1755489AbYCJUzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489AbYCJUzT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 16:55:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751048AbYCJUzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 16:55:05 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:39824 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbYCJUzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 16:55:03 -0400
Date: Mon, 10 Mar 2008 15:54:56 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>,
       Casey Schaufler <casey@schaufler-ca.com>,
       Andrew Morgan <morgan@kernel.org>
Subject: smack: use cap_task_prctl
Message-ID: <20080310205456.GA13013@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the introduction of per-process securebits, the capabilities-related
prctl callbacks were moved into cap_task_prctl().  Have smack use
cap_task_prctl() so that PR_SET_KEEPCAPS is defined.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 security/smack/smack_lsm.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index 40066b6..e8ce6b6 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -2493,6 +2493,7 @@ static struct security_operations smack_ops = {
 	.task_wait = 			smack_task_wait,
 	.task_reparent_to_init =	cap_task_reparent_to_init,
 	.task_to_inode = 		smack_task_to_inode,
+	.task_prctl =			cap_task_prctl,
 
 	.ipc_permission = 		smack_ipc_permission,
 
-- 
1.5.1

