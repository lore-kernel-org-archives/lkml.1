Return-Path: <linux-kernel-owner+w=401wt.eu-S932472AbZHUQEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932472AbZHUQEp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 12:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932297AbZHUQEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 12:04:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51854 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932274AbZHUQEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 12:04:44 -0400
Date: Fri, 21 Aug 2009 18:04:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: smp_scan_config - use signed long as scan
	area size
Message-ID: <20090821160426.GA17731@elte.hu>
References: <20090820173427.GA8517@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090820173427.GA8517@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> Unsigned value potentially could be overlapped
> if length parameter is that: length % 16 != 0.
> 
> This is not a problem at moment since all values
> we pass now are 16 divisible (0x400 and 0x10000).
> 
> Though there is no need unsigned value anyway.
> Max range pointed out by MP specification is
> in kilobytes so plain "signed long" is enough.
> 
> This allow us to be on a safe side.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> ---
> 
> (I doubt if we ever will need to scan 1G of physical
>  memory with 16 byte step at booting procedure 'xcept
>  memtest case)
> 
> Please review. Not sure if the patch is that worth
> but anyway :)
> 
>  arch/x86/kernel/mpparse.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6.git/arch/x86/kernel/mpparse.c
> =====================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/mpparse.c
> +++ linux-2.6.git/arch/x86/kernel/mpparse.c
> @@ -705,7 +705,7 @@ static void __init smp_reserve_bootmem(s
>  #endif
>  }
>  
> -static int __init smp_scan_config(unsigned long base, unsigned long length,
> +static int __init smp_scan_config(unsigned long base, long length,
>  				  unsigned reserve)
>  {
>  	unsigned int *bp = phys_to_virt(base);

Hm, does a BUILD_BUG_ON((length & 15) != 0) line catch incorrectly 
aligned length parameters?

	Ingo
