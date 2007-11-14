Return-Path: <linux-kernel-owner+w=401wt.eu-S1752314AbXKNIi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314AbXKNIi3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 03:38:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbXKNIiB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 03:38:01 -0500
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:46960 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751644AbXKNIiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 03:38:00 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=PMZnwRwU0Gvmk9oy9o8S4OS8xf9yE+APJ2bRScZF6EvMUaX7KZifw2n2owH0s3DdL9O+++55EGp3FTRKIB9RtVI33UC1MPRulci11dMTkuW9YbagR4q7HlSIn+aSk+I3lB2CnfQ5XhcI0JQ+Nq0fVsxIel0p27j9eeQUJW9fWj4=  ;
X-YMail-OSG: 8mQQ4sMVM1m34N_ugGy7bM6gTZLSTUp60Yk5VpVzzciPfVzd.0BGscqp8V2aebMpkqV7PCol5g--
From: David Brownell <david-b@pacbell.net>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [patch 2.6.24-rc2 1/3] generic gpio -- gpio_chip support
Date: Wed, 14 Nov 2007 00:37:57 -0800
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Florian Fainelli <florian.fainelli@telecomint.eu>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
References: <200711091136.20051.david-b@pacbell.net> <200711132252.15872.david-b@pacbell.net> <200711140645.26363.nickpiggin@yahoo.com.au>
In-Reply-To: <200711140645.26363.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200711140037.58049.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 November 2007, Nick Piggin wrote:
> On Wednesday 14 November 2007 17:52, David Brownell wrote:
> > On Tuesday 13 November 2007, Andrew Morton wrote:
> 
> > > > I'll highlight the
> > > > point that such bitops shouldn't be preemption points.
> > >
> > > Disagree.  *everything* should be a preemption point.
> >
> > So it's wrong that <asm-generic/bitops/atomic.h> uses the
> > same calls to prevent *those* bitops from being prempted?
> 
> Upstream, all spinlocks prevent preemption.

I chose my wording carefully though.  A preemption point is
more than just a small region where preemption isn't allowed.

It's one of those where preemption is *INVITED* ...

Now, in the RT case, I believe the rationale for inviting
preemption when dropping a lock is largely related to the
way priority inversion is handled.  When lock contention can
block higher priority activities, dropping the lock must
be able to trigger the relevant activity switch.

... and the raw spinlocks don't support that machinery,
while "normal" spinlocks become inversion-aware mutexes.


> But these ones 
> are raw locks rather than normal locks probably because that
> they are trivially an innermost and correct lock.

As in the $SUBJECT case, I'd say.

Although another point is related to "trivial":  the data
is being protected through an operation too trivial to be
worth paying for any of that priority logic.

