Return-Path: <linux-kernel-owner+w=401wt.eu-S1765000AbXKUACW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765000AbXKUACW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 19:02:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757730AbXKUACN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 19:02:13 -0500
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:47860 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752396AbXKUACN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 19:02:13 -0500
Subject: Re: [PATCH 13/18] x86 vDSO: ia32 sysenter_return
From: Zachary Amsden <zach@vmware.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20071119220622.C5ED026F8BE@magilla.localdomain>
References: <20071119215944.01B7C26F8BE@magilla.localdomain>
	 <20071119220622.C5ED026F8BE@magilla.localdomain>
Content-Type: text/plain
Date: Tue, 20 Nov 2007 16:05:34 -0800
Message-Id: <1195603534.6352.231.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-11-19 at 14:06 -0800, Roland McGrath wrote:
> This changes the 64-bit kernel's support for the 32-bit sysenter
> instruction to use stored fields rather than constants for the
> user-mode return address, as the 32-bit kernel does.  This adds a
> sysenter_return field to struct thread_info, as 32-bit has.  There
> is no observable effect from this yet.  It makes the assembly code
> independent of the 32-bit vDSO mapping address, paving the way for
> making the vDSO address vary as it does on the 32-bit kernel.

I hope you won't carry the dependency of COMPAT_VDSO over to 64-bit when
that happens.

> @@ -104,7 +103,7 @@ ENTRY(ia32_sysenter_target)
>  	pushfq
>  	CFI_ADJUST_CFA_OFFSET 8
>  	/*CFI_REL_OFFSET rflags,0*/
> -	movl	$VSYSCALL32_SYSEXIT, %r10d
> +	movl	8*3-THREAD_SIZE+threadinfo_sysenter_return(%rsp), %r10d

8*3-THREAD_SIZE is not very intuitive.  Can you add a comment on the
math?

Zach

