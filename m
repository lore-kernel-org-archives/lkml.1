Return-Path: <linux-kernel-owner+w=401wt.eu-S1755314AbZKIXIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbZKIXIA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 18:08:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754239AbZKIXH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 18:07:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49410 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990AbZKIXH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 18:07:59 -0500
Message-ID: <4AF8A0A0.2080800@zytor.com>
Date: Mon, 09 Nov 2009 15:07:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>, x86team <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86,apic: Use PAGE_SIZE instead of numbers
References: <20091108155356.GB25940@lenovo>
In-Reply-To: <20091108155356.GB25940@lenovo>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2009 07:53 AM, Cyrill Gorcunov wrote:
> The whole page is reserved for IO-APIC fixmap
> due to non-cacheable requirement. So lets note
> this explicitly instead of playing with numbers.
> 
> CC: Yinghai Lu <yinghai@kernel.org>
> CC: "Maciej W. Rozycki" <macro@linux-mips.org>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> ---
> 
> Perhaps I miss something and (4 * 1024) have some special
> meaning?
> 
>  arch/x86/kernel/apic/io_apic.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6.git/arch/x86/kernel/apic/io_apic.c
> =====================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/apic/io_apic.c
> +++ linux-2.6.git/arch/x86/kernel/apic/io_apic.c
> @@ -4144,7 +4144,7 @@ fake_ioapic_page:
>  		idx++;
>  
>  		ioapic_res->start = ioapic_phys;
> -		ioapic_res->end = ioapic_phys + (4 * 1024) - 1;
> +		ioapic_res->end = ioapic_phys + PAGE_SIZE - 1;
>  		ioapic_res++;
>  	}
>  }

In theory we could have more than one ioapic packed into a single page,
and it is also entirely plausible we'll support other page sizes in x86
at some point.  However, it's probably easier to flag something as
PAGE_SIZE and have to fix it up later than have magic constants, so I
think it's probably the right thing to do.

	-hpa
