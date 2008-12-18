Return-Path: <linux-kernel-owner+w=401wt.eu-S1753553AbYLRWK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553AbYLRWK3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 17:10:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752243AbYLRWKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 17:10:18 -0500
Received: from ozlabs.org ([203.10.76.45]:52816 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547AbYLRWKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 17:10:17 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] Define smp_call_function_many for UP
Date: Fri, 19 Dec 2008 08:40:13 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Hollis Blanchard <hollisb@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       "kvm-devel" <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org
References: <20081208160945.7535A25006E@cleopatra.tlv.redhat.com> <1229014284.26586.9.camel@localhost.localdomain> <200812151904.36554.rusty@rustcorp.com.au>
In-Reply-To: <200812151904.36554.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812190840.13995.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please apply.  Otherwise those using it in transition patches (eg. kvm)
can't compile with CONFIG_SMP=n:

arch/x86/kvm/../../../virt/kvm/kvm_main.c: In function 'make_all_cpus_request':
arch/x86/kvm/../../../virt/kvm/kvm_main.c:380: error: implicit declaration of function 'smp_call_function_many'

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/smp.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/smp.h b/include/linux/smp.h
--- a/include/linux/smp.h
+++ b/include/linux/smp.h
@@ -146,6 +147,8 @@ static inline void smp_send_reschedule(i
 })
 #define smp_call_function_mask(mask, func, info, wait) \
 			(up_smp_call_function(func, info))
+#define smp_call_function_many(mask, func, info, wait) \
+			(up_smp_call_function(func, info))
 static inline void init_call_single_data(void)
 {
 }
