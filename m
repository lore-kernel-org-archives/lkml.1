Return-Path: <linux-kernel-owner+w=401wt.eu-S1762604AbZFKWKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762604AbZFKWKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 18:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762082AbZFKWKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 18:10:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:56936 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932073AbZFKWKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 18:10:03 -0400
Message-ID: <4A31807C.7000909@kernel.org>
Date: Thu, 11 Jun 2009 15:09:00 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Avi Kivity <avi@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] kvm: remove the duplicated cpumask_clear
References: <4A318034.3010102@kernel.org>
In-Reply-To: <4A318034.3010102@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


zalloc_cpumask_var already had that clear.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 virt/kvm/kvm_main.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6/virt/kvm/kvm_main.c
===================================================================
--- linux-2.6.orig/virt/kvm/kvm_main.c
+++ linux-2.6/virt/kvm/kvm_main.c
@@ -2305,7 +2305,6 @@ int kvm_init(void *opaque, unsigned int
 		r = -ENOMEM;
 		goto out_free_0;
 	}
-	cpumask_clear(cpus_hardware_enabled);
 
 	r = kvm_arch_hardware_setup();
 	if (r < 0)
