Return-Path: <linux-kernel-owner+w=401wt.eu-S1756802AbYAUAVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802AbYAUAVN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 19:21:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754585AbYAUAU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 19:20:59 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41488 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755402AbYAUAU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 19:20:58 -0500
Date: Mon, 21 Jan 2008 01:20:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, venkatesh.pallipadi@intel.com,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Fix early_ioremap on x86-64
Message-ID: <20080121002041.GA31280@elte.hu>
References: <20080120172840.GA24608@basil.nowhere.org> <20080120175955.GA4993@elte.hu> <20080120191247.GA28190@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080120191247.GA28190@one.firstfloor.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Andi Kleen <andi@firstfloor.org> wrote:

> > Jeremy did suspect something about this change, as indicated in the 
> > changelog. But because the change was so finegrained, the bisection 
> > almost directly led to the fix. _That_ i think clearly demonstrates 
> > the power of bisection and finegrained changes.
> 
> Actually it is pretty hard to do bisects in current git-x86 currently 
> because you don't ammend original buggy changes but just stuff the 
> fixes at the end. [...]

i backmerge fixes all the time. x86.git consists of more than 800 
patches and there are less than 10 tail-fixes in it - they are all at 
the tail for a reason: because they have not all been fully qa-ed yet so 
they might make things worse than what they try to fix. Once they are 
proven i backmerge them to their proper spot.

and i frequently bisect x86.git#mm myself (almost daily) - and others do 
it frequently too. There have been dozens of successful bisections done 
on x86.git. (I believe it is so successful partly because we run 
overnight automated bisectability tests: to make sure x86.git builds and 
boots at every bisection point.)

Yours is the first claim of x86.git#mm being hard to bisect - so far all 
other feedback was to the contrary. I claim that it is one of the most 
bisectable subsystems in the kernel.

But we all err: if something slipped through despite all the testing, 
let us know and we'll fix it up - it's just that your vague complaints 
about non-bisectability wont help much in resolving the problem. You are 
ignoring months of track record of excellent bisectability of x86.git 
and your claims are quite unjust.

Reordering of patches is usually easy and trickling back the tail-fixes 
to the actual buggy patches is easy and routine as well, except when 
someone submits conceptually non-bisectable patches, like:

|   Subject: Undo pat cpa patch
|   From: Andi Kleen <ak@suse.de>
|
|   Going to implement this differently

and then 4 patches later you do:

|   Subject: CPA: Implement change_page_attr_addr entry point for i386
|   From: Andi Kleen <ak@suse.de>

this breaks PAT completely in that window and makes it non-bisectable.

So i find it a bit dishonest from you that you are now complaining about 
the supposed non-bisectability of x86.git ...

> -Andi (seemingly chief QA officer of git-x86 currently)

Andi, could you please stop these snide remarks? x86.git is the 
development tip of the new arch/x86 tree and you should know that. I 
boot it more than a 1000 times a day on my QA-grid, with different 
kernel configs, so it's far from being unusable.

I update x86.git multiple times a day so that people can see the changes 
immediately. But you are now abusing this transparency to create a false 
impression of flakiness. If you cannot stop being negative then please 
just dont deal with x86.git#mm - it's not obligatory to contribute.

Furthermore, your complaint is doubly unjust because we've fixed a good 
deal of bugs in x86.git introduced by _you_. You are by far not the only 
person who fixes bugs in x86.git and you are by far not the most active 
one either - but you are certainly the loudest one :-(
 
	Ingo
