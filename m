Return-Path: <linux-kernel-owner+w=401wt.eu-S1755234AbZGAWJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbZGAWJR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 18:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754520AbZGAWJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 18:09:03 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59071 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753876AbZGAWJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 18:09:02 -0400
Message-ID: <4A4BDC1C.8050807@redhat.com>
Date: Wed, 01 Jul 2009 17:58:52 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>, stable@kernel.org
Subject: Re: [BUGFIX PATCH] x86: Fix fixmap page order for FIX_TEXT_POKE0,1
References: <20090701210246.22089.65697.stgit@localhost.localdomain> <20090701213722.GH19926@Krystal>
In-Reply-To: <20090701213722.GH19926@Krystal>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> Masami wrote :
> 
>> Since the fixmap pages are assigned higher address to lower, text_poke()
>> has to use it with inverted order (FIX_TEXT_POKE1 to FIX_TEXT_POKE0).
> 
> I prefer to just invert the order of the fixmap declaration. It's simpler and
> more straightforward.

It's ok for me too.

> Backward fixmaps seems to be used by both x86 32 and 64.
> 
> It's a really nasty bug, because it only hurts when instructions to patch are
> crossing a page boundary. If this happens, the fixmap write accesses
> will spill on the following fixmap, which may very well crash the
> system. And this does not crash the system, it could leave illegal
> instructions in place. Thanks Masami for finding this.
> 
> It seems to have crept into the 2.6.30-rc series, so this calls for a
> -stable inclusion.

Right, thanks.

> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

> Cc: Ingo Molnar <mingo@elte.hu>
> CC: stable@kernel.org
> ---
>  arch/x86/include/asm/fixmap.h |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6-lttng/arch/x86/include/asm/fixmap.h
> ===================================================================
> --- linux-2.6-lttng.orig/arch/x86/include/asm/fixmap.h	2009-07-01 16:52:57.000000000 -0400
> +++ linux-2.6-lttng/arch/x86/include/asm/fixmap.h	2009-07-01 16:54:52.000000000 -0400
> @@ -111,8 +111,8 @@ enum fixed_addresses {
>  #ifdef CONFIG_PARAVIRT
>  	FIX_PARAVIRT_BOOTMAP,
>  #endif
> -	FIX_TEXT_POKE0,	/* reserve 2 pages for text_poke() */
> -	FIX_TEXT_POKE1,
> +	FIX_TEXT_POKE1,	/* reserve 2 pages for text_poke() */
> +	FIX_TEXT_POKE0, /* first page is last, because allocation is backward */
>  	__end_of_permanent_fixed_addresses,
>  #ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
>  	FIX_OHCI1394_BASE,
> 

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

