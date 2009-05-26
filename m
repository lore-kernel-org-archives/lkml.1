Return-Path: <linux-kernel-owner+w=401wt.eu-S1754205AbZEZIfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205AbZEZIfv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 04:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753490AbZEZIfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 04:35:44 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37707 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445AbZEZIfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 04:35:43 -0400
Date: Tue, 26 May 2009 10:35:38 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: akpm@linux-foundation.org, Randy Dunlap <randy.dunlap@oracle.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>, linux-mm@kvack.org,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       "David S. Miller" <davem@davemloft.net>,
       Dominik Brodowski <linux@dominikbrodowski.net>,
       Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][mmtom] clean up once printk routine
Message-ID: <20090526083538.GA29563@elf.ucw.cz>
References: <20090526135733.3c38f758.minchan.kim@barrios-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090526135733.3c38f758.minchan.kim@barrios-desktop>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Yes. There are also some places to be able to use printk_once().
> Are there any place I missed ?
> 
> == CUT HERE ==
> 
> There are some places to be able to use printk_once instead of hard coding.
> 
> It will help code readability and maintenance.
> This patch doesn't change function's behavior.
> 
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> CC: Dominik Brodowski <linux@dominikbrodowski.net>
> CC: David S. Miller <davem@davemloft.net>
> CC: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/cpu/common.c  |    8 ++------
>  drivers/net/3c515.c           |    7 ++-----
>  drivers/pcmcia/pcmcia_ioctl.c |    9 +++------
>  3 files changed, 7 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index 82bec86..dc0f694 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -496,13 +496,9 @@ static void __cpuinit get_cpu_vendor(struct cpuinfo_x86 *c)
>  		}
>  	}
>  
> -	if (!printed) {
> -		printed++;
> -		printk(KERN_ERR
> +	printk_once(KERN_ERR
>  		    "CPU: vendor_id '%s' unknown, using generic init.\n", v);
> -
> -		printk(KERN_ERR "CPU: Your system may be unstable.\n");
> -	}
> +	printk_once(KERN_ERR "CPU: Your system may be unstable.\n");
>

You should delete the variable, right?

Plus, the code now uses two variables instead of one.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
