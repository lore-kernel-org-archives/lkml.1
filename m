Return-Path: <linux-kernel-owner+w=401wt.eu-S1758075AbZABMoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075AbZABMoW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 07:44:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757507AbZABMoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 07:44:08 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:45297
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757123AbZABMoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 07:44:07 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Paul Mundt <lethal@linux-sh.org>
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
Date: Fri, 2 Jan 2009 06:44:00 -0600
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; x86_64; ; )
Cc: Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>
References: <200901020207.30359.rob@landley.net> <20090102095023.GA28078@linux-sh.org>
In-Reply-To: <20090102095023.GA28078@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901020644.01201.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 January 2009 03:50:23 Paul Mundt wrote:
> On Fri, Jan 02, 2009 at 02:07:28AM -0600, Rob Landley wrote:
> > The perl checkin for 2.6.25 was the camel's nose under the tent flap, and
> > since then two more instances of perl have shown up in the core kernel
> > build. This patch series removes the three required to build a basic
> > kernel for qemu for the targets I've tested (arm, mips, powerpc, sparc,
> > m68k, sh4, and of course x86 and x86-64), replacing them with shell
> > scripts.
>
> Misguided rhetoric aside, what does this actually accomplish? If folks
> add meaningful tools in to the kernel that require python, and it is
> generally regarded as being fairly ubiquitous, I can't imagine there
> being any substantiated objections against it.

I think bloat-o-meter is a marvelous tool, and I'm a big fan of python.  But I 
don't think you shouldn't have to run that to compile a kernel either, largely 
because not needing it for the first 17 years or so implied living without 
this requirement could be done, sustainably even.

There's a difference between a development workstation and a dedicated build 
system.  Requiring you to install X11 plus qt on the headless build server 
cranking out nightly snapshots in order to run the configure stage of the 
kernel build would be silly.  But this is not an argument for ripping out 
"make xconfig" from the kernel.

Spot the difference?

> Your main reasons against inclusion of perl seem to be that there is no
> realistic expectation for target systems that will be self-hosting will
> have perl included, or the inherent complexity in maintaining a coherent
> cross compiling environment.

I'm saying it's a major new environmental dependency that went in fairly 
recently and largely without comment, and it causes real world headaches for 
real people, of which I am only one.

If you don't think environmental dependencies are a problem, I welcome you to 
attempt to build open office.  (Even the gentoo guys gave up on that one and 
just started shipping a prebuilt binary.)

I think large amounts of complexity start with small amounts of complexity 
that grow.  Complexity is inevitable, but there should be a _reason_ for 
increases in it.

> Both of these things are issues with your
> own environment, and in no way are these representative of the embedded
> development community at large.
>
> Now with that out of the way, this entire series fundamentally fails to
> convert half of the perl scripts shipped with the kernel today, some that
> are required for build depending on Kconfig options, and others that are
> simply useful tools for self-hosted environments.

I didn't say the job was finished.  These are just the ones I've already 
personally hit, and thus A) needed to rewrite to build the kernel in my build 
environment, B) have a handy test case for.

> Simply converting a
> couple of scripts over you find objectionable is certainly fine if there
> is a real benefit in doing so, but this doesn't actually accomplish your
> goal of removing the perl dependency.

A) It's a start.

B) It works for me, and builds the .configs I've personally needed so far.

> Ignoring the compile-time dependencies that you overlooked, what you
> define as "development and debugging" scripts are still an integral part
> of the system, unless you are trying to argue that embedded developers
> have no interest in things like checkstack due to the trouble of trying
> to get perl built.

Coming up with new patches and modifying the source is a different use for 
source code than going "./configure; make; make install".  This is true for 
most open source software, I'd expect.

Or are you implying that eclipse or Emacs are such great IDEs that being able 
to build outside of a GUI isn't interesting?  The ability to build within an 
IDE should be allowed to preclude the ability to build without one?

> Until you can post a series that converts all of scripts/*.pl in its
> entirety, you have failed to address the fundamental reason why perl is
> used in the first place.

Never start anything unless you can finish it all in one go, eh?

Last I heard the kernel guys tend to frown on people who wander off in their 
own corner for a year and then dump a massive rewrite on them.  They seem to 
prefer the incremental "trail of breadcrumbs" approach.  Release early, 
release often, incorporate feedback, keep at it.

Or am I wrong?

> Trying to toss bizarre policy statements around
> regarding things you personally find objectionable without any coherent
> technical argument to the contrary is of no constructive use whatsoever.

Complexity is a cost, environmental dependencies are a form of complexity, if 
the benefit isn't worth the cost (or you can get the benefit without the cost) 
then you shouldn't pay the cost.

I was unaware this was a controversial attitude?

> The kernel is and always has been about using the right tool for the job,
> not a matter of dictating what tools you must use in order to accomplish
> a task you are interested in.

And yet despite "unifdef" being an existing tool, the kernel developers didn't 
require you to install it on your host, but instead built their own version 
from source.  (They didn't even require you to install a version of cpio on 
the host that understands -H newc, but instead built their own initramfs 
packer in C.)  More recently, they integrated dtc (the device tree compiler).

In each case, they made a balancing decision, and decided that integrating and 
maintaining a small C tool was better than having an environmental dependency.

> Common sense does apply here though, so
> this might be a more daunting task for some than others.

Apparently so.

I don't care if checkstack.pl is written in perl for the same reason I don't 
care if eclipse is written in java.  They're not build dependencies.

If I had to install gdb as a precondition of compiling the Linux kernel I'd 
think something was funny with that, which isn't saying I object to the 
existence of gdb or the ability to hook it up to kgdb or qemu or UML to poke 
at kernels.  It's two different categories.

It seems clear to _me_, anyway.  But it is coming up on 7am and I haven't 
gotten to bed yet, so take that for what it's worth...

Rob
