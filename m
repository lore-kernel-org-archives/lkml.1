Return-Path: <linux-kernel-owner+w=401wt.eu-S1759414AbXHULVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759414AbXHULVY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 07:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758878AbXHULVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 07:21:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52441 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758854AbXHULVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 07:21:10 -0400
Date: Tue, 21 Aug 2007 13:20:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jan Glauber <jang@linux.vnet.ibm.com>, heiko.carstens@de.ibm.com,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [accounting regression since rc1]  scheduler updates
Message-ID: <20070821112032.GA648@elte.hu>
References: <20070812163225.GA11996@elte.hu> <200708141037.48001.borntraeger@de.ibm.com> <20070820154529.GA300@elte.hu> <1187629438.8541.40.camel@localhost> <20070820180810.GA25160@elte.hu> <p73lkc5zl2m.fsf@bingen.suse.de> <20070821070922.GA16695@elte.hu> <20070821100717.GA692@one.firstfloor.org> <20070821102023.GA24111@elte.hu> <20070821111523.GA3795@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070821111523.GA3795@one.firstfloor.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> > i know there are some incredibly broken (but rare) boxes where the bios 
> > will report it only knows C1 and do C2? Is that the case you are 
> > referring to, or is there something else too?
> 
> There are first a couple of older and not so old (Centaur) chips that 
> generally stop the TSC in C1.

there's not much we can do about them: the ACPI code doesnt measure 
their idle time, right? This is mostly for statistics purposes, so 
unless "broken" means tons of boxes, we dont have to have 100% coverage.

> And also some boxes who shouldn't have anything deeper than C2 have 
> trouble with the TSC. For example I got a Opteron machine (which 
> definitely shouldn't have any C2 since it's two socket) where the TSC 
> appears to stop or at least slow down a lot in C1.

how much is "a lot" in C1? There's an AMD TSC-slows-down-C1 erratum but 
that should be less than 1%. (which is fine enough for idle time 
measurements)

> And thirdly it's just unclean to add all kinds of custom hooks there. 
> It was already ugly in NOHZ, please don't continue that.

i'm not opposed to the idle notifiers but iirc the idle notifiers caused 
problems in themselves so part of them were reverted. We can do this 
more cleanly in .24 - it will make the benefits of the notifier cleanup 
even more apparent.

	Ingo
