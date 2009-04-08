Return-Path: <linux-kernel-owner+w=401wt.eu-S1765022AbZDHNBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765022AbZDHNBn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 09:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762759AbZDHNBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 09:01:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:41569 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764875AbZDHNBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 09:01:19 -0400
Date: Wed, 8 Apr 2009 13:00:45 GMT
From: Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49D6A6B9.6060501@kernel.org>
References: <49D6A6B9.6060501@kernel.org>
Subject: [tip:x86/apic] x86: consistent about warm_reset_vector for UN_NON_UNIQUE_APIC
Message-ID: <tip-02421f98ec55c3ff118f358740ff640f096c7ad6@git.kernel.org>
Git-Commit-ID: 02421f98ec55c3ff118f358740ff640f096c7ad6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 08 Apr 2009 13:00:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  02421f98ec55c3ff118f358740ff640f096c7ad6
Gitweb:     http://git.kernel.org/tip/02421f98ec55c3ff118f358740ff640f096c7ad6
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Fri, 3 Apr 2009 17:15:53 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 8 Apr 2009 14:50:28 +0200

x86: consistent about warm_reset_vector for UN_NON_UNIQUE_APIC

Impact: cleanup

didn't set it for UV_NON_UNIQUE_APIC, so don't restore it

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <49D6A6B9.6060501@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/smpboot.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index bddf2cc..bf8ad63 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -822,10 +822,12 @@ do_rest:
 	/* mark "stuck" area as not stuck */
 	*((volatile unsigned long *)trampoline_base) = 0;
 
-	/*
-	 * Cleanup possible dangling ends...
-	 */
-	smpboot_restore_warm_reset_vector();
+	if (get_uv_system_type() != UV_NON_UNIQUE_APIC) {
+		/*
+		 * Cleanup possible dangling ends...
+		 */
+		smpboot_restore_warm_reset_vector();
+	}
 
 	return boot_error;
 }
