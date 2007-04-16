Return-Path: <linux-kernel-owner+w=401wt.eu-S1030680AbXDPOge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030680AbXDPOge (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 10:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030684AbXDPOge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 10:36:34 -0400
Received: from [212.12.190.15] ([212.12.190.15]:33000 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030683AbXDPOgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 10:36:33 -0400
From: Al Boldi <a1426z@gawab.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
Date: Mon, 16 Apr 2007 17:38:52 +0300
User-Agent: KMail/1.5
References: <200704150931.42268.a1426z@gawab.com>
In-Reply-To: <200704150931.42268.a1426z@gawab.com>
Cc: William Lee Irwin III <wli@holomorphy.com>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200704161738.52870.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * William Lee Irwin III <wli@holomorphy.com> wrote:
> > On Sun, Apr 15, 2007 at 09:57:48PM +0200, Ingo Molnar wrote:
> > > Oh I was very much testing "CPU bandwidth allocation as influenced by
> > > nice numbers" - it's one of the basic things i do when modifying the
> > > scheduler. An automated tool, while nice (all automation is nice)
> > > wouldnt necessarily show such bugs though, because here too it needed
> > > thousands of running tasks to trigger in practice. Any volunteers? ;)
> >
> > Worse comes to worse I might actually get around to doing it myself.
> > Any more detailed descriptions of the test for a rainy day?
>
> the main complication here is that the handling of nice levels is still
> typically a 2nd or 3rd degree design factor when writing schedulers. The
> reason isnt carelessness, the reason is simply that users typically only
> care about a single nice level: the one that all tasks run under by
> default.
>
> Also, often there's just one or two good ways to attack the problem
> within a given scheduler approach and the quality of nice levels often
> suffers under other, more important design factors like performance.
>
> This means that for example for the vanilla scheduler the distribution
> of CPU power depends on HZ, on the number of tasks and on the scheduling
> pattern. The distribution of CPU power amongst nice levels is basically
> a function of _everything_. That makes any automated test pretty
> challenging. Both with SD and with CFS there's a good chance to actually
> formalize the meaning of nice levels, but i'd not go as far as to
> mandate any particular behavior by rigidly saying "pass this automated
> tool, else ...", other than "make nice levels resonable". All the other
> more formal CPU resource limitation techniques are then a matter of
> CKRM-alike patches, which offer much more finegrained mechanisms than
> pure nice levels anyway.
>
> so to answer your question: it's pretty much freely defined. Make up
> your mind about it and figure out the ways how people use nice levels
> and think about which aspects of that experience are worth testing for
> intelligently.

I think this post, http://lkml.org/lkml/2007/4/15/5, shows the problem 
clearly with only 3 tasks running.


Thanks!

--
Al

