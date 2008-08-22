Return-Path: <linux-kernel-owner+w=401wt.eu-S1754968AbYHVFzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968AbYHVFzJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 01:55:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752675AbYHVFyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 01:54:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54650 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674AbYHVFyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 01:54:53 -0400
Date: Fri, 22 Aug 2008 07:54:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] x86-64: fix 1:1 mapping init (hotplug case)
Message-ID: <20080822055437.GA14110@elte.hu>
References: <48AD895A.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48AD895A.76E4.0078.0@novell.com>
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


* Jan Beulich <jbeulich@novell.com> wrote:

> While I don't have a hotplug capable system at hand, I think two issues need
> fixing:
> - pud_phys (in kernel_physical_ampping_init()) would remain uninitialized in
>   the after_bootmem case
> - the locking done just around phys_pmd_{init,update}() would leave out pgd
>   updates, and it was needlessly covering code portions that do allocations
>   (perhaps using a more friendly gfp value in alloc_low_page() would then be
>   possible)

applied to tip/x86/urgent. Some sort of memory hotplug simulation debug 
code would be nice ... [bonus points for making it run automatically 
during bootup, as part of the kernel init code]

it wouldnt even be all that expensive to test: we'd parts of RAM as 
to-be-hotplugged, we'd boot in and then hot-add those ranges. It's not 
full unrestricted RAM in the classic sense, but for most practical 
purposes it would be that.

	Ingo
