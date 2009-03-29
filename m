Return-Path: <linux-kernel-owner+w=401wt.eu-S1754556AbZC2KSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbZC2KSc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 06:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753987AbZC2KSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 06:18:23 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:18584 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbZC2KSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 06:18:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xFWN0a2Ox3Zu2JygxRstu+8kjSarGyNvRX4SxtnIYYkl9vWIPeQsclS5SBFzu2kfe8
         Hio3LfU8JGLBItx2sEGdx8QLAyjiPud1T1D/pAsAYkA9QZms3vSAaiD3NfKhEdnf2EhS
         PGajsXjs+PvdBmLSQkXAjvLcCtV3d8w/rEays=
Date: Sun, 29 Mar 2009 14:25:48 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip] x86: include inverse Xmas tree patches
Message-ID: <20090329102548.GA3014@x200.localdomain>
References: <1238251730.2526.2.camel@ht.satnam> <20090328150746.GA3268@x200.localdomain> <20090328190350.GA30214@uranus.ravnborg.org> <49CEA3CD.105@kernel.org> <alpine.LFD.2.00.0903290025280.3397@localhost.localdomain> <20090328233438.GA4957@elte.hu> <alpine.LFD.2.00.0903290035390.3397@localhost.localdomain> <20090329000026.GA27015@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090329000026.GA27015@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 29, 2009 at 01:00:26AM +0100, Ingo Molnar wrote:
> 
> * Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > On Sun, 29 Mar 2009, Ingo Molnar wrote:
> > > * Thomas Gleixner <tglx@linutronix.de> wrote:
> > > 
> > > > > Personally I'd prefer alphabetic order, sorting based on length 
> > > > > isn't a complete ordering.  Nearly all editors can sort 
> > > > > alphabetically at the push of a key.
> > > > 
> > > > I'd prefer if somebody would sit down and write a tool to analyse 
> > > > the include hell instead of manually shuffling crap around to 
> > > > avoid trivial merge conflicts. I have cleaned up enough stuff in 
> > > > the x86 merger myself where I was able to cut the number of 
> > > > includes at least in half just by staring at the gcc intermediate 
> > > > files. We could do better and automate the analysis so we get down 
> > > > to a handful of includes instead of including the world and more.
> > > 
> > > I do not disagree with include file cleanups (we've done many of 
> > > them in this cycle and in previous cycles), but note that the 
> > > reduction in include files at the top of .c files actually increases 
> > > the chance of patch conflicts: when a new include file is added by 
> > > two patches to the same .c file.
> > 
> > Those conflicts are trivial and if we have a mechanism to anlyse 
> > include dependencies then we can avoid such conflicts often at 
> > all.
> 
> Yeah, i agree that least 50% of the existing #include's are not 
> needed.
> 
> That's not the point though. When two new files both append to the
> #include file section, they'll clash. Those _new_ includes tend to 
> be justified - people dont add #includes needlessly - it's years 
> long bitrot that causes #includes to bloat up slowly.
> 
> > Go through some of the include madness and watch the compiler 
> > reading the same header file ten times for a single source file 
> > compile.

Care to read strace(1) output? Include file is not even opened second
time.

[reads strace(1) output himself]

Correction!

Except, e. g., <asm/atomic.h> because i386/x86_64 unification dropped
ifndef guards in the right place and added them in the wrong one.

> Yes, we need both efforts. That section needs to look professional 
> (unordered lines look amateurishly random, arbitrary and confusing), 
> and it needs to be minimalized as well.

These are #include directives, how else should they look like.
As for confusing, as if you're looking for the first time at C code.

> And the xmas-tree helps the minimizing effort - as it trivially 
> eliminates duplicate #includes (which do happen frequently as well), 

yes, 5-10-20 for the whole tree per release and people periodically
removing them regardless of -tip, Xmas and so on.

> and they eliminate related includes as well because they get moved 
> together and get noticed.

I'll answer on this later.

> Most importantly, such code needs to look like as if someone 
> actually cared about it.

Reminder, this is include directives, not real code.

> If code looks tidy, people assume that it's 
> supposed to be perfect, and will notice and fix more subtle 
> imperfections in it. If code looks totally messy on the other hand, 
> _nobody_ will care because it's visibly broken. So these changes are 
> a small step forward.

People probably forgot the real problem with includes and start
inventing new non-problems with all the consequences.



So here is my countersuggestion for small and useful improvements:

1. Plug ifndef guargs back on x86.
   Check with strace(1) for past behaviour re non-opened includes.
   Remove current ifdef guards (need much more thinking for consequences)

2. Do #1 for other arches which exercised similar transformation
   (sparc/sparc64?)

3. For headers with small and let's say bounded area like <asm/unistd.h>,
   go check for every file including them and remove it if header genuinely
   unneeded.

  In case of <asm/unistd.h> this would check for copy_from_user/copy_to_user,
  put_user/get_user, clear_user and not much more.

This will reduce compile time _and_ size of DEBUG_INFO=y kernels.
