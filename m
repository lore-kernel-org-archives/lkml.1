Return-Path: <linux-kernel-owner+w=401wt.eu-S1762589AbXKNS4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762589AbXKNS4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 13:56:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760743AbXKNS4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 13:56:23 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34629 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760432AbXKNS4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 13:56:22 -0500
Date: Wed, 14 Nov 2007 19:55:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       Rik van Riel <riel@redhat.com>, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] Give kjournald a IOPRIO_CLASS_RT io priority
Message-ID: <20071114185526.GB4943@elte.hu>
References: <20071015104647.14e60bc5@laptopd505.fenrus.org> <20071015114738.6b5a25c7.akpm@linux-foundation.org> <20071015161315.4fe18e07@bree.surriel.com> <20071015141236.62b075c6.akpm@linux-foundation.org> <473B18BA.5000709@hp.com> <20071114091451.d4b110db.akpm@linux-foundation.org> <20071114171805.GA20959@elte.hu> <20071114095151.43c5e576@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114095151.43c5e576@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@infradead.org> wrote:

> > > >     * The read-a-different-kernel-tree task, average over 10 runs:
> > > >           o 2.6.24 - 46.8145945549 seconds
> > > >           o 2.6.24 + Arjan's patch - 39.6430601119 seconds
> > > > 
> > > >     * The large-linear-read task (on an 8GiB file), average over
> > > > 10 runs: o 2.6.24 - 290.32522 seconds
> > > >           o 2.6.24 + Arjan's patch - 386.34860 seconds
> > > 
> > > These are *large* differences, making this a very signifcant
> > > patch. Much care is needed now.
> > 
> > and the numbers suggest it's mostly a severe performance regression. 
> > That's not what i have expected - ho hum. Apologies for my earlier 
> > "please merge it already!" whining.
> 
> that's.. not automatic; it depends on what the right thing is :-( What 
> for sure changes is that who gets to do IO changes. Some of the tests 
> we ran internally (we didn't publish yet because we saw REALLY large 
> variations for most of them even without any patch) show for example 
> that "dbench" got slower. But.. dbench gets slower when things get 
> more fair, and faster when things get unfair. What conclusion you draw 
> out of that is a whole different matter and depends on exactly what 
> the test is doing, and what is the right thing for the OS to do in 
> terms of who gets to do the IO.

yeah, i'd agree to not too much faith into dbench results.

	Ingo
