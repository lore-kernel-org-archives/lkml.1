Return-Path: <linux-kernel-owner+w=401wt.eu-S1754163AbYL0KPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163AbYL0KPP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 05:15:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbYL0KPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 05:15:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44509 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653AbYL0KPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 05:15:00 -0500
Date: Sat, 27 Dec 2008 11:14:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Hugh Dickins <hugh@veritas.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [RFC] boot parameter handling cleanup II
Message-ID: <20081227101426.GB14639@elte.hu>
References: <Pine.LNX.4.64.0812230257440.27467@blonde.anvils> <86802c440812222152yd000009yf890f5cd303860e4@mail.gmail.com> <20081223143327.GF29151@elte.hu> <200812252247.12957.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812252247.12957.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> (Not much change since last time, just consolidated fixes aired here, esp.
>  x86 early_param fixes thanks to Hugh and Yinghai.)
> 
> The following changes since commit 4a6908a3a050aacc9c3a2f36b276b46c0629ad91:    
>   Linus Torvalds (1):                                                           
>         Linux 2.6.28                                                            
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux-2.6-boot-params.git master                                                                          

(it would be useful to embedd the full patch in such cases in the email - 
makes for a quicker review)

>  arch/x86/include/asm/cpufeature.h          |    4 +-
>  arch/x86/include/asm/processor.h           |    3 +-
>  arch/x86/kernel/cpu/common.c               |   22 +++++--
>  arch/x86/kernel/e820.c                     |   88 +++++++++++++++++----------
>  arch/x86/kernel/setup.c                    |   41 ++++++-------
>  arch/x86/mm/init_32.c                      |   11 ++-

no objections from the x86 perspective, as long as it does not break 
stuff. If it breaks stuff it's all your fault ;-) I checked these commits:

 218a372: x86: override_capabilities in early_identify_cpu
 5144b68: x86: prepare noexec for being called earlier
 5689919: x86: clean up setup_clear/force_cpu_cap handling
 b41144e: x86: act on mem= and memmap= later in boot

and they definitely look like a step forward.

One detail: please send a pull request to Linus after the pending x86 tree 
went upstream, so that there are no conflicts with existing x86 items. 
There will be a (trivial) context-overlap conflict in 
arch/x86/kernel/cpu/common.c.

	Ingo
