Return-Path: <linux-kernel-owner+w=401wt.eu-S1763764AbZFLLt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763764AbZFLLt3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 07:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761323AbZFLLtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 07:49:12 -0400
Received: from ozlabs.org ([203.10.76.45]:35472 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760308AbZFLLtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 07:49:11 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] kvm: remove the duplicated cpumask_clear
Date: Fri, 12 Jun 2009 21:19:10 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <4A318034.3010102@kernel.org> <4A31807C.7000909@kernel.org>
In-Reply-To: <4A31807C.7000909@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906122119.10978.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jun 2009 07:39:00 am Yinghai Lu wrote:
> zalloc_cpumask_var already had that clear.

Only because of your previous patch... I've folded them into one patch for
Avi:

Subject: kvm: use zalloc_cpumask_var instead of cpumask_clear

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 virt/kvm/kvm_main.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2301,11 +2301,10 @@ int kvm_init(void *opaque, unsigned int 
 
 	bad_pfn = page_to_pfn(bad_page);
 
-	if (!alloc_cpumask_var(&cpus_hardware_enabled, GFP_KERNEL)) {
+	if (!zalloc_cpumask_var(&cpus_hardware_enabled, GFP_KERNEL)) {
 		r = -ENOMEM;
 		goto out_free_0;
 	}
-	cpumask_clear(cpus_hardware_enabled);
 
 	r = kvm_arch_hardware_setup();
 	if (r < 0)

