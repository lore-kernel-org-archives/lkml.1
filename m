Return-Path: <linux-kernel-owner+w=401wt.eu-S1754397AbZDZJNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397AbZDZJNQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 05:13:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbZDZJM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 05:12:59 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:38330 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbZDZJM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 05:12:58 -0400
Date: Sun, 26 Apr 2009 11:15:05 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Paul Mundt <lethal@linux-sh.org>, Tim Abbott <tabbott@MIT.EDU>,
       Linus Torvalds <torvalds@linux-foundation.org>,
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
       Am?rico Wang <xiyou.wangcong@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v3 1/3] Make section names compatible with -ffunction-sections -fdata-sections
Message-ID: <20090426091505.GB27809@uranus.ravnborg.org>
References: <alpine.DEB.1.10.0904221826180.24694@vinegar-pot.mit.edu> <1240519774-20307-1-git-send-email-tabbott@mit.edu> <20090424172358.GA21946@uranus.ravnborg.org> <alpine.DEB.1.10.0904251304120.7631@vinegar-pot.mit.edu> <20090426024221.GA7286@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090426024221.GA7286@linux-sh.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 26, 2009 at 11:42:21AM +0900, Paul Mundt wrote:
> On Sat, Apr 25, 2009 at 10:10:38PM -0400, Tim Abbott wrote:
> > On Fri, 24 Apr 2009, Sam Ravnborg wrote:
> > 
> > > This patch touches far too many files.
> > > We should try to work out a method so we are in better control
> > > of the section names, so renaming in the end is a simple patch
> > > touching only a few files.
> > 
> > OK, I'm now planning to implement this approach.
> > 
> > > > -.section .text.head, "ax"
> > > > +.section .text..head, "ax"
> > > 
> > > Use __HEAD (from include/linux/init.h)
> > > Same goes for all other uses of .text.head.
> > 
> > I notice that __HEAD uses .head.text, while some architectures use 
> > .text.head.  It looks like this is just an inconsistency across 
> > architectures that will be removed as a consequence of this cleanup work 
> > (no architecture uses both .head.text and .text.head).
> > 
> The use of .text.head is quite intentional. See
> f8657e1b55901e6c227094258d1fa3642fa242bd for starters. Most of the rest
> of the platforms that switched did so for section mismatch avoidance
> reasons, those that kept .head.text presumably did not hit these
> mismatches or simply didn't care.

This is a mess that Tim's patches should clean up.
i386 should use .head.text - this is the 'correct' name for the head section.

And modpost does not accept ".text.head" anymore - thats cleaned up some time ago.

	Sam

