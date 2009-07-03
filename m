Return-Path: <linux-kernel-owner+w=401wt.eu-S1757239AbZGCKBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239AbZGCKBp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 06:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754069AbZGCKBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 06:01:38 -0400
Received: from cantor.suse.de ([195.135.220.2]:36712 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958AbZGCKBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 06:01:37 -0400
Date: Fri, 3 Jul 2009 12:01:39 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Horst Schirmeier <horst@schirmeier.com>
Cc: rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] doc: missing value 2 for randomize-va-space
In-Reply-To: <20090703000523.GX26384@quickstop.soohrt.org>
Message-ID: <alpine.LNX.2.00.0907031200560.4994@wotan.suse.de>
References: <20090702152338.GU26384@quickstop.soohrt.org> <alpine.LNX.2.00.0907030109191.4994@wotan.suse.de> <20090703000523.GX26384@quickstop.soohrt.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ added Ingo to CC ]

On Fri, 3 Jul 2009, Horst Schirmeier wrote:

> On Fri, 03 Jul 2009, Jiri Kosina wrote:
> > >      There a few legacy applications out there (such as some ancient
> > 
> > ... would you please fix this typo/grammo as well? (There a few ...)
> > 
> > >      versions of libc.so.5 from 1996) that assume that brk area starts
> > 
> > Also, the text itself doesn't seem to be super-clear ... namely, it 
> > describes what CONFIG_COMPAT_BRK is about, but doesn't really clarify how 
> > exactly does this correlate with randomize_va_space == 2. Would you mind 
> > also fixing this bit?
> 
> I hope I didn't misread the sources :-)  Opinions?
> 
> ---
> 
> The documentation for /proc/sys/kernel/* does not mention the possible
> value 2 for randomize-va-space yet.  While being there, doing some
> reformatting, fixing grammar problems and clarifying the correlations
> between randomize-va-space, kernel parameter "norandmaps" and the
> CONFIG_COMPAT_BRK option.
>                                                     
> Signed-off-by: Horst Schirmeier <horst@schirmeier.com>

Acked-by: Jiri Kosina <jkosina@suse.cz>

Ingo, will you take this through your tree?

> 
> ---
>  Documentation/sysctl/kernel.txt |   30 +++++++++++++++++-------------
>  1 files changed, 17 insertions(+), 13 deletions(-)
> 
> diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
> index 322a00b..dd8322f 100644
> --- a/Documentation/sysctl/kernel.txt
> +++ b/Documentation/sysctl/kernel.txt
> @@ -303,25 +303,29 @@ This option can be used to select the type of process address
>  space randomization that is used in the system, for architectures
>  that support this feature.
>  
> -0 - Turn the process address space randomization off by default.
> +0 - Turn the process address space randomization off.  This is the
> +    default for architectures that do not support this feature anyways,
> +    and kernels that are booted with the "norandmaps" parameter.
>  
>  1 - Make the addresses of mmap base, stack and VDSO page randomized.
>      This, among other things, implies that shared libraries will be
> -    loaded to random addresses. Also for PIE-linked binaries, the location
> -    of code start is randomized.
> +    loaded to random addresses.  Also for PIE-linked binaries, the
> +    location of code start is randomized.  This is the default if the
> +    CONFIG_COMPAT_BRK option is enabled.
>  
> -    With heap randomization, the situation is a little bit more
> -    complicated.
> -    There a few legacy applications out there (such as some ancient
> +2 - Additionally enable heap randomization.  This is the default if
> +    CONFIG_COMPAT_BRK is disabled.
> +
> +    There are a few legacy applications out there (such as some ancient
>      versions of libc.so.5 from 1996) that assume that brk area starts
> -    just after the end of the code+bss. These applications break when
> -    start of the brk area is randomized. There are however no known
> +    just after the end of the code+bss.  These applications break when
> +    start of the brk area is randomized.  There are however no known
>      non-legacy applications that would be broken this way, so for most
> -    systems it is safe to choose full randomization. However there is
> -    a CONFIG_COMPAT_BRK option for systems with ancient and/or broken
> -    binaries, that makes heap non-randomized, but keeps all other
> -    parts of process address space randomized if randomize_va_space
> -    sysctl is turned on.
> +    systems it is safe to choose full randomization.
> +
> +    Systems with ancient and/or broken binaries should be configured
> +    with CONFIG_COMPAT_BRK enabled, which excludes the heap from process
> +    address space randomization.
>  
>  ==============================================================
>  
> 
> -- 
> PGP-Key 0xD40E0E7A
> 

Thanks,

-- 
Jiri Kosina
SUSE Labs
