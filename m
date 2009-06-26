Return-Path: <linux-kernel-owner+w=401wt.eu-S1752546AbZFZHuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbZFZHuk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 03:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbZFZHuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 03:50:32 -0400
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:17399
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751479AbZFZHub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 03:50:31 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvYBAMMaREp8qN0Z/2dsb2JhbAAIz1OEDQWBNQ
X-IronPort-AV: E=Sophos;i="4.42,295,1243785600"; 
   d="scan'208";a="469202895"
Subject: Re: [PATCH] favr32: improve touchscreen response
From: Ben Nizette <ben@niasdigital.com>
To: "haavard.skinnemoen" <haavard.skinnemoen@atmel.com>
Cc: kernel <kernel@avr32linux.org>,
       "Egtvedt, Hans-Christian" <Hans-Christian.Egtvedt@atmel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1240195013.24329.38.camel@linux-51e8.site>
References: <1240195013.24329.38.camel@linux-51e8.site>
Content-Type: text/plain
Date: Fri, 26 Jun 2009 17:49:37 +1000
Message-Id: <1246002577.9414.62.camel@linux-51e8.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Haavard,

This has hce's ack, any chance of getting it in .31?

Thx,
	--Ben.

On Mon, 2009-04-20 at 12:36 +1000, Ben Nizette wrote:
> The ezLCD+101 board (to which an favr-32 is fitted) has a long,
> unshielded, nasty lead between the touch panel and the ads7843 touch
> controller.  In order to get satisfactory response then, we need to
> employ every noise-reduction trick in the driver's arsenal.  After
> extensive fiddling I've found some good settings:
> 
> 1) We keep vref on all the time to dramatically reduce settling times
> (at the cost of a tiny increase in power consumption).
> 
> 2) Despite 1 the settling time is still non-zero.  500uS is plenty of
> time for the signals to settle
> 
> 3) Despite 1 and 2 there's still a little bit of noise around.  By
> setting a pen recheck delay we make the panel feel less touchy and
> twitchy.
> 
> Someone with more time and patience myself might be able to tune this
> numbers further but these settings are now perfectly acceptable for
> normal use.
> 
> Tested on ezLCD+101 though should only improve response on other ezLCD+/
> favr-32 boards too.
> 
> Signed-off-by: Ben Nizette <bn@niasdigital.com>
> 
> ---
>  arch/avr32/boards/favr-32/setup.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/avr32/boards/favr-32/setup.c b/arch/avr32/boards/favr-32/setup.c
> index 58203d1..f1152fa 100644
> --- a/arch/avr32/boards/favr-32/setup.c
> +++ b/arch/avr32/boards/favr-32/setup.c
> @@ -72,6 +72,10 @@ static struct ads7846_platform_data ads7843_data = {
>  	.debounce_max		= 20,
>  	.debounce_rep		= 4,
>  	.debounce_tol		= 5,
> +	
> +	.keep_vref_on		= true,
> +	.settle_delay_usecs	= 500,
> +	.penirq_recheck_delay_usecs = 100,
>  };
 

