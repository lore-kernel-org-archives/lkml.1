Return-Path: <linux-kernel-owner+w=401wt.eu-S1754101AbYHSJcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbYHSJcA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 05:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbYHSJbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 05:31:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53738 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188AbYHSJbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 05:31:51 -0400
Date: Tue, 19 Aug 2008 11:31:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Andi Kleen <andi@firstfloor.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0 of 9] x86/smp function calls: convert x86 tlb flushes
	to use function calls [POST 2]
Message-ID: <20080819093130.GF28713@elte.hu>
References: <patchbomb.1219083817@localhost> <20080819004531.GI9914@elte.hu> <48AA5C19.3010204@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48AA5C19.3010204@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
> > nice stuff!
> >
> > I suspect the extra cost might be worth it for two reasons: 1) we could 
> > optimize the cross-call implementation further
> 
> Unfortunately, I think the kmalloc fix for the RCU issue is going to 
> hurt quite a lot.

yeah :-(

Nick, is there any way to get rid of that kmalloc() in the async 
function call case? The whole premise of the smp_function_call() rewrite 
was that it's faster - and now it's measurably slower.

At least we could/should perhaps standardize/generalize all the 
'specific' IPI handlers into the smp_function_call() framework: if 
function address equals to a pre-cooked IPI entry point we could call 
that function without a kmalloc. As these are all hardwired, 
__builtin_is_constant_p() could come to the help as well. Hm?

	Ingo
