Return-Path: <linux-kernel-owner+w=401wt.eu-S1752427AbYJUIIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427AbYJUIIN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 04:08:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbYJUIH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 04:07:57 -0400
Received: from smtpd4.aruba.it ([62.149.128.209]:39050 "HELO smtp6.aruba.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751006AbYJUIHz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 04:07:55 -0400
Date: Tue, 21 Oct 2008 10:08:42 +0200
From: Daniele Calore <orkaan@orkaan.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       "Yinghai Lu" <yinghai@kernel.org>
Cc: Daniele Calore <orkaan@orkaan.org>
Subject: Re: [PATCH 2.6.27] x86: memtest fix use of reserve_early()
Message-ID: <20081021100842.09355392@buddha>
In-Reply-To: <20081013103412.6fec375a@buddha>
References: <20081013103412.6fec375a@buddha>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Rating: smtp6.aruba.it 1.6.2 0/1000/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo and all,

Is there any news about this patch ?
AFAIK without this fix memtest is unusefull.
But if I'm wrong, apologise for the noise.

Bye,

Daniele
--

On Mon, 13 Oct 2008 10:34:12 +0200
Daniele Calore <orkaan@orkaan.org> wrote:

> Hi all,
>     
> Wrong usage of 2nd parameter in reserve_early call.
> 66/75: reserve_early(start_bad, last_bad - start_bad, "BAD RAM");
>                                 ^^^^^^^^^^^^^^^^^^^^
>     
> The correct way is to use 'end' address and not 'size'.
> As a bonus a fix to the printk format.
> 
> Signed-off-by: Daniele Calore <orkaan@orkaan.org>
>     
> ---
> diff --git a/arch/x86/mm/memtest.c b/arch/x86/mm/memtest.c
> index 672e17f..9cab18b 100644
> --- a/arch/x86/mm/memtest.c
> +++ b/arch/x86/mm/memtest.c
> @@ -61,9 +61,9 @@ static void __init memtest(unsigned long
> start_phys, unsigned long size, last_bad += incr;
>  			} else {
>  				if (start_bad) {
> -					printk(KERN_CONT "\n  %010lx
> bad mem addr %010lx - %010lx reserved",
> +					printk(KERN_CONT "\n  %016lx
> bad mem addr %010lx - %010lx reserved", val, start_bad, last_bad +
> incr);
> -					reserve_early(start_bad,
> last_bad - start_bad, "BAD RAM");
> +					reserve_early(start_bad,
> last_bad + incr, "BAD RAM"); }
>  				start_bad = last_bad =
> start_phys_aligned; }
> @@ -72,9 +72,8 @@ static void __init memtest(unsigned long
> start_phys, unsigned long size, if (start_bad) {
>  		printk(KERN_CONT "\n  %016lx bad mem addr %010lx -
> %010lx reserved", val, start_bad, last_bad + incr);
> -		reserve_early(start_bad, last_bad - start_bad, "BAD
> RAM");
> +		reserve_early(start_bad, last_bad + incr, "BAD RAM");
>  	}
> -
>  }
>  
>  /* default is disabled */
