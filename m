Return-Path: <linux-kernel-owner+w=401wt.eu-S1755733AbYFLDkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755733AbYFLDkq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 23:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbYFLDkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 23:40:37 -0400
Received: from smtp112.mail.mud.yahoo.com ([209.191.84.65]:27915 "HELO
	smtp112.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751678AbYFLDkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 23:40:36 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=KNOxniIUSoRNeD8uWztNoK4OrJZrCsCJDF3KFDjp/m6Vj39uCAa+PVK4w3+XHPiQh9O6YZ1XTrTfk4ogkOfjdv8P7xP/L4a91RuAXM1TO+Y4tjs5FJW1A0J2QIc2fbb8WWYuhEOsEA6wMRw1eDpbHSjnfK7rj8MQ3WSPZITf/Xg=  ;
X-YMail-OSG: qI8V6ngVM1mmDTHvo7l3NU7Z0Kq8T9aLuZxJZC6O30fie37piZQZyz3x6rimsY8p2eQ6vhWmeufAOaPxB.1mcIWqYq3bqLCHMU3WlU89XoMRsC7QixBk7gPlq1SqAIdATqU-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch 04/41] cpu ops: Core piece for generic atomic per cpu operations
Date: Thu, 12 Jun 2008 13:40:28 +1000
User-Agent: KMail/1.9.5
Cc: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Travis <travis@sgi.com>,
       Martin Peschke <mp3@de.ibm.com>
References: <20080530035620.587204923@sgi.com> <200806121058.02125.nickpiggin@yahoo.com.au> <200806121244.12173.rusty@rustcorp.com.au>
In-Reply-To: <200806121244.12173.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806121340.29366.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 June 2008 12:44, Rusty Russell wrote:
> On Thursday 12 June 2008 10:58:01 Nick Piggin wrote:
> > On Thursday 12 June 2008 09:39, Christoph Lameter wrote:
> > > On Wed, 11 Jun 2008, Rusty Russell wrote:
> > > > > 4. The modeling of local_t on atomic_t limits it to 32bit!
> > > >
> > > > Again wrong.  And adding an exclamation mark doesn't make it true.
> > >
> > > Ewww ... Its atomic_long_t ahh. Ok then there no 32 bit support. What
> > > about pointers?
> >
> > sizeof(long) == sizeof(void *) in Linux, right?
> >
> > If you were to support just a single data type, long would probably
> > be the most useful. Still, it might be more consistent to support
> > int and long, same as atomic.
>
> Sure, but in practice these tend to be simple counters: that could well
> change when dynamic percpu allocs become first class citizens, but let's
> not put the cart before the horse...

Right, I was just responding to Christoph's puzzling question.


> Per-cpu seems to be particularly prone to over-engineering: see commit
> 7ff6f08295d90ab20d25200ef485ebb45b1b8d71 from almost two years ago. 
> Grepping here reveals that this infrastructure is still not used.

Hmm. Something like that needs the question asked "who uses this?"
before it is merged I guess. If it were a trivial patch maybe not,
but something like this that sits untested for so long is almost
broken by definition ;)
