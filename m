Return-Path: <linux-kernel-owner+w=401wt.eu-S964879AbXBODDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964879AbXBODDh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 22:03:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964882AbXBODDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 22:03:37 -0500
Received: from [198.99.130.12] ([198.99.130.12]:34829 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S964879AbXBODDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 22:03:37 -0500
Date: Wed, 14 Feb 2007 21:54:23 -0500
From: Jeff Dike <jdike@addtoit.com>
To: "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>
Cc: Andrew Morton <akpm@osdl.org>, stable@kernel.org, Andi Kleen <ak@suse.de>,
       Jeff Dike <jdike@addtoit.com>, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: x86_64: fix 2.6.18 regression - PTRACE_OLDSETOPTIONS should be accepted
Message-ID: <20070215025423.GA9300@ccure.user-mode-linux.org>
References: <11715068631914-git-send-email-blaisorblade@yahoo.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11715068631914-git-send-email-blaisorblade@yahoo.it>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 03:34:23AM +0100, Paolo 'Blaisorblade' Giarrusso wrote:
> Index: linux-2.6.git/arch/x86_64/ia32/ptrace32.c
> ===================================================================
> --- linux-2.6.git.orig/arch/x86_64/ia32/ptrace32.c
> +++ linux-2.6.git/arch/x86_64/ia32/ptrace32.c
> @@ -246,6 +246,7 @@ asmlinkage long sys32_ptrace(long reques
>  	case PTRACE_SINGLESTEP:
>  	case PTRACE_DETACH:
>  	case PTRACE_SYSCALL:
> +	case PTRACE_OLDSETOPTIONS:
>  	case PTRACE_SETOPTIONS:
>  	case PTRACE_SET_THREAD_AREA:
>  	case PTRACE_GET_THREAD_AREA:
> 

I sent an equivalent patch in earlier today:

Index: linux-2.6/arch/x86_64/ia32/ptrace32.c
===================================================================
--- linux-2.6.orig/arch/x86_64/ia32/ptrace32.c
+++ linux-2.6/arch/x86_64/ia32/ptrace32.c
@@ -239,6 +239,8 @@ asmlinkage long sys32_ptrace(long reques
 	__u32 val;
 
 	switch (request) { 
+	case PTRACE_OLDSETOPTIONS:
+		request = PTRACE_SETOPTIONS;
 	case PTRACE_TRACEME:
 	case PTRACE_ATTACH:
 	case PTRACE_KILL:

I change the request so that PTRACE_OLDSETOPTIONS doesn't need to
propogate any further.  However, it is present in include/asm-x86_64,
so I guess that counts as being part of the x86_64 ABI.  That being
the case, I guess my patch can be dropped in favor of this one.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
