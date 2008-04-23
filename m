Return-Path: <linux-kernel-owner+w=401wt.eu-S1757906AbYDWS7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906AbYDWS7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 14:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753108AbYDWS7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 14:59:47 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:26622 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453AbYDWS7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 14:59:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=eLAItM7UIruHBP4UXhq4uS/Kc5H+Hj7YNUPsvgg/fEdymnwTOfXsexiMd2zmZQLxaq6lvvtj/Lp2xiYzz0F8vlBtlmDk+lASgiTz4i/0DyA1ppF9VFETVHlIbVyaXa2il8EeWWU/lB8S0gGtRE6lxh9Y1k1i07xxzSqRV8eGX6Y=
Date: Wed, 23 Apr 2008 22:58:59 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: x86: cleanup - rename VM_MASK to X86_VM_MASK
Message-ID: <20080423185859.GB7713@cvg>
References: <200804181856.m3IIuKd4007403@hera.kernel.org> <1208917076.9212.721.camel@pmac.infradead.org> <aa79d98a0804222118me7de773kae498479531a9585@mail.gmail.com> <aa79d98a0804222159l5ae49a64n101c4b299a3242ac@mail.gmail.com> <480F7C11.8040302@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480F7C11.8040302@zytor.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[H. Peter Anvin - Wed, Apr 23, 2008 at 11:12:33AM -0700]
> Cyrill Gorcunov wrote:
>> Hi David,
>> actually, this CONFIG_VM86 was there even before the renaming was done.
>> The main questions (imo) - is there any user space application who uses
>> these flags? If they are - then even the idea of this patch was a bit 
>> bogus,
>> and I should *not* remove all these VM86 specific flags but better define 
>> them
>> as aliases on flags from processor-flags.h.
>
> Hard to know.  VM86 is only used by a handful of applications (DOSEMU, 
> X.org, others?) but it's hard to know what exactly they are.
>
> The fact that noone hollered when that CONFIG_VM86 went in is probably a 
> good hint that they don't matter, but it's hard to say for sure.
>
> 	-hpa
>

Peter, Ingo,

any objections on the patch like that?

---
From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH] reintroduce old VM86 flags for userlang backward compatibility

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/include/asm-x86/vm86.h
===================================================================
--- linux-2.6.git.orig/include/asm-x86/vm86.h	2008-04-23 22:38:58.000000000 +0400
+++ linux-2.6.git/include/asm-x86/vm86.h	2008-04-23 22:41:06.000000000 +0400
@@ -14,6 +14,18 @@
 
 #include <asm/processor-flags.h>
 
+/* backward compatibility for userland */
+#ifndef __KERNEL__
+#define TF_MASK		X86_EFLAGS_TF
+#define IF_MASK		X86_EFLAGS_IF
+#define IOPL_MASK	X86_EFLAGS_IOPL
+#define NT_MASK		X86_EFLAGS_NT
+#define AC_MASK		X86_EFLAGS_AC
+#define VIF_MASK	X86_EFLAGS_VIF
+#define VIP_MASK	X86_EFLAGS_VIP
+#define ID_MASK		X86_EFLAGS_ID
+#endif
+
 #ifdef CONFIG_VM86
 #define X86_VM_MASK	X86_EFLAGS_VM
 #else
