Return-Path: <linux-kernel-owner+w=401wt.eu-S1758412AbYGKJLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758412AbYGKJLo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 05:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757680AbYGKJK5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 05:10:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55674 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757585AbYGKJK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 05:10:56 -0400
Date: Fri, 11 Jul 2008 11:10:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Robert Richter <robert.richter@amd.com>, linux-kernel@vger.kernel.org,
       the arch/x86 maintainers <x86@kernel.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [x86, patch] turn x86 VISWS into a generic architecture
Message-ID: <20080711091041.GA30198@elte.hu>
References: <20080710170712.GA14583@elte.hu> <20080711083946.GU7963@erda.amd.com> <20080711085407.GB20987@elte.hu> <86802c440807110201u4ece646aw4d67a2630d653b33@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440807110201u4ece646aw4d67a2630d653b33@mail.gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> > Ok. Mind sending a patch for this against tip/master? Both your 
> > changes and the visws cleanups are all in there and are tested 
> > through on typical hardware.
> >
> > (Also, there's the suggestion from Yinghai to first do the numa 
> > init.)
> 
> could change the numa.c to numaq.c too. that name is confusing..

agreed. Maybe rename it to numaq_32.c as well.

Then we could potentially eliminate the NUMAQ subarch altogether as well 
and merge all it into arch/x86/kernel/numaq_quirks.c, just like we did 
it for arch/x86/kernel/visws_quirks.c?

That reminds me, wouldnt it all be better in a single place, i.e. move 
arch/x86/pci/visws.c into arch/x86/kernel/visws_quirks.c as well? Such 
quirks are better viewed in their entirety in a single file, i'm not 
sure it makes sense to spread them out.

This way, instead of having this mess of entire subarches, we'd have a 
single, clean "quirks driver" file, conditionally buildable into the 
generic PC code, that would register itself with all the generic quirk 
hooks that are needed for a given weird box.

	Ingo
