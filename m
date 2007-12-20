Return-Path: <linux-kernel-owner+w=401wt.eu-S1763635AbXLTWY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763635AbXLTWY7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 17:24:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752316AbXLTWYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 17:24:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:44161 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753161AbXLTWYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 17:24:48 -0500
Date: Thu, 20 Dec 2007 23:24:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH 0/5] x86: another attempt at x86 pagetable unification
Message-ID: <20071220222429.GA28029@elte.hu>
References: <20071219223534.129042140@goop.org> <20071220094940.GA14227@elte.hu> <20071220112022.GA15832@elte.hu> <476AD9EA.7010108@goop.org> <20071220213906.GB11897@elte.hu> <476AE7D6.9000600@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <476AE7D6.9000600@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> But byte-for-byte identity isn't (necessarily) possible when actually 
> unifying. If the same function exists in different forms on 32- and 
> 64-bit, then unifying requires I pick one of them (or perhaps a new 
> superset) to use in the unified form. That function may generate 
> different code compared to the one that it replaced...

it's still possible: you can do preparatory patches that bring one 
architecture in sync with the other one, in small, per function steps. 
Then the actual unification is still an identity transformation. (and 
all the preparatory patches are small and bisectable)

it's also a lot less frustrating and a lot more enjoyable that way IMO. 
If it's 50 small patches, then so be it ... 50 patches only take ~2 
seconds more for me to apply to x86.git (which time is immediately saved 
by the vastly improved reviewability and testability of a 50 patches 
set), so dont worry about any overhead on the maintainers side. And 
you'll end up moving up on the v2.6.25 contributors top-list on LWN as 
well ;-) The worst aspect of it is writing up the 50 changelogs (i use 
pre-created templates for that) and figuring out how to script a 
patch-bomb to lkml. In every other aspect it's a win-win scenario for 
everyone involved.

	Ingo
