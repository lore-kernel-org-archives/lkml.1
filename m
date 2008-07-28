Return-Path: <linux-kernel-owner+w=401wt.eu-S1753401AbYG1G7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbYG1G7O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 02:59:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752050AbYG1G66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 02:58:58 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:31744 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752032AbYG1G66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 02:58:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=2B6gjl+aH0FDvoNWNvLi3RxdG+CRVAZMtzNtX3IgLglQZpiREoTm1756lgZLwyZ3/DQzWmtZqVvOopibksjr3GcrX2yTNlQOsNrssCKSK56G5CK1eSUcThREN3lYO5MxlqXGYQ1PV5nQm0vSfG2y28CLS4fh4zkOvGd4xtmmumY=  ;
X-YMail-OSG: kbCCOG4VM1lbGzdwXbkNJLY.WAdC8TYN3iTFhew8pl9V2pMufvyOjPYxE5MYpCRKk1NbkOLI74udNHc2M.rCCs272TDAT7HaTXr8bjocRckOz4MsMG.HXArC0o3IHFLlC8I-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [git pull] cpus4096 fixes
Date: Mon, 28 Jul 2008 16:58:48 +1000
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mike Travis <travis@sgi.com>
References: <20080727190601.GA764@elte.hu> <20080727200636.96da12d0.akpm@linux-foundation.org> <200807281634.43036.rusty@rustcorp.com.au>
In-Reply-To: <200807281634.43036.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807281658.48628.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 July 2008 16:34, Rusty Russell wrote:
> On Monday 28 July 2008 13:06:36 Andrew Morton wrote:
> > On Mon, 28 Jul 2008 10:42:12 +1000 Rusty Russell <rusty@rustcorp.com.au>
>
> wrote:
> > > The 4k CPU patches have been sliding in without review up until now.
> >
> > wot?
>
> This surprises you?  I stumbled across the cpumask_of_cpu() bug because I
> happened to want it for stop_machine and read the damned code.  But it lead
> me to the surrounding code, which is pretty questionable.  An arch-specific
> map, rather than depending on NR_CPUS?  Adding set_cpus_allowed_ptr()
> instead of changing set_cpus_allowed()?  Macros which declare things and
> may or may not do an allocation/free?  Finally a patch so horrifically ugly
> that it can't be ignored any more gets all the way to Linus.
>
> Overall, it seems like an attempt to sneak in gradual workarounds for
> cpumasks on the stack, rather than a coherent plan.  I understand the
> temptation to avoid an "are we prepared to pay this price for large
> NR_CPUS?" discussion, but we need it anyway.
>
> And that's what I call "review".

Well, I'm not talking about this case specifically, but lots of
people I see these days tend to "review" code without doing a lot
of high level critical thinking (is the overall design any good,
could it be better or completely different, are the tradeoffs
worthwhile etc).

Don't get me wrong, the lower level spot-the-bug and coding style
etc reviews are indespensible too...

Unfortunately the development process isn't exactly conducive to
that higher level kind of review... there are pros and cons to
this, it's not all bad...

