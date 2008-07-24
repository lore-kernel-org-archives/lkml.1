Return-Path: <linux-kernel-owner+w=401wt.eu-S1756581AbYGXA0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581AbYGXA0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 20:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753729AbYGXA0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 20:26:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57178 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754281AbYGXA0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 20:26:41 -0400
Date: Wed, 23 Jul 2008 17:22:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexander Viro <aviro@redhat.com>, Eric Paris <eparis@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] x86_64 ia32 syscall audit fast-path
In-Reply-To: <20080721235419.CA3BA1541A5@magilla.localdomain>
Message-ID: <alpine.LFD.1.10.0807231718020.21274@nehalem.linux-foundation.org>
References: <20080707065615.77BD9154246@magilla.localdomain> <20080707065742.7C119154246@magilla.localdomain> <alpine.LFD.1.10.0807070927090.11076@woody.linux-foundation.org> <alpine.LFD.1.10.0807070937520.11076@woody.linux-foundation.org>
 <20080708000233.E8EF3154244@magilla.localdomain> <20080718113615.GD6875@elte.hu> <20080721235419.CA3BA1541A5@magilla.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 21 Jul 2008, Roland McGrath wrote:
> 
> Here is a GIT branch with freshly-rebased patches from today's upstream.
> There was some merging fixup to be done after the x86/step changes went in.

Ok, so I decided to try this, because my new toy (Nehalem) showed some 
absolutely horrid performance with the Fedora kernel that went away when I 
compiled my own sane kernel.

And I suspect it's due to the audit path and auditd being enabled (for no 
good reason that I can tell, except to slow everything down, since nobody 
sane cares) by default.

HOWEVER. When I pull from your tree, I can no longer compile with the only 
sane default (namely "CONFIG_AUDIT is stupid, nobody should use it"), 
because I get

	arch/x86/kernel/built-in.o: In function `auditsys':
	signal_64.c:(.text+0x1f40): undefined reference to `audit_syscall_entry'
	arch/x86/kernel/built-in.o: In function `sysret_audit':
	signal_64.c:(.text+0x1f85): undefined reference to `audit_syscall_exit'
	arch/x86/ia32/built-in.o: In function `sysenter_auditsys':
	(.text+0xdd): undefined reference to `audit_syscall_entry'
	arch/x86/ia32/built-in.o: In function `sysexit_audit':
	(.text+0x128): undefined reference to `audit_syscall_exit'
	arch/x86/ia32/built-in.o: In function `cstar_auditsys':
	(.text+0x303): undefined reference to `audit_syscall_entry'
	arch/x86/ia32/built-in.o: In function `sysretl_audit':
	(.text+0x350): undefined reference to `audit_syscall_exit'
	make: *** [.tmp_vmlinux1] Error 1

so while I would like to merge this, I really can't.

I'll test the performance anyway (with CONFIG_AUDIT enabled, of course).

		Linus
