Return-Path: <linux-kernel-owner+w=401wt.eu-S1755970AbYCJU5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970AbYCJU5d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 16:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbYCJU5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 16:57:24 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:52733 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382AbYCJU5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 16:57:23 -0400
Date: Mon, 10 Mar 2008 15:57:20 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Andrew Morgan <morgan@kernel.org>
Subject: root_plug: use cap_task_prctl
Message-ID: <20080310205720.GB13013@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the introduction of per-process securebits, the capabilities-related
prctl callbacks were moved into cap_task_prctl().  Have root_plug use
cap_task_prctl() so that PR_SET_KEEPCAPS is defined.

(Andrew, I didn't put patch numbers here, but there are only two of
these.  These are the LSMs which internalize capabilities.  The dummy
module will continue to not support PR_SET_KEEPCAPS).

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 security/root_plug.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/security/root_plug.c b/security/root_plug.c
index 870f130..20d1c9c 100644
--- a/security/root_plug.c
+++ b/security/root_plug.c
@@ -86,6 +86,7 @@ static struct security_operations rootplug_security_ops = {
 
 	.task_post_setuid =		cap_task_post_setuid,
 	.task_reparent_to_init =	cap_task_reparent_to_init,
+	.task_prctl =			cap_task_prctl,
 
 	.bprm_check_security =		rootplug_bprm_check_security,
 };
-- 
1.5.1

