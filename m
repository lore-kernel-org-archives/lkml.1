Return-Path: <linux-kernel-owner+w=401wt.eu-S1763598AbYEAQGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763598AbYEAQGS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 12:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756142AbYEAQGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 12:06:07 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:63524 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755728AbYEAQGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 12:06:06 -0400
Date: Thu, 1 May 2008 08:09:27 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: yhlu.kernel@gmail.com
Cc: Yinghai Lu <yhlu.kernel.send@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Gabriel C <nix.or.die@googlemail.com>,
       Mika Fischer <mika.fischer@zoopnet.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: mtrr cleanup for converting continuous to discrete
 - auto detect
Message-Id: <20080501080927.026b6243.randy.dunlap@oracle.com>
In-Reply-To: <200805010100.34751.yhlu.kernel@gmail.com>
References: <200804272337.40130.yhlu.kernel@gmail.com>
	<200804290352.33543.yhlu.kernel@gmail.com>
	<200804292025.58268.yhlu.kernel@gmail.com>
	<200805010100.34751.yhlu.kernel@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2008 01:00:34 -0700 Yinghai Lu wrote:

> 
> loop mtrr chunk_size and gran_size from 1M to 2G to find out optimal value.

What size step (increment) is used for these loops?

> so user don't need to add mtrr_chunk_size and mtrr_gran_size, 
> 
> if optimal value is not found, print out all list to help select less optimal
> value.
> 
> add mtrr_spare_reg_nr= so user could set 2 instead of 1, if the card need more entries.
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> 

> Index: linux-2.6/Documentation/kernel-parameters.txt
> ===================================================================
> --- linux-2.6.orig/Documentation/kernel-parameters.txt
> +++ linux-2.6/Documentation/kernel-parameters.txt
> @@ -613,9 +613,17 @@ and is between 256 and 4096 characters. 
>  			that could hold holes aka. UC entries.
>  
>  	mtrr_gran_size=nn[KMG] [X86]
> -			used for mtrr cleanup. It is granity of mtrr block.
> +			used for mtrr cleanup. It is granularity of mtrr block.
> +			default is 1.

                        Default

>  			Big value could prevent small alignment use up MTRRs.

			Large value could prevent small alignment from
			using up MTRRs.

>  
> +	mtrr_spare_reg_nr=n [X86]
> +			Format: <integer>
> +			range: 0,7 : spare reg number
> +			default : 1
> +			used for mtrr cleanup. It is spare mtrr entries number.

			Used

> +			set to 2 or more if your graphical card need more.

			Set                                     needs more.

> +
>  	disable_mtrr_trim [X86, Intel and AMD only]
>  			By default the kernel will trim any uncacheable
>  			memory out of your available memory pool based on


---
~Randy
