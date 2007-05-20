Return-Path: <linux-kernel-owner+w=401wt.eu-S1763003AbXETBVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763003AbXETBVV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 21:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756622AbXETBVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 21:21:14 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:41984 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756099AbXETBVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 21:21:14 -0400
Date: Sun, 20 May 2007 03:22:11 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [i386/x86-64] Fix section mismatch
Message-ID: <20070520012211.GB31667@uranus.ravnborg.org>
References: <20070511153248.GA22577@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070511153248.GA22577@suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2007 at 05:32:48PM +0200, Bernhard Walle wrote:
> This patch fixes following compile warning:
> 
> --------- >8 --------
> WARNING: arch/x86_64/kernel/built-in.o - Section mismatch: reference to
> .init.text:mtrr_bp_init from .text between 'id entify_cpu' (at offset 0x6571)
> and 'IRQ0x20_interrupt'
> --------- 8< --------
> 
> It's because identify_cpu() which is __cpuinit calls mtrr_bp_init() which is
> __init(). __cpuinit() expands to nothing if CONFIG_HOTPLUG_CPU=y and so the
> call is illegal.
> 
> 
> Signed-off-by: Bernhard Walle <bwalle@suse.de>
> 
I cannot see what goes wrong here and how your patch fixes this.
Can you please send me a copy of your .config.

[I have submitted a patch to add both __init tags today and
 needs to find out if that one is bogus].

	Sam


> ---
>  arch/i386/kernel/cpu/mtrr/generic.c |    2 +-
>  arch/i386/kernel/cpu/mtrr/main.c    |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> --- a/arch/i386/kernel/cpu/mtrr/generic.c
> +++ b/arch/i386/kernel/cpu/mtrr/generic.c
> @@ -78,7 +78,7 @@ static void __cpuinit print_fixed(unsign
>  }
>  
>  /*  Grab all of the MTRR state for this CPU into *state  */
> -void __init get_mtrr_state(void)
> +void get_mtrr_state(void)
>  {
>  	unsigned int i;
>  	struct mtrr_var_range *vrs;
> --- a/arch/i386/kernel/cpu/mtrr/main.c
> +++ b/arch/i386/kernel/cpu/mtrr/main.c
> @@ -639,7 +639,7 @@ static struct sysdev_driver mtrr_sysdev_
>   * initialized (i.e. before smp_init()).
>   * 
>   */
> -void __init mtrr_bp_init(void)
> +void mtrr_bp_init(void)
>  {
>  	init_ifs();
>  
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
