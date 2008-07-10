Return-Path: <linux-kernel-owner+w=401wt.eu-S1755395AbYGJV42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbYGJV42 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 17:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbYGJV4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 17:56:20 -0400
Received: from mga03.intel.com ([143.182.124.21]:19707 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524AbYGJV4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 17:56:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,340,1212390000"; 
   d="scan'208";a="11800065"
Date: Thu, 10 Jul 2008 14:56:18 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "ebiederm@xmission.com" <ebiederm@xmission.com>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "steiner@sgi.com" <steiner@sgi.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       jeremy@goop.org
Subject: Re: [patch 00/26] x64, x2apic/intr-remap: Interrupt-remapping and x2apic support
Message-ID: <20080710215617.GM1678@linux-os.sc.intel.com>
References: <20080710181634.764954000@linux-os.sc.intel.com> <20080710195320.GA23322@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080710195320.GA23322@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 12:53:20PM -0700, Ingo Molnar wrote:
> 
> Btw., i threw it at the -tip test-cluster and got back a quick build
> bugreport:
> 
> arch/x86/xen/enlighten.c: In function 'xen_patch':
> arch/x86/xen/enlighten.c:1084: warning: label 'patch_site' defined but not used
> arch/x86/xen/enlighten.c: At top level:
> arch/x86/xen/enlighten.c:1272: error: expected identifier before '(' token
> arch/x86/xen/enlighten.c:1273: error: expected '}' before '.' token
> arch/x86/kernel/paravirt.c:376:2: error: invalid preprocessing directive
> #ifndedarch/x86/kernel/paravirt.c:384:2: error: #endif without #if
> 
> with this config:
> 
>   http://redhat.com/~mingo/misc/config-Thu_Jul_10_21_43_28_CEST_2008.bad

Ingo, that was my stupid typo. Please apply this patch. BTW, we
need some more xen64 paravirt fixes in this area. I will look at it
as soon as possible.
---

[patch] compile fix with x2apic patch and CONFIG_PARAVIRT

fix the typo.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index b80105a..4f29ff8 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -360,7 +360,7 @@ struct pv_cpu_ops pv_cpu_ops = {
 
 struct pv_apic_ops pv_apic_ops = {
 #ifdef CONFIG_X86_LOCAL_APIC
-#ifnded CONFIG_X86_64
+#ifndef CONFIG_X86_64
 	.apic_write = native_apic_mem_write,
 	.apic_write_atomic = native_apic_mem_write_atomic,
 	.apic_read = native_apic_mem_read,
