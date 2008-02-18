Return-Path: <linux-kernel-owner+w=401wt.eu-S1761468AbYBRUQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761468AbYBRUQ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 15:16:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761272AbYBRUQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 15:16:31 -0500
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:43342 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761260AbYBRUQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 15:16:28 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=VMQPXtGqZdSLccUJa7R6fZOuvNgr0c78Dl2pq8/V8Vf4hO8Xb2jkiD02zphb4o7s0NPNy1xldPcrqaxajqX2o5b7EjzWc1CBYxV/GCmKLSCzdSK+HUdl0KPsYr39uv+fyiCoYNAsiaQD7sFxyWEpn93VE8mdzNky1SQiuqRz3fI=  ;
X-YMail-OSG: Sk1_YNQVM1mFhKYxvi6tRiDUEEE0vkWrjpl0juLuEeVvLzGbUMWrYCne2XkLFRnrJozKk5ubJg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] suspend/resume self-test
Date: Mon, 18 Feb 2008 12:16:24 -0800
User-Agent: KMail/1.9.6
Cc: Pavel Machek <pavel@ucw.cz>, rjw@sisk.pl,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <20080130131748.GA3796@elf.ucw.cz> <200802180240.47510.david-b@pacbell.net> <20080218130914.GC17697@elte.hu>
In-Reply-To: <20080218130914.GC17697@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200802181216.25350.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 February 2008, Ingo Molnar wrote:
> 
> * David Brownell <david-b@pacbell.net> wrote:
> 
> > > >   - Includes a command line parameter, which needs work yet ... it
> > > >     currently turns this test off, but it should also let the target
> > > >     state be specified (and maybe even default to "no test").
> > 
> > I think "no test" should be the default; STR working sanely on x86 is 
> > unfortunately too much a surprise.  Someone more active in PM testing 
> > should update that.
> 
> All i'm asking for is to make the self-test easily accessible. Not for 
> it to blow up in the face of users who do not ask for it.

I'm all for that, but also I don't want to see it blow up regularly
in the face of people who just enable all the selftest options.  The
other tests have a much better expectation of working "by default".


> And, at least to me, there seems to be a rather apparent correlation 
> between "suspend/resume regressions caught as early as possible" and the 
> future, desired state of: "STR working sanely on x86" ;-)

Thing is, this will catch not just regressions ... but cases where
STR never worked in the first place.  Video problems, etc.  Also
various system startup races, as in the PCMCIA and MMC/SD/SDIO
cases I noted.
 

> You really seem to treat S2R suckiness as a fact of life, but it isnt.

Until it starts working on a given platform, it *IS* a fact of life.

Once it works, then it's fair to enter "no regressions" mode.  Despite
all the recent improvements, I think it's unwise to pretend that STR
works properly on most systems.


> Yes, it's a hard field for a number of reasons, but we could be doing _a 
> lot_ better. One of them would be this "notice s2r breakage when i 
> create or add the patch that breaks it" angle.

Right, and the best way to ensure that it's only *regressions* that
break things is to expect someone to have configured the kernel command
line appropriately (in grub or whatever).

Another way to achieve that is to include the test code based on one
config option, and change the test *mode* based on another one.  That
way a distro could include that in standard kernels with "no test" mode
as the default, but it would be easy to enable only for oneshot tests
or field troubleshooting ... while developers could turn on the more
dangerous "always test STR" (or standby, or hibernate) mode, if they
were helping to find and fix problems surfaced by such tests.

- Dave
