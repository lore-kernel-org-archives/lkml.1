Return-Path: <linux-kernel-owner+w=401wt.eu-S1765212AbYBBHs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765212AbYBBHs7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 02:48:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761183AbYBBHse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 02:48:34 -0500
Received: from qb-out-0506.google.com ([72.14.204.233]:59537 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbYBBHsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 02:48:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XRjnlNDzjAeMWi0cMalJKCKYrECMbIuqgYuPCUUh07CnlzsvR+IfKS9Gzqf6D46lK6ZxYNi7cJl9cFPdrkBaIqa3F1LcU6+Af8w7PSjg31VNQaqn2Q51pl77dF/aVronpaMaf+BSmXMB4489V30toGuaFeaj+dHDnCJb5uXKXIo=
Subject: [PATCH 3/3] x86: small sparse fix in process_32.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 01 Feb 2008 23:48:06 -0800
Message-Id: <1201938486.1844.7.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/x86/kernel/process_32.c:254:43: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/process_32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 968371a..dabdbef 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -251,7 +251,7 @@ void cpu_idle_wait(void)
 		 * because it has nothing to do.
 		 * Give all the remaining CPUS a kick.
 		 */
-		smp_call_function_mask(map, do_nothing, 0, 0);
+		smp_call_function_mask(map, do_nothing, NULL, 0);
 	} while (!cpus_empty(map));
 
 	set_cpus_allowed(current, tmp);
-- 
1.5.4.rc4.1142.gf5a97

