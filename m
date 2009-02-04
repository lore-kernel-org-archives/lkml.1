Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbZBDIf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbZBDIf6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 03:35:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbZBDIfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 03:35:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:38381 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568AbZBDIfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 03:35:33 -0500
Subject: Re: usr/include/linux/soundcard.h warnings for 'make headers_check'
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Arnd Bergmann <arnd@arndb.de>, Sam Ravnborg <sam@ravnborg.org>,
       alsa-devel@alsa-project.org, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <s5hhc3ak8ns.wl%tiwai@suse.de>
References: <1232465902.3088.31.camel@localhost.localdomain>
	 <s5h7i4psepm.wl%tiwai@suse.de> <20090121054138.GA26551@uranus.ravnborg.org>
	 <200902032127.24526.arnd@arndb.de>
	 <1233720252.3595.5.camel@localhost.localdomain>
	 <s5hhc3ak8ns.wl%tiwai@suse.de>
Content-Type: text/plain
Date: Wed, 04 Feb 2009 14:04:54 +0530
Message-Id: <1233736494.3198.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-04 at 07:39 +0100, Takashi Iwai wrote:
> At Wed, 04 Feb 2009 09:34:12 +0530,
> Jaswinder Singh Rajput wrote:
> > 
> > On Tue, 2009-02-03 at 21:27 +0100, Arnd Bergmann wrote:
> > > On Wednesday 21 January 2009, Sam Ravnborg wrote:
> > > > 
> > > > > No, these are declarations for OSS-lib.
> > > > > It doesn't belong to kernel, but it's better to keep it for
> > > > > compatibility in some way.
> > > > 
> > > > But not in the kernel for sure.
> > > > I just checked and for example: OSS_init is not used anywhere in the kernel.
> > > > The kernel headers are not a "dump all your stuff" ground anymore.
> > > > 
> > > > So I encourage you to find a better home for the user space library definitons.
> > > > We can let the definiton stay for a while - but eventually they have to
> > > > be dropped from the kernel.
> > > 
> > > The last free version of OSSlib that matches this header is from ~1997, and
> > > no current distro appears to be shipping it. All new OSSlib versions (the
> > > oldest I found was from ~2003) contain in their documentation:
> > > 
> > > "Older versions of some OSS include files are distributed
> > >  with various operating systems. There is no danger in
> > >  using them but applications written for more recent OSS
> > >  versions will not compile with older header files.
> > > 
> > >  The latest versions of these include files (such as
> > >  soundcard.h) are distributed in ../include/sys. Use
> > >  the -I/usr/lib/oss/include switch when compiling
> > >  programs. Alternatively copy these files to /usr/include/sys
> > >  so that they replace the original ones."
> > > 
> > > I think it's safe enough to assume that everyone that builds against
> > > OSSlib by now also has the correct version of the header installed.
> > > Consequently, we should just drop the #ifndef __KERNEL__ section
> > > of soundcard.h (all the macros in there depend on the extern
> > > declarations), and maybe add an
> > > 
> > > #ifdef OSSLIB
> > > #error need to use <sys/soundcard.h> from libOSSlib
> > > #endif
> > > 
> > 
> > sys/soundcard.h is also pointing to linux/soundcard.h, we need to move
> > all this stuff to sys/soundcard.h.
> 
> All which stuff?
> If you are referring to OSS-lib stuff in soundcard.h, then I'm for
> it.
> 

We need to fix things in such a way that we can replace:
#if (!defined(__KERNEL__) && !defined(KERNEL) && !defined(INKERNEL) && !defined(_KERNEL)) || defined(USE_SEQ_MACROS)
with
#ifdef __KERNEL__
and only keep those things in this file which we need in kernel and move
userspace declarations which are not required for kernel to
sys/soundcard.h


> Also giving an error with an ifdef OSSLIB like Arnd suggested would be
> nice, too.  But maybe we need one more ifdef such as
> 
> #ifdef OSSLIB
> #ifndef _SYS_SOUNDCARD_H
> #error ...
> #endif
> #endif
> 

hmm, so you want to confirm that we only come through sys/soundcard.h
for OSSLIB

Thanks,
--
JSR

