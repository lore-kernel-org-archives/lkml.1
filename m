Return-Path: <linux-kernel-owner+w=401wt.eu-S1759783AbYCCUpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759783AbYCCUpp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 15:45:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754433AbYCCUpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 15:45:35 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:45194 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819AbYCCUpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 15:45:34 -0500
Date: Mon, 3 Mar 2008 21:46:03 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Adam Belay <abelay@novell.com>, linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Lee Revell <rlrevell@joe-job.com>
Subject: Re: [PATCH] cpuidle: avoid singing capacitors
Message-ID: <20080303204603.GA19775@elf.ucw.cz>
References: <20080229193812.31f45b0c@mjolnir.drzeus.cx> <20080303211842.6f492782@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080303211842.6f492782@mjolnir.drzeus.cx>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I've been playing around with this for a bit, and the jiffies approach
> just had too many gotchas. So I tried using the information that was
> already present in the menu governor. This is what I came up with.
> 
> It solves the primary problem of getting rid of the noise. I've also
> tried some crude power measurements and I couldn't get any difference
> with and without the patch. Powertop also nicely shows that the CPU is
> still spending almost all of its time in C3. Therefore, I'm letting the
> effects of it be enabled by default.
> 
> So I'm taking the [RFC] off it. Please still test and see that it
> solves the issue on other machines, and the it does not cause any big
> power surges.
> 
> diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
> index 78d77c5..d9c43e3 100644
> --- a/drivers/cpuidle/governors/menu.c
> +++ b/drivers/cpuidle/governors/menu.c
> @@ -16,6 +16,8 @@
>  
>  #define BREAK_FUZZ     4       /* 4 us */
>  
> +static unsigned int min_deep_sleep = 2000;
> +

Well, why not, but I believe we should default to old behaviour... not
all machines are cheaply-build.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
