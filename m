Return-Path: <linux-kernel-owner+w=401wt.eu-S1752764AbYDMHFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764AbYDMHFg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 03:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbYDMHF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 03:05:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40213 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbYDMHF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 03:05:26 -0400
Date: Sun, 13 Apr 2008 09:05:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: [PATCH] Replace completions with semaphores
Message-ID: <20080413070513.GB19773@elte.hu>
References: <20080411210022.GJ11962@parisc-linux.org> <1208003081.7427.7.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208003081.7427.7.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, 2008-04-11 at 15:00 -0600, Matthew Wilcox wrote:
> 
> > So does it make sense to retain the completion as a primitive in 
> > Linux?
> 
> My take on it is the opposite: kill off semaphores and leave the 
> completions around.

exactly. I first misread the subject line because i parsed it as 
"replace semaphores with completions" and i thought "cool", then did i 
realize that the patch does it the other way around. Converting 
completions to semaphores just makes no sense.

Besides all your arguments later in this thread about how problematic 
locking primitives semaphores are because they are so vague (which are 
all correct), there's also another aspect: completions are faster a bit 
in theory, because they know that they will schedule most of the time - 
while semaphores assume that they will _not_ schedule. (And that's 
exactly because the intent of the developer when using a completion is 
crystal clear.)

	Ingo
