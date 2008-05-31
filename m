Return-Path: <linux-kernel-owner+w=401wt.eu-S1754022AbYEaC0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbYEaC0J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 22:26:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750801AbYEaCZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 22:25:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41824 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750762AbYEaCZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 22:25:56 -0400
Date: Fri, 30 May 2008 19:25:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ulrich Drepper <drepper@redhat.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mtk.manpages@gmail.com
Subject: Re: [PATCH 3/3] 64-bit futexes: x86 support
In-Reply-To: <200805310127.m4V1RLdP013819@devserv.devel.redhat.com>
Message-ID: <alpine.LFD.1.10.0805301923020.3141@woody.linux-foundation.org>
References: <200805310127.m4V1RLdP013819@devserv.devel.redhat.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 30 May 2008, Ulrich Drepper wrote:
>
> +#ifdef CONFIG_X86_32
> +	/* Not all 32-bit machines support 8-byte cmpxchg.  We just
> +	   unconditionally perform a runtime check for the feature.  */
> +	if ((op & FUTEX_FLAG_64) && !boot_cpu_has(X86_FEATURE_CX8))
> +		return -ENOSYS;
> +#endif

Also, doesn't this mean that effectively you have given up on any CPU 
before the Pentium entirely? 

Not that I want to take the patches _anyway_, but it seems doubly stupid. 
Those things are going to be UP machines, so you could have just emulated 
it with no correctness issues by disabling preemption.

		Linus
