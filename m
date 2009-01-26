Return-Path: <linux-kernel-owner+w=401wt.eu-S1754840AbZAZX5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbZAZX5r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 18:57:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751875AbZAZX5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 18:57:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45462 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854AbZAZX5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 18:57:38 -0500
Date: Tue, 27 Jan 2009 00:57:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ying Han <yinghan@google.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, mikew@google.com, rientjes@google.com,
       rohitseth@google.com, hugh@veritas.com, a.p.zijlstra@chello.nl,
       hpa@zytor.com, edwintorok@gmail.com, lee.schermerhorn@hp.com,
       npiggin@suse.de
Subject: Re: [RFC v2][PATCH]page_fault retry with NOPAGE_RETRY
Message-ID: <20090126235715.GB8726@elte.hu>
References: <604427e00812051140s67b2a89dm35806c3ee3b6ed7a@mail.gmail.com> <20090126113728.58212a30.akpm@linux-foundation.org> <604427e00901261508n7967ea74m3deacd3213c86065@mail.gmail.com> <20090126155246.2d7df309.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090126155246.2d7df309.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> I think that a good way to present this is as a preparatory patch: 
> "convert the fourth argument to handle_mm_fault() from a boolean to a 
> flags word".  That would be a simple do-nothing patch which affects all 
> architectures and which ideally would break the build at any unconverted 
> code sites.  (Change the argument order?)

why not do what i suggested: refactor do_page_fault() into a platform 
specific / kernel-internal faults and into a generic-user-pte function. 
That alone would increase readability i suspect.

Then the 'retry' is multiple calls from handle_pte_fault().

Or something like that.

It looks wrong to me to pass another flag through this hot codepath, just 
to express a property that the _highlevel_ code is interested in.

	Ingo
