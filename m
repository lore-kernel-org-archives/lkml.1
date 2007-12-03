Return-Path: <linux-kernel-owner+w=401wt.eu-S1754969AbXLCJRj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969AbXLCJRj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 04:17:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751909AbXLCJRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 04:17:31 -0500
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:26231 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751409AbXLCJRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 04:17:30 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=coiBR5TYzsVBoA9W1TQXmpGHsh+xbUB+ji/MqCvz3igZcyE+veMY75DsEpcNHQ/PD4HH7ro4d+ZMoz30Edc2TXXyGsVPgHO7FifJGoKFYG1B7wdaFIPkxt0gmQEinzRbtl97CS6Vdpt6081Xa7CUANjV6T3kjCl27FdhssY6Czg=  ;
X-YMail-OSG: 4nyPsJEVM1ld1JE2xo8PRzqEsXv.rGwttWEQX.fUaFwibPPJtvLBDqBFj58ZgvnKqImrjA8M9A--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: sched_yield: delete sysctl_sched_compat_yield
Date: Mon, 3 Dec 2007 20:17:19 +1100
User-Agent: KMail/1.9.5
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <1196155985.25646.31.camel@ymzhang> <200712031527.57129.nickpiggin@yahoo.com.au> <20071203084557.GA13156@elte.hu>
In-Reply-To: <20071203084557.GA13156@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712032017.19661.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 December 2007 19:45, Ingo Molnar wrote:
> * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > On Friday 30 November 2007 21:08, Ingo Molnar wrote:
> > > * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > > > Haven't we been asking JVMs to use futexes or posix locking for years
> > > > and years now? [...]
> > >
> > > i'm curious, with what JVM was it tested and where's the source so i
> > > can fix their locking for them? Can the problem be reproduced with:
> >
> > Sure, but why shouldn't the compat behaviour be the default, and the
> > sysctl go away?
> >
> > It makes older JVMs work better, it is slightly closer to the old
> > behaviour, and it is arguably a less surprising result.
>
> as far as desktop apps such as firefox goes, the exact opposite is true.
> We had two choices basically: either a "more agressive" yield than
> before or a "less agressive" yield. Desktop apps were reported to hurt
> from a "more agressive" yield (firefox for example gets some pretty bad
> delays), so we defaulted to the less agressive method. (and we defaulted
> to that in v2.6.23 already)

Yeah, I doubt the 2.6.23 scheduler will be usable for distros though...


> Really, in this sense volanomark is another 
> test like dbench - we care about it but not unconditionally and in this
> case it's a really silly API use that is at the center of the problem.

Sure, but do you whether _real_ java server applications are OK? Is it
possible to reduce the aggressiveness of yield to a mid-way? Are the
firefox tests also like dbench (ie. were they done with make -j huge or
some other insane scheduler loads)


> Talking about the default alone will not bring us forward, but we can
> certainly add helpers to identify SCHED_OTHER::yield tasks - a once per
> bootup warning perhaps?

I don't care about keeping the behaviour for future apps. But for older
code out there, it is very important to still work well.

I was just talking about the default because I didn't know the reason
for the way it was set -- now that I do, we should talk about trying to
improve the actual code so we don't need 2 defaults.
