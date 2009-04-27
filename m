Return-Path: <linux-kernel-owner+w=401wt.eu-S1756384AbZD0HVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384AbZD0HVP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 03:21:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753410AbZD0HU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 03:20:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36332 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753271AbZD0HU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 03:20:57 -0400
Date: Mon, 27 Apr 2009 09:19:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Tim Abbott <tabbott@MIT.EDU>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Jeff Arnold <jbarnold@MIT.EDU>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, "Theodore Ts'o" <tytso@MIT.EDU>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Paul Mundt <lethal@linux-sh.org>,
       =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       Ralf Baechle <ralf@linux-mips.org>, Kyle McMartin <kyle@mcmartin.ca>,
       David Howells <dhowells@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 14/15] x86: convert to use __HEAD and HEAD_TEXT macros.
Message-ID: <20090427071902.GA6047@elte.hu>
References: <1240711870-30505-12-git-send-email-tabbott@mit.edu> <1240711870-30505-13-git-send-email-tabbott@mit.edu> <1240711870-30505-14-git-send-email-tabbott@mit.edu> <alpine.LFD.2.00.0904260934570.3101@localhost.localdomain> <alpine.LFD.2.00.0904260958190.3101@localhost.localdomain> <20090426183401.GA1622@uranus.ravnborg.org> <alpine.LFD.2.00.0904261146570.7331@localhost.localdomain> <20090426192317.GA2637@uranus.ravnborg.org> <20090427045910.GA11868@elte.hu> <20090427064216.GA6918@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090427064216.GA6918@uranus.ravnborg.org>
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> On Mon, Apr 27, 2009 at 06:59:10AM +0200, Ingo Molnar wrote:
> > 
> > * Sam Ravnborg <sam@ravnborg.org> wrote:
> > 
> > > > As mentioned, though, the much more interesting case would be 
> > > > the _real_ kernel vmlinux.lds.S file, which is a lot more 
> > > > complex and where the differences between 32-bit and 64-bit 
> > > > cases aren't totally trivial.
> > > 
> > > Agreed.
> > > 
> > > But I expect someone else to do so.
> > > When I am in unification mode I try to spend time on
> > > architectures with less people involved.
> > 
> > thanks for reconsidering - and i've applied your patch - thanks Sam.
> > 
> > Architectures with lots of people involved (hm, what a strange 
> > way to say 'x86' ;-) tend to be logistically more complex and 
> > there's an (understandably) stronger pushback against 
> > regressions - but that is also where unification is actually 
> > needed the most and where the ongoing costs of splintered code 
> > is the highest.
>
> Well - the effort done for sparc and m68k lately was also needed.
> 
> > Your kbuild patches are making quite a bit of difference so 
> > please dont hold back :)
>
> The good patches are the ones that benefits all architectures.

The good patches are the ones that increase the quality of the 
kernel and benefit people.

In terms of architecture code that means factoring out common code 
and stemming the spread of architecture-specific local hacks.

For details that are inherently per arch - obviously improving the 
more frequently used architectures helps more people, on average.

> Well - I can give the vmlinux_*.ds files a try.
> Did you apply the patch to an append only branch or may I recreate
> the patch?
> I noticed a few minor things that can be 'fixed' to bring the inital
> differences between 32 bit and 64 bit down.
> 
> But I can do these in a follow-up patch too.

Yeah, please do a follow-up patch - unless the first patch is 
outright wrong. I've got a fair amount of test-time in the first 
patch already - and Linus's is on top of it so it would mean a 
rebase of both.

	Ingo
