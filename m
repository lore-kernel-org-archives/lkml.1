Return-Path: <linux-kernel-owner+w=401wt.eu-S1752679AbXJUJVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679AbXJUJVm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 05:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbXJUJVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 05:21:33 -0400
Received: from www.tglx.de ([62.245.132.106]:42801 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbXJUJVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 05:21:31 -0400
Date: Sun, 21 Oct 2007 11:21:13 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jeff Garzik <jeff@garzik.org>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 8/17] arch/x86/kernel/vm86_32.c: irq handler cleanup
In-Reply-To: <20071021075230.DC55E19041B@havoc.gtf.org>
Message-ID: <alpine.LFD.0.9999.0710211119020.22770@localhost.localdomain>
References: <lkjvxcz09835mnsdfv0983q4m1234m@havoc.gtf.org> <20071021075230.DC55E19041B@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Oct 2007, Jeff Garzik wrote:

> commit f57c82aa01f4387c8400acb43afa7fc580635e16
> Author: Jeff Garzik <jeff@garzik.org>
> Date:   Fri Oct 19 19:25:42 2007 -0400
> 
>     arch/x86/kernel/vm86_32.c: irq handler cleanup
>     
>     Obtain the data we want (irq number) via dev_id.
>     
>     Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> 
>  arch/x86/kernel/vm86_32.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> f57c82aa01f4387c8400acb43afa7fc580635e16
> diff --git a/arch/x86/kernel/vm86_32.c b/arch/x86/kernel/vm86_32.c
> index 157e4be..336618b 100644
> --- a/arch/x86/kernel/vm86_32.c
> +++ b/arch/x86/kernel/vm86_32.c
> @@ -739,8 +739,9 @@ static int irqbits;
>  	| (1 << SIGUSR1) | (1 << SIGUSR2) | (1 << SIGIO)  | (1 << SIGURG) \
>  	| (1 << SIGUNUSED) )
>  	
> -static irqreturn_t irq_handler(int intno, void *dev_id)
> +static irqreturn_t irq_handler(int dummy, void *dev_id)
>  {
> +	int intno = (int)(unsigned long) dev_id;
>  	int irq_bit;

can we put the two ints into one line please. The typecast is ugly,
but looking into the file itself it does not really increase the
existing ugliness much.

	Acked-by: Thomas Gleixner <tglx@linutronix.de>

