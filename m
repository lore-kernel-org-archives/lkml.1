Return-Path: <linux-kernel-owner+w=401wt.eu-S1755955AbXL2CWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955AbXL2CWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 21:22:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754159AbXL2CWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 21:22:40 -0500
Received: from mx2.suse.de ([195.135.220.15]:57097 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754155AbXL2CWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 21:22:40 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [PATCH] x86: unify x86 Makefile(s)
Date: Sat, 29 Dec 2007 03:14:23 +0100
User-Agent: KMail/1.9.6
Cc: Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
References: <20071228212341.GA6939@uranus.ravnborg.org> <20071228221324.GA9105@does.not.exist>
In-Reply-To: <20071228221324.GA9105@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712290314.23567.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 December 2007 23:13:24 Adrian Bunk wrote:
> On Fri, Dec 28, 2007 at 10:23:41PM +0100, Sam Ravnborg wrote:
> >...
> > Noteworthy remarks on the unification:
> >...
> > - -funit-at-a-time should be easy to unify but it looks like we have a bug
> >   in 32 bit. We only enable -funit-at-a-time for gcc less than 0400 if they
> >   support it
> 
> No, we _dis_able it on 32bit if a gcc < 4.0 supports it.
> 
> > (and I recall it is a gcc 4.00 feature). [-lt -> -gt]
> >...
> 
> unit-at-a-time was introduced in upstream gcc 3.4 and backported to some 
> popular 3.3 x86_64 branch.
> 
> i386 and x86_64 go in exactly opposite directions regarding when to use 
> unit-at-a-time, but that was intentional and we should keep it that way.

i386 disabled it because there were claims that it increased stack size
too much, but I haven't seen any real evidence for that. That is why I never
added it to x86-64. On the other hand it tends to shrink text size considerably.

I think it should be reevaluated and enabled by default on i386 again.

BTW there is a patch pending for gcc 4.3+ that prevents optimizations
that increase stack size unduly. Not sure it has been added there yet,
but that was the right fix for these problems anyways.

-Andi


