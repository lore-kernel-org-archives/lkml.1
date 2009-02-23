Return-Path: <linux-kernel-owner+w=401wt.eu-S1756531AbZBWUJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531AbZBWUJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 15:09:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753480AbZBWUJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 15:09:43 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53392 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753211AbZBWUJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 15:09:43 -0500
Date: Mon, 23 Feb 2009 21:09:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: paulmck@linux.vnet.ibm.com, nickpiggin@yahoo.com.au,
       vegard.nossum@gmail.com, stable@kernel.org, npiggin@suse.de,
       penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: fix lazy vmap purging (use-after-free error)
Message-ID: <20090223200925.GA25994@elte.hu>
References: <20090220140157.GA12799@elte.hu> <20090222030030.GD6860@linux.vnet.ibm.com> <20090223051709.GA5990@linux.vnet.ibm.com> <200902240029.37815.nickpiggin@yahoo.com.au> <20090223161726.GD6751@linux.vnet.ibm.com> <20090223111009.d48ff81d.akpm@linux-foundation.org> <20090223193351.GA11921@elte.hu> <20090223120401.b1354133.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090223120401.b1354133.akpm@linux-foundation.org>
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

> On Mon, 23 Feb 2009 20:33:51 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > > > Nice work all (btw. if this patch goes in rather than using system_state,
> > > > > then please make the variable __read_mostly).
> > > > 
> > > > Hmmm...  I misread this and made system_state be __read_mostly.  Let
> > > > me know if this is bad, easy to fix if needed.
> > > 
> > > Please don't use system_state.  The whole thing is just bad 
> > > design. It's a global variable, breaks encapsulation, creates 
> > > interactions etc. CS-101 stuff.
> > 
> > ok, i've removed the patch
> 
> Thanks.
> 
> > - Paul, would you mind to re-send your original flag 
> > solution, with it marked __read_mostly and with the extern 
> > declarations put into a suitable header file?
> 
> It would still make sense to mark system_state __read_mostly.
> 
> (That's assuming that __read_mostly makes sense.  I still 
> wanna rename it to 
> __pack_all_write_often_variables_into_the_same_cacheline and 
> see what happens then)

the write often variables should be on separate cachelines. 
Putting them on the same cacheline as a read-mostly variable is 
not helpful.

	Ingo
