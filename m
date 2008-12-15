Return-Path: <linux-kernel-owner+w=401wt.eu-S1754753AbYLOIfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753AbYLOIfQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 03:35:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbYLOIfB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 03:35:01 -0500
Received: from ozlabs.org ([203.10.76.45]:53420 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbYLOIfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 03:35:00 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Hollis Blanchard <hollisb@us.ibm.com>
Subject: Re: [PATCH] KVM: use modern cpumask primitives, no cpumask_t on stack
Date: Mon, 15 Dec 2008 19:04:35 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Avi Kivity <avi@redhat.com>, "kvm-devel" <kvm@vger.kernel.org>,
       Rusty Russell <rusty@ozlabs.au.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <20081208160945.7535A25006E@cleopatra.tlv.redhat.com> <1229014284.26586.9.camel@localhost.localdomain>
In-Reply-To: <1229014284.26586.9.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812151904.36554.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 December 2008 03:21:24 Hollis Blanchard wrote:
> This patch breaks uniprocessor builds, because smp_call_function_many()
> is only defined for CONFIG_SMP.

Good catch.  I missed it because it's fixed as a side-effect of a
later patch in my series (before I convert users).

Linus, can you please apply this fix?

Thanks,
Rusty.

Subject: Define smp_call_function_many for UP

Otherwise those using it in transition patches (eg. kvm) can't compile
with CONFIG_SMP=n:

arch/x86/kvm/../../../virt/kvm/kvm_main.c: In function 'make_all_cpus_request':
arch/x86/kvm/../../../virt/kvm/kvm_main.c:380: error: implicit declaration of function 'smp_call_function_many'

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

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
