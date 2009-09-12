Return-Path: <linux-kernel-owner+w=401wt.eu-S1754516AbZILNpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbZILNpQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 09:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754455AbZILNpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 09:45:15 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:41605 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754448AbZILNpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 09:45:13 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AigFAOs/q0pMROOX/2dsb2JhbACBU9kShBgFgVY
Date: Sat, 12 Sep 2009 09:45:15 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       rostedt@goodmis.org, srostedt@redhat.com, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tracing/core] x86/tracing: comment need for atomic nop
Message-ID: <20090912134515.GC22876@Krystal>
References: <tip-fc06b8520b3bf9aaeb2e27debe6719c215bd4916@git.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <tip-fc06b8520b3bf9aaeb2e27debe6719c215bd4916@git.kernel.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 09:44:33 up 25 days, 34 min,  3 users,  load average: 0.09, 0.15,
	0.12
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* tip-bot for Steven Rostedt (srostedt@redhat.com) wrote:
> Commit-ID:  fc06b8520b3bf9aaeb2e27debe6719c215bd4916
> Gitweb:     http://git.kernel.org/tip/fc06b8520b3bf9aaeb2e27debe6719c215bd4916
> Author:     Steven Rostedt <srostedt@redhat.com>
> AuthorDate: Thu, 10 Sep 2009 17:22:44 -0400
> Committer:  Steven Rostedt <rostedt@goodmis.org>
> CommitDate: Thu, 10 Sep 2009 17:22:44 -0400
> 
> x86/tracing: comment need for atomic nop
> 
> The dynamic function tracer relys on the macro P6_NOP5 always being
> an atomic NOP. If for some reason it is changed to be two operations
> (like a nop2 nop3) it can faults within the kernel when the function
> tracer modifies the code.
> 
> This patch adds a comment to note that the P6_NOPs are expected to
> be atomic. This will hopefully prevent anyone from changing that.
> 
> Reported-by: Mathieu Desnoyer <mathieu.desnoyers@polymtl.ca>

With an added "s" to my last name, that will be good.

Thanks !

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> 
> ---
>  arch/x86/include/asm/nops.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/include/asm/nops.h b/arch/x86/include/asm/nops.h
> index ad2668e..6d8723a 100644
> --- a/arch/x86/include/asm/nops.h
> +++ b/arch/x86/include/asm/nops.h
> @@ -65,6 +65,8 @@
>     6: osp nopl 0x00(%eax,%eax,1)
>     7: nopl 0x00000000(%eax)
>     8: nopl 0x00000000(%eax,%eax,1)
> +   Note: All the above are assumed to be a single instruction.
> +	There is kernel code that depends on this.
>  */
>  #define P6_NOP1	GENERIC_NOP1
>  #define P6_NOP2	".byte 0x66,0x90\n"

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
