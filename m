Return-Path: <linux-kernel-owner+w=401wt.eu-S1754447AbZDNK2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447AbZDNK2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 06:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbZDNK2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 06:28:11 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57866 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153AbZDNK2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 06:28:10 -0400
Date: Tue, 14 Apr 2009 12:27:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Tom Zanussi <tzanussi@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/lockdep: turn lock->name into an array
Message-ID: <20090414102754.GH3558@elte.hu>
References: <1239662166-13208-1-git-send-email-fweisbec@gmail.com> <20090413224219.GK5977@nowhere> <1239695296.21985.6725.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239695296.21985.6725.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, 2009-04-14 at 00:42 +0200, Frederic Weisbecker wrote:
> > > +#define LOCK_NAME_SIZE       25
> > 
> > 
> > 
> > This constant may look a bit weird.
> > I just started with the assumption that a full lock name
> > will rarely exceed this length.
> > 
> > If you agree with it, I will expand the conversion of lockdep
> > TRACE_FORMAT to TRACE_EVENTS with the same assumption.
> > So that we will be able to use filters with locks events.
> 
> I really really hate this.
> 
> if you pick a size on the top end so that all lock->name's fit in, 
> you're wasting heaps of space, if you pick a median length, 
> everything will get truncated.
> 
> If you're going to do a copy, just do the print into the buffer by 
> using _FORMAT and be done with it.

what i suggested was a variable length field. That solves the size 
issue. The ring-buffer supports variable size records anyway.

	Ingo
