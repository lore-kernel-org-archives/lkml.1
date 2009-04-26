Return-Path: <linux-kernel-owner+w=401wt.eu-S1755730AbZDZTM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730AbZDZTM7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 15:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753281AbZDZTMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 15:12:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41617 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753394AbZDZTMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 15:12:49 -0400
Date: Sun, 26 Apr 2009 11:56:44 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Sam Ravnborg <sam@ravnborg.org>
cc: Tim Abbott <tabbott@MIT.EDU>,
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
       =?ISO-8859-15?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Ralf Baechle <ralf@linux-mips.org>, Kyle McMartin <kyle@mcmartin.ca>,
       David Howells <dhowells@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 14/15] x86: convert to use __HEAD and HEAD_TEXT macros.
In-Reply-To: <20090426183401.GA1622@uranus.ravnborg.org>
Message-ID: <alpine.LFD.2.00.0904261146570.7331@localhost.localdomain>
References: <1240711870-30505-7-git-send-email-tabbott@mit.edu> <1240711870-30505-8-git-send-email-tabbott@mit.edu> <1240711870-30505-9-git-send-email-tabbott@mit.edu> <1240711870-30505-10-git-send-email-tabbott@mit.edu> <1240711870-30505-11-git-send-email-tabbott@mit.edu>
 <1240711870-30505-12-git-send-email-tabbott@mit.edu> <1240711870-30505-13-git-send-email-tabbott@mit.edu> <1240711870-30505-14-git-send-email-tabbott@mit.edu> <alpine.LFD.2.00.0904260934570.3101@localhost.localdomain> <alpine.LFD.2.00.0904260958190.3101@localhost.localdomain>
 <20090426183401.GA1622@uranus.ravnborg.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 26 Apr 2009, Sam Ravnborg wrote:

> On Sun, Apr 26, 2009 at 10:12:47AM -0700, Linus Torvalds wrote:
> > 
> > 
> > On Sun, 26 Apr 2009, Linus Torvalds wrote:
> > > 
> > > Btw, this one really needs to unify the two lds files first. Look at 
> > > 
> > > 	diff -u arch/x86/boot/compressed/vmlinux_*.lds
> > > 
> > > output and realize that they're basially exctly the same except for 
> > > trivial naming differences, and the fact that the64-bit version hs a 
> > > "pgtable" thing.
> > > 
> > > So this really needs to be done by first unifying the thing so that there 
> > > is _one_ arch/x86/boot/compressed/vmlinux.lds.S file with a preprocessor 
> > > that takes care of the trivial differences [..]
> > 
> > Something like this?
> 
> Looks good/correct.
> Acked-by: Sam Ravnborg <sam@ravnborg.org>
> 
> You should add your s-o-b if you expect Ingo to pick it up.

Sure. I don't tend to add SOB lines for stuff that I'd not be ready to 
commit, but with some testing and other people looking at it, I think it's 
good to go.

	Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

As mentioned, though, the much more interesting case would be the _real_ 
kernel vmlinux.lds.S file, which is a lot more complex and where the 
differences between 32-bit and 64-bit cases aren't totally trivial.

Looking at 

	diff -u arch/x86/kernel/vmlinux_*.lds.S | less -S

output, many of them are just whitespace, and others are trivial and 
meaningless (comments in one, not the other, placement of alignment etc, 
different ordering of sections like "parainstructions"). Yet others seem 
to be things that we _could_ do in general, but that don't matter on one 
architecture or other (x86-64 has ".eh_frame" in the DISCARD section, i386 
apparently doesn't ever generate them, we could just use the x86-64 
version).

		Linus
