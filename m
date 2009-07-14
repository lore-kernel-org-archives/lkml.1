Return-Path: <linux-kernel-owner+w=401wt.eu-S1754487AbZGNKNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487AbZGNKNu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 06:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754395AbZGNKNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 06:13:49 -0400
Received: from mail.gmx.net ([213.165.64.20]:57583 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754364AbZGNKNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 06:13:48 -0400
X-Authenticated: #23875046
X-Provags-ID: V01U2FsdGVkX1+cLmwHgSGcKqV9cdfHDVFRNRItxCAIjOUe+Gc5gD
	RR1ngjQbYQ+hiu
Message-ID: <4A5C5A59.5080304@fisher-privat.net>
Date: Tue, 14 Jul 2009 12:13:45 +0200
From: Alexey Fisher <bug-track@fisher-privat.net>
User-Agent: Thunderbird 2.0.0.22 (X11/20090710)
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       x86@kernel.org
Subject: Re: [PATCH] x86: _edata should include all .data.* sections on X86_64
References: <4A5C20E5.6010203@fisher-privat.net>	 <84144f020907140019g511723dctb541f6333d1a082b@mail.gmail.com>	 <4A5C41C8.7040904@fisher-privat.net>	 <1247564356.28240.30.camel@pc1117.cambridge.arm.com> <1247565175.28240.37.camel@pc1117.cambridge.arm.com>
In-Reply-To: <1247565175.28240.37.camel@pc1117.cambridge.arm.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this patch i have only 25 reports....
but i still have a lot of ext4 and some other reports.


Catalin Marinas schrieb:
> The .data.read_mostly and .data.cacheline_aligned sections aren't
> covered by the _sdata .. _edata range on X86_64. This affects the
> kmemleak reporting leading to possible false positives by not scanning
> all the whole data section.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
> 
> (I re-posted this patch with comments and cc'ing the relevant people)
> 
>  arch/x86/kernel/vmlinux.lds.S |    7 -------
>  1 files changed, 0 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
> index 367e878..59f31d2 100644
> --- a/arch/x86/kernel/vmlinux.lds.S
> +++ b/arch/x86/kernel/vmlinux.lds.S
> @@ -112,11 +112,6 @@ SECTIONS
>  		_sdata = .;
>  		DATA_DATA
>  		CONSTRUCTORS
> -
> -#ifdef CONFIG_X86_64
> -		/* End of data section */
> -		_edata = .;
> -#endif
>  	} :data
>  
>  #ifdef CONFIG_X86_32
> @@ -156,10 +151,8 @@ SECTIONS
>  	.data.read_mostly : AT(ADDR(.data.read_mostly) - LOAD_OFFSET) {
>  		*(.data.read_mostly)
>  
> -#ifdef CONFIG_X86_32
>  		/* End of data section */
>  		_edata = .;
> -#endif
>  	}
>  
>  #ifdef CONFIG_X86_64
> 

