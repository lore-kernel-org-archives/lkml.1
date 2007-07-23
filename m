Return-Path: <linux-kernel-owner+w=401wt.eu-S1752374AbXGWWAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374AbXGWWAg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 18:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750715AbXGWWA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 18:00:26 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37617 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750704AbXGWWAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 18:00:25 -0400
Date: Mon, 23 Jul 2007 14:59:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: caglar@pardus.org.tr
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH] drivers/char/hpet.c: integer constant is too large for
 "long" type
Message-Id: <20070723145940.a99b0324.akpm@linux-foundation.org>
In-Reply-To: <200707211419.47680.caglar@pardus.org.tr>
References: <200707211419.47680.caglar@pardus.org.tr>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Jul 2007 14:19:44 +0300
"S.__a__lar Onur" <caglar@pardus.org.tr> wrote:

> Following trivial patch silents
> 
> drivers/char/hpet.c:76: warning: integer constant is too large for "long" type
> 
> warning (with gcc-3.4.6)
> 
> Signed-off-by: S.__a__lar Onur <caglar@pardus.org.tr>
>  
>  drivers/char/hpet.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
> index ba0e74a..23fadf5 100644
> --- a/drivers/char/hpet.c
> +++ b/drivers/char/hpet.c
> @@ -73,7 +73,7 @@ static struct clocksource clocksource_hpet = {
>          .name           = "hpet",
>          .rating         = 250,
>          .read           = read_hpet,
> -        .mask           = 0xffffffffffffffff,
> +        .mask           = 0xffffffffffffffffLL,
>          .mult           = 0, /*to be caluclated*/
>          .shift          = 10,
>          .flags          = CLOCK_SOURCE_IS_CONTINUOUS,

hm, well, this does assume that cycle_t is implemented as long long (or
unsigned long long, actually).  Which in turn assumes that u64 is
implemented as [unsigned] long long.

Not all architectures use unsigned long long for u64: some use unsigned
long.  They'll probably be OK with this change but I think I'll convert
that into plain old "-1", which just works everywhere.


