Return-Path: <linux-kernel-owner+w=401wt.eu-S1764223AbXINNQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764223AbXINNQV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 09:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763929AbXINNPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 09:15:55 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:22563 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1763849AbXINNPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 09:15:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ze+L9qYjnjD76lt9kXJB+Do4ZJAEXS8gzAP+vxRN7NCUOoFeeYOAOUMcjRC2jmwo+8tBj7pz/F6L5yyxOph9xR3sz26+1BhFITk1S2fFvLBbgoxgpWUuhFggERLC46TM6j/3TEnKF20Dykwa9g4i/WAiIqLaS2yXMYQH1IPPJcY=  ;
X-YMail-OSG: 5fhEF6UVM1kZzzFjDl2gLd5iDYEHji8vvfsiK72f9wgsiE4QpGa82nRYRWrYn28dH7BJEIV7_w--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Soeren Sonnenburg <kernel@nn7.de>
Subject: Re: 2.6.22.6: kernel BUG at fs/locks.c:171
Date: Fri, 14 Sep 2007 07:22:57 +1000
User-Agent: KMail/1.9.5
Cc: linux-fsdevel@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
References: <1189675222.5352.10.camel@localhost> <200709130951.48194.nickpiggin@yahoo.com.au> <1189749754.25045.10.camel@localhost>
In-Reply-To: <1189749754.25045.10.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709140722.58046.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 September 2007 16:02, Soeren Sonnenburg wrote:
> On Thu, 2007-09-13 at 09:51 +1000, Nick Piggin wrote:
> > On Thursday 13 September 2007 19:20, Soeren Sonnenburg wrote:
> > > Dear all,
> > >
> > > I've just seen this in dmesg on a AMD K7 / kernel 2.6.22.6 machine
> > > (config attached).
> > >
> > > Any ideas / which further information needed ?
> >
> > Thanks for the report. Is it reproduceable? It seems like the
> > locks_free_lock call that's oopsing is coming from __posix_lock_file.
> > The actual function looks fine, but the lock being freed could have
> > been corrupted if there was slab corruption, or a hardware corruption.
> >
> > You could: try running memtest86+ overnight. And try the following
> > patch and turn on slab debugging then try to reproduce the problem.
>
> OK so far I've run memtest86+ 1.40 from freedos for 8 hrs (v1.70 hung on
> startup) - nothing.

Thanks.

> Could this corruption be caused by a pci card/driver? I am asking as I
> am using a new dvb-t card (asus p7131) and the oops happened after 5 or
> 6 days of uptime just about a day after watching some movie (very bad
> reception/lots of errors).

It could be caused by that, definitely. slab debugging plus my earlier
patch may help to narrow it down. (or stress testing with / without the
dvb card in action).


> However this machine used to have uptimes of months before the dvb card
> was in there and the kernel version upgrade (don't know which version
> that was...).
>
> Anyway I am not sure if this is reproducible, but I will keep memtest
> running today and then proceed as you said...

OK. Don't put too much effort into memtest if it hasn't caught anything
by now -- it's really only exercising your CPU and memory, so even if it
is your video hardware, it probably won't find the problem.
