Return-Path: <linux-kernel-owner+w=401wt.eu-S1757699AbYESITU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757699AbYESITU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 04:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbYESITN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 04:19:13 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:48129 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839AbYESITL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 04:19:11 -0400
Date: Mon, 19 May 2008 10:19:49 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Beulich <jbeulich@novell.com>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] move link of vmlinux from Makefile to a script
Message-ID: <20080519081949.GA18279@uranus.ravnborg.org>
References: <482DCD89.76E4.0078.0@novell.com> <20080517125204.GA19741@uranus.ravnborg.org> <20080518185219.GA777@uranus.ravnborg.org> <48314B95.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48314B95.76E4.0078.0@novell.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 08:42:45AM +0100, Jan Beulich wrote:
> >>> Sam Ravnborg <sam@ravnborg.org> 18.05.08 20:52 >>>
> >> 
> >> I have several times been tempted to move it all to a shell script.
> >> What has prevented me to do so has only been:
> >> 1) that um has some subtle requirement and therefore redefine the
> >>    vmlinux link
> >> 2) that last time I reworked this stuff Andrew could not boot one
> >>    of his systems and I never figured out why
> >> 3) lack of time..
> >> 
> >> But if someone comes up with a patch that moves all this stuff out
> >> of the top-level Makefile I am all open for it.
> >
> >I gave it a quick try. This is first try and comments are welcome.
> >It does not address the um issue - but I think that is doable
> >with an additional enviroment variable.
> >
> >The conditionals around KALLSYMS may be simplified - I just did
> >not try to do so.
> 
> What I fail to see is how the multi-stage (necessary even without
> CONFIG_KALLSYMS_EXTRA_PASS) kallsyms linking is now happening.

I will recheck my script tonight or tomorrow.
But the principle is like this:

-> Link vmlinux.o
-> modpost vmlinux.o
-> link vmlinux if not KALLSYMS

-> link .tmp_vmlinux_kall if KALLSYMS
-> link vmlinux with new kernel symbols if not KALLSYM_EXTRA_PASS

-> link .tml_vmlinux_extra_pass if KALLSYM_EXTRA_PASS
-> link vmlinux with new kernel symbols
-> check that System.map are equal in the above two cases

> 
> >What I like with the patch below is that it is 100 times more
> >readable than the Makefile stuff.
> 
> Fully agree, and hence I'd favor this for .27 over the simple version
> handling fix (which I'd hope to see in .26, and maybe even .25.x).
Does it fix anything or is it just a clean-up?
I see it as a cleanup only and thus not -rc material.

> >The drawback are that we either link or not - we cannot restart
> >from the middle of the link. But that it not a real issue.
> >
> >This patch futhermore remove a debug target to assist in
> >kallysms issues - I have not seen it used for a long time
> >now.
> 
> Is this what I referred to above? If so, I don't think these are just
> debug targets...
Nope - we can create maps of kernel symbols to assist when we
have kernel symbols bugs (when EXTRA_PASS detect inconsistency).
When I added this commit I told Keith Ownes that I planned to
remove that again when we no longer saw KALLSYMS issues where
we needed this to debug it.
And I have not seen such reports for a long time now.

> 
> >And I was also considering removing the extra kallsyms
> >pass as I dunnot how usefull it is and for an allyesconfig
> >build it take too much time.
> 
> I'd vote for it, but would of course think that whoever introduced it
> should voice his opinion.
> 
> >This patch includes your version simplifactions too allthough
> >that is not obvious.
> 
> Thanks, Jan
>

I will post an updated patch later this week.

	Sam
 
