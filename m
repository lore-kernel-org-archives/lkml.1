Return-Path: <linux-kernel-owner+w=401wt.eu-S1764683AbXFRSDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764683AbXFRSDX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 14:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760408AbXFRSDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 14:03:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43273 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760495AbXFRSDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 14:03:15 -0400
Date: Mon, 18 Jun 2007 20:02:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, cebbert@redhat.com, chris@atlee.ca,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       akpm@linux-foundation.org
Subject: Re: [BUG] long freezes on thinkpad t60
Message-ID: <20070618180258.GA14985@elte.hu>
References: <E1HrWSH-0000mH-00@dorka.pomaz.szeredi.hu> <E1Hyrnk-0006On-00@dorka.pomaz.szeredi.hu> <20070616103707.GA28096@elte.hu> <E1I02Zx-0005qu-00@dorka.pomaz.szeredi.hu> <20070618064343.GA31113@elte.hu> <E1I0Baz-0006cP-00@dorka.pomaz.szeredi.hu> <20070618081204.GA11153@elte.hu> <alpine.LFD.0.98.0706180857120.14121@woody.linux-foundation.org> <E1I0LEG-0008LQ-00@dorka.pomaz.szeredi.hu> <alpine.LFD.0.98.0706181046260.14121@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706181046260.14121@woody.linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > Boots and runs fine.  Fixes the freezes as well, which is not such a 
> > big surprise, since basically any change in that function seems to 
> > do that ;)
> 
> Yeah, and that code really was *designed* to make all "locking in a 
> loop" go away. So unlike the patches adding random barriers and 
> cpu_relax() calls (which might fix it for some *particular* hw setup), 
> I pretty much guarantee that you can never get that code into a 
> situation where there is some lock being starved on *any* hw setup.
> 
> Ingo, an ack for the patch, and I'll just apply it?

yeah. It's definitely better than what we had before. Maybe one day 
someone frees us from this function =B-) We already had like 2-3 nasty 
SMP bugs related to it in the last 10 years.

Acked-by: Ingo Molnar <mingo@elte.hu>

and kudos to Miklos for the patience to debug this bug!

	Ingo
