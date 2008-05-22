Return-Path: <linux-kernel-owner+w=401wt.eu-S1756857AbYEVRRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857AbYEVRRm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 13:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753925AbYEVRRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 13:17:34 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:51127 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753773AbYEVRRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 13:17:33 -0400
Date: Thu, 22 May 2008 19:18:11 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jeff Dike <jdike@addtoit.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Paul Mackerras <paulus@samba.org>, Takashi Iwai <tiwai@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Moving include/asm-* [was: Re: Moving sound/* to drivers/ ?]
Message-ID: <20080522171811.GA22923@uranus.ravnborg.org>
References: <s5hzlqjz74d.wl%tiwai@suse.de> <alpine.LFD.1.10.0805211431370.3081@woody.linux-foundation.org> <18484.44691.477859.334222@cargo.ozlabs.ibm.com> <alpine.LFD.1.10.0805211635040.3081@woody.linux-foundation.org> <20080522005657.GU28946@ZenIV.linux.org.uk> <alpine.LFD.1.10.0805211818550.3081@woody.linux-foundation.org> <1211419419.6908.12.camel@brick> <alpine.LFD.1.10.0805211827010.3081@woody.linux-foundation.org> <20080522042059.GA17173@c2.user-mode-linux.org> <20080522052607.GY28946@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080522052607.GY28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 06:26:07AM +0100, Al Viro wrote:
> On Thu, May 22, 2008 at 12:20:59AM -0400, Jeff Dike wrote:
> > On Wed, May 21, 2008 at 06:29:43PM -0700, Linus Torvalds wrote:
> > > > 
> > > > What about say, sparc64 that has a lot of #include <asm-sparc/foo.h>
> > > 
> > > Ahh, I didn't realize people did that.
> > > 
> > > I assume (but am too lazy to check) that UML probably does something 
> > > similar for its arch-specific stuff.
> > 
> > Not quite - there's the include/asm-um/arch link, which points to
> > ../asm-foo and a bunch of #include <asm/arch/foo.h>.  Same idea though.
> 
> It's a bit worse, though - there is target-dependent stuff in arch/um/include
> *and* in include/asm-um; the latter is done in a very painful way - see
> include/asm-um/module-i386.h and include/asm-um/module-x86_64.h, etc. and
> logics that creates a symlink for each of those.
> 
> Is there any reason why module.h is not simply
> 
> #include <sysdep/module.h>
> 
> with these suckers sitting in arch/um/include/sysdep-{i386,x86_64}/ resp.?
If you create a structure along the following lines you can drop
the symlinks:

arch/um/include/{i386,x86_64}/sysdep/
The cost is a directory extra - but I assume we will find
more that fits the {i386,x86_64} folders

And then we just change KBUILD_CFLAGS -I ... depending on target.
All the dependency checks than "just works" and if arch changes
then all the proper files will get rebuild.

	Sam
