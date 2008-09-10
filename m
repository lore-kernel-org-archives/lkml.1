Return-Path: <linux-kernel-owner+w=401wt.eu-S1752593AbYIJJvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593AbYIJJvb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 05:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbYIJJvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 05:51:23 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:36509 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751501AbYIJJvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 05:51:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=zSc+AWg+uBzjP20nLlIU8j3i325iTlj3Us2Q4YdmwBleO3bi4iW7eJOtE9jZkvDCjL6DwHXMfmzsixJOPYfkqKPgyFPiMTvTKNxwqRpLjp7r8w4R8QT1h0mmjg+ftbqTDU/cGZpZoxmEyWOqzhkyjkofjrGVZO9eLex3sZkbw58=  ;
X-YMail-OSG: aHdIN2gVM1l0qfZKw3E9.h.CADA8MxC2ihPI6plwlWKhJVPD0jeLj9Kk.2YN20rFv7mDpABFLxyRv4CcyypgEYpD1J4HCe_kueDyCEOQkJUf6ZeV4ExdyDD8nqXQ0oR7NTJi3gftujptctdSzxp8fY0_
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [2.6.27-rc5] inotify_read's ev_mutex vs do_page_fault's mmap_sem...
Date: Wed, 10 Sep 2008 19:50:27 +1000
User-Agent: KMail/1.9.5
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Daniel J Blueman <daniel.blueman@gmail.com>,
       torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <6278d2220809091403k65187128keec3b401717f1ec0@mail.gmail.com> <200809101803.20758.nickpiggin@yahoo.com.au> <20080910083749.GH15255@elte.hu>
In-Reply-To: <20080910083749.GH15255@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809101950.27669.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 September 2008 18:37, Ingo Molnar wrote:
> * Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> > On Wednesday 10 September 2008 17:57, Peter Zijlstra wrote:

> > > Sure, how about the below - untested - uncompiled, might eat kittens,
> > > etc..
> > >
> > > Just sprinkle something like:
> > >
> > >   might_lock_read(&mm->mmap_sem);
> > >
> > > in the right places.
> >
> > Ahh, very nice, thanks! I'll give that a try...
>
> cool! Please send in an RFC patch once you have something that boots -
> we can stick it into tip/core/locking and see whether there's any new
> messages on a wide range of systems and workloads. (and we'd also check
> whether the number of kittens is an invariant.)

Well I have verified it boots, and have used the annotation in some of
x86-64's user copy routines (luckily no flood of bugs I was scared of,
phew!)

So I would like to request you merge Peter's patch, and we'll hopefully
start seeing the annotations being used. FWIW, I don't suppose lockdep
can determine that it is a sleeping lock, and do the appropriate
might_sleep checks at this point as well?

Thanks,
Nick


