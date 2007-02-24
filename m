Return-Path: <linux-kernel-owner+w=401wt.eu-S933582AbXBXXBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933582AbXBXXBH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 18:01:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933584AbXBXXBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 18:01:07 -0500
Received: from wx-out-0506.google.com ([66.249.82.237]:12765 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933582AbXBXXBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 18:01:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=kpsCdrWK3fuxqrfnSzM338qpuTHjLMvjgLZIhNw3Lcel6QYngsBke3psGyMBmGVakFB54BnYj2k3zPgDYzPN7yS1+6ivzX+K8fZJ60bjy3iPSYhJOUe4ROKfzJ1LSBG6sVQzBXvz3T8DUtFNY9FxKmanlnSitHnJgmALYM9L2zU=
Message-ID: <f2b55d220702241501w62a75e15s6b1128c711efd00d@mail.gmail.com>
Date: Sat, 24 Feb 2007 15:01:03 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Cc: "Ingo Molnar" <mingo@elte.hu>, "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>,
       "Ulrich Drepper" <drepper@redhat.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Andrew Morton" <akpm@zip.com.au>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Zach Brown" <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       "Suparna Bhattacharya" <suparna@in.ibm.com>,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <Pine.LNX.4.64.0702241211440.17345@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070221211355.GA7302@elte.hu> <20070221233111.GB5895@elte.hu>
	 <45DCD9E5.2010106@redhat.com> <20070222074044.GA4158@elte.hu>
	 <20070222113148.GA3781@2ka.mipt.ru> <20070222125931.GB25788@elte.hu>
	 <f2b55d220702221324n788506b6oee4f8ed4f168fbf1@mail.gmail.com>
	 <20070223121751.GA6626@elte.hu>
	 <f2b55d220702241152o640abaf3jc10afefaae8476cb@mail.gmail.com>
	 <Pine.LNX.4.64.0702241211440.17345@alien.or.mcafeemobile.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/24/07, Davide Libenzi <davidel@xmailserver.org> wrote:
> Ok, roger that. But why are you playing "Google & Preach" games to Ingo,
> that ate bread and CPUs for the last 15 years?

Sure I used Google -- for clickable references so that lurkers can
tell I'm not making these things up as I go along.  Ingo and Alan have
obviously forgotten more about x86en than I will ever know, and I'm
carrying coals to Newcastle when I comment on pros and cons of XMM
memcpy.

But although the latest edition of the threadlet patches actually has
quite good internal documentation and makes most of its intent clear
even to a reader (me) who is unfamiliar with the code being patched,
it lacks "theory of operations".  How is an arch maintainer supposed
to adapt this interface to a completely different CPU, with different
stuff in pt_regs and different cost profiles for blown pipelines and
reloaded coprocessor state?  What are the hidden costs of this
particular style of M:N microthreading, and will they explode when
this model escapes out of the microbenchmarks and people who don't
know CPUs inside and out start using it?  What standard
thread-pool-management use cases are being glossed over at kernel
level and left to Ulrich (or implementors of JVMs and other bytecode
machines) to sort out?

At some level, I'm just along for the ride; nobody with any sense is
going to pay me to design this sort of thing, and the level of effort
involved in coding an alternate AIO implementation is not something I
can afford to expend on non-revenue-producing activities even if I did
have the skill.  Maybe half of my quibbles are sheer stupidity and
four out of five of the rest are things that Ingo has already taken
account in v4 of his patch set.  But that would leave one quibble in
ten that has some substance, which might save some nasty rework down
the line.  Even if everything I ask about has a simple explanation,
and for Alan and Ingo to waste time spelling it out for me would
result in nothing but an accelerated "theory of operation" document,
would that be a bad thing?

Now I know very little about x86_64 other than that 64-bit code not
only has double-size integer registers to work with, it has twice as
many of them.  So for all I know the transition to pure-64-bit 2-4
core x 2-4 thread/core systems, which is going to be 90% or more of
the revenue-generating Linux market over the next few years, makes all
of my concerns moot for Ingo's purposes.  After all, as long as Linux
stays good enough to keep Oracle from losing confidence and switching
to Darwin or something, the 100 or so people who earn invites to the
kernel summit have cush jobs for life.

The rest of us would perhaps like for major proposed kernel overhauls
to be accompanied by some kind of analysis of their impact on arches
that live elsewhere in CPU parameter space.  That analysis might
suggest small design refinements that make Linux AIO scale well on the
class of processors I'm interested, too.  And I personally would like
to see Ingo get that Turing award for designing AIO semantics that are
as big an advance over the past as IEEE 754 was over its predecessors.
 He'd have to earn it, though.

Cheers,
- Michael
