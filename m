Return-Path: <linux-kernel-owner+w=401wt.eu-S1764275AbXHCWC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764275AbXHCWC1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 18:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761886AbXHCWCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 18:02:20 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43011 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753927AbXHCWCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 18:02:20 -0400
Date: Fri, 3 Aug 2007 15:01:44 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: [PATCH] PM: Fix dependencies of CONFIG_SUSPEND and
 CONFIG_HIBERNATION
In-Reply-To: <200708032359.37677.rjw@sisk.pl>
Message-ID: <alpine.LFD.0.999.0708031459090.8184@woody.linux-foundation.org>
References: <200708032359.37677.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 3 Aug 2007, Rafael J. Wysocki wrote:
>  	depends on PM
> -	depends on !SMP || SUSPEND_SMP_POSSIBLE
> +	depends on SUSPEND_SMP_POSSIBLE || ((BLACKFIN || MIPS || SUPERH || FRV \
> +		    || (PPC32 && PPC_MPC52xx)) && !SMP)

Please, do that as SUSPEND_UP_POSSIBLE, and make it look like

	config SUSPEND_UP_POSSIBLE
		depends on BLACKFIN || MIPS || SUPERH || FRV || ((PPC32 && PPC_MPC52xx)
		depends on !SMP
		default y

and now you can write the above thing as

	depends on SUSPEND_SMP_POSSIBLE || SUSPEND_UP_POSSIBLE

and it's all much nicer.

I would say that doing a similar setup for HIBERNATE would be nice too, 
but the SUSPEND case is more noticeable because the SMP case is so nice 
already.

		Linus
