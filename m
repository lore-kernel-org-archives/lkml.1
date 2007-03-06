Return-Path: <linux-kernel-owner+w=401wt.eu-S934106AbXCFNLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934106AbXCFNLb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 08:11:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934110AbXCFNLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 08:11:31 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46404 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934106AbXCFNL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 08:11:29 -0500
Date: Tue, 6 Mar 2007 14:10:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 8/8] Convert PDA into the percpu section
Message-ID: <20070306131041.GB9031@elte.hu>
References: <1173184747.4644.23.camel@localhost.localdomain> <1173185592.4644.28.camel@localhost.localdomain> <1173185666.4644.30.camel@localhost.localdomain> <1173185734.4644.32.camel@localhost.localdomain> <1173185827.4644.34.camel@localhost.localdomain> <1173185909.4644.36.camel@localhost.localdomain> <1173186021.4644.38.camel@localhost.localdomain> <1173186107.4644.41.camel@localhost.localdomain> <1173186214.4644.44.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1173186214.4644.44.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> Currently x86 (similar to x84-64) has a special per-cpu structure 
> called "i386_pda" which can be easily and efficiently referenced via 
> the %fs register.  An ELF section is more flexible than a structure, 
> allowing any piece of code to use this area.  Indeed, such a section 
> already exists: the per-cpu area.
> 
> So this patch
> (1) Removes the PDA and uses per-cpu variables for each current member.

hmm ... i very much like this, but its needs performance and kernel-size 
testing before it can move from -mm into mainline. We are now exposing 
wide ranges of the kernel to segment prefixes again. (Btw., i'd expect 
there to be a kernel size reduction.)

	Ingo
