Return-Path: <linux-kernel-owner+w=401wt.eu-S1756589AbZCLL7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589AbZCLL7d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 07:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756435AbZCLL6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 07:58:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:59749 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756425AbZCLL6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 07:58:42 -0400
Date: Thu, 12 Mar 2009 11:58:01 GMT
From: Jan Beulich <jbeulich@novell.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jbeulich@novell.com, tglx@linutronix.de, mingo@elte.hu,
       jeremy.fitzhardinge@citrix.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jbeulich@novell.com, tglx@linutronix.de, jeremy.fitzhardinge@citrix.com,
       mingo@elte.hu
In-Reply-To: <49B9061E.76E4.0078.0@novell.com>
References: <49B9061E.76E4.0078.0@novell.com>
Subject: [tip:x86/urgent] x86: fix HYPERVISOR_update_descriptor()
Message-ID: <tip-6a5c05f002c3e4f24887a5fe8e7df757d339d368@git.kernel.org>
Git-Commit-ID: 6a5c05f002c3e4f24887a5fe8e7df757d339d368
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 12 Mar 2009 11:58:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6a5c05f002c3e4f24887a5fe8e7df757d339d368
Gitweb:     http://git.kernel.org/tip/6a5c05f002c3e4f24887a5fe8e7df757d339d368
Author:     "Jan Beulich" <jbeulich@novell.com>
AuthorDate: Thu, 12 Mar 2009 11:54:54 +0000
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 12 Mar 2009 12:56:21 +0100

x86: fix HYPERVISOR_update_descriptor()

Impact: fix potential oops during app-initiated LDT manipulation

The underlying hypercall has differing argument requirements on 32-
and 64-bit.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
LKML-Reference: <49B9061E.76E4.0078.0@novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/xen/hypercall.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/xen/hypercall.h b/arch/x86/include/asm/xen/hypercall.h
index 5e79ca6..9c371e4 100644
--- a/arch/x86/include/asm/xen/hypercall.h
+++ b/arch/x86/include/asm/xen/hypercall.h
@@ -296,6 +296,8 @@ HYPERVISOR_get_debugreg(int reg)
 static inline int
 HYPERVISOR_update_descriptor(u64 ma, u64 desc)
 {
+	if (sizeof(u64) == sizeof(long))
+		return _hypercall2(int, update_descriptor, ma, desc);
 	return _hypercall4(int, update_descriptor, ma, ma>>32, desc, desc>>32);
 }
 
