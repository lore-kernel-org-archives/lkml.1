Return-Path: <linux-kernel-owner+w=401wt.eu-S1753117AbZD0DtD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117AbZD0DtD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 23:49:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbZD0Dsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 23:48:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35607 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675AbZD0Dsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 23:48:53 -0400
Date: Mon, 27 Apr 2009 05:47:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Tim Abbott <tabbott@MIT.EDU>,
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
Message-ID: <20090427034721.GC10087@elte.hu>
References: <1240711870-30505-9-git-send-email-tabbott@mit.edu> <1240711870-30505-10-git-send-email-tabbott@mit.edu> <1240711870-30505-11-git-send-email-tabbott@mit.edu> <1240711870-30505-12-git-send-email-tabbott@mit.edu> <1240711870-30505-13-git-send-email-tabbott@mit.edu> <1240711870-30505-14-git-send-email-tabbott@mit.edu> <alpine.LFD.2.00.0904260934570.3101@localhost.localdomain> <alpine.LFD.2.00.0904260958190.3101@localhost.localdomain> <20090426183401.GA1622@uranus.ravnborg.org> <alpine.LFD.2.00.0904261146570.7331@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0904261146570.7331@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sun, 26 Apr 2009, Sam Ravnborg wrote:
> 
> > On Sun, Apr 26, 2009 at 10:12:47AM -0700, Linus Torvalds wrote:
> > > 
> > > 
> > > On Sun, 26 Apr 2009, Linus Torvalds wrote:
> > > > 
> > > > Btw, this one really needs to unify the two lds files first. Look at 
> > > > 
> > > > 	diff -u arch/x86/boot/compressed/vmlinux_*.lds
> > > > 
> > > > output and realize that they're basially exctly the same except for 
> > > > trivial naming differences, and the fact that the64-bit version hs a 
> > > > "pgtable" thing.
> > > > 
> > > > So this really needs to be done by first unifying the thing so that there 
> > > > is _one_ arch/x86/boot/compressed/vmlinux.lds.S file with a preprocessor 
> > > > that takes care of the trivial differences [..]
> > > 
> > > Something like this?
> > 
> > Looks good/correct.
> > Acked-by: Sam Ravnborg <sam@ravnborg.org>
> > 
> > You should add your s-o-b if you expect Ingo to pick it up.
> 
> Sure. I don't tend to add SOB lines for stuff that I'd not be 
> ready to commit, but with some testing and other people looking at 
> it, I think it's good to go.
> 
> 	Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Thanks, applied to tip:x86/kbuild. I'll do some more testing of it 
before pushing it out.

> As mentioned, though, the much more interesting case would be the 
> _real_ kernel vmlinux.lds.S file, which is a lot more complex and 
> where the differences between 32-bit and 64-bit cases aren't 
> totally trivial.
> 
> Looking at 
> 
> 	diff -u arch/x86/kernel/vmlinux_*.lds.S | less -S
> 
> output, many of them are just whitespace, and others are trivial 
> and meaningless (comments in one, not the other, placement of 
> alignment etc, different ordering of sections like 
> "parainstructions"). Yet others seem to be things that we _could_ 
> do in general, but that don't matter on one architecture or other 
> (x86-64 has ".eh_frame" in the DISCARD section, i386 apparently 
> doesn't ever generate them, we could just use the x86-64 version).

We generally do these by separating the unification into at least 
2-3 distinct steps - a mechanic, low-risk cleanup first, preparatory 
changes to bring the two files in sync second, and mechanic 
unification as the third and final step.

That way any bugs are easily bisectable to a reasonably sized (and 
reasonably risky) sub-patch. Review also gets much easier.

I've yet to see a non-trivial Makefile unification in arch/x86 that 
does not regress :-) They concentrate a lot of quirks and implicit 
dependencies and small but significant tricks. [usually we catch the 
bugs early on though - but even at an early stage it's good to have 
a reasonable splitup.]

	Ingo
