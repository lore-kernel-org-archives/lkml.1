Return-Path: <linux-kernel-owner+w=401wt.eu-S1757079AbYHKTym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079AbYHKTym (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 15:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbYHKTye
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 15:54:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38870 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501AbYHKTye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 15:54:34 -0400
Date: Mon, 11 Aug 2008 21:54:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, David Miller <davem@davemloft.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.27rc1 cannot boot more than 8CPUs
Message-ID: <20080811195421.GN12788@elte.hu>
References: <Pine.LNX.4.64.0808061908100.12476@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0808061908100.12476@boston.corp.fedex.com>
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


* Jeff Chua <jeff.chua.linux@gmail.com> wrote:

>
> On Wed, Aug 6, 2008 at 5:42 PM, Jeff Chua <jeff.chua.linux@gmail.com>  
> wrote:
>>>> CONFIG_X86_GENERICARCH=y
>>>> CONFIG_X86_BIGSMP=y
>>>> 8 more cpu need bigsmp mode.
>
>> Just found it under " Subarchitecture Type (Generic architecture)",
>> and then it shows the CONFIG_X86_BIGSMP option.
>
> It works. Booted with 16CPUs. 32GB RAM.
>
> CPU0 L7345 1.86GHz  0C
> CPU1 L7345 1.86GHz  0C
> CPU2 L7345 1.86GHz  0C
> CPU3 L7345 1.86GHz  0C
> CPU4 L7345 1.86GHz  0C
> CPU5 L7345 1.86GHz  0C
> CPU6 L7345 1.86GHz  0C
> CPU7 L7345 1.86GHz  0C
> CPU8 L7345 1.86GHz  0C
> CPU9 L7345 1.86GHz  0C
> CPU10 L7345 1.86GHz  0C
> CPU11 L7345 1.86GHz  0C
> CPU12 L7345 1.86GHz  0C
> CPU13 L7345 1.86GHz  0C
> CPU14 L7345 1.86GHz  0C
> CPU15 L7345 1.86GHz  0C
>
>
> So, but setting the config not obvious. And should CONFIG_X86_PC be  
> considered as well as CONFIG_X86_GENERICARCH?
>
> With CONFIG_X86_PC, I can set CONFIG_SPARSEMEM=y.
>
> With CONFIG_X86_GENERICARCH, CONFIG_SPARSEMEM depends on CONFIG_NUMA.
>
> I'm using the patch below to enable sparsemem instead of flatmem, but  
> don't know what impact it has. System booted and running.
>
> It would be nice to automatically default CONFIG_X86_BIGSMP with CPUs 
> > 8. But I don't know to do that.

thanks, applied.

i'm wondering, does with that patch applied a working 2.6.26 .config if 
put through 'make oldconfig' boot fine on your box now? Any make 
oldconfig breakage is a regression we want to fix. We want upgrades 
between kernel versions to be seemless and complete.

	Ingo
