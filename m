Return-Path: <linux-kernel-owner+w=401wt.eu-S1756814AbXL2JxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814AbXL2JxS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 04:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753810AbXL2JxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 04:53:08 -0500
Received: from smtp5.pp.htv.fi ([213.243.153.39]:40731 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753246AbXL2JxH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 04:53:07 -0500
Date: Sat, 29 Dec 2007 11:52:53 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: unify x86 Makefile(s)
Message-ID: <20071229095253.GC27360@does.not.exist>
References: <20071228212341.GA6939@uranus.ravnborg.org> <20071228221324.GA9105@does.not.exist> <20071229093904.GA17390@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071229093904.GA17390@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 29, 2007 at 10:39:04AM +0100, Sam Ravnborg wrote:
> On Sat, Dec 29, 2007 at 12:13:24AM +0200, Adrian Bunk wrote:
> > On Fri, Dec 28, 2007 at 10:23:41PM +0100, Sam Ravnborg wrote:
> > >...
> > > Noteworthy remarks on the unification:
> > >...
> > > - -funit-at-a-time should be easy to unify but it looks like we have a bug
> > >   in 32 bit. We only enable -funit-at-a-time for gcc less than 0400 if they
> > >   support it
> > 
> > No, we _dis_able it on 32bit if a gcc < 4.0 supports it.
> I have:
> $ gcc --version
> gcc (GCC) 4.1.2 20070925 (Red Hat 4.1.2-33)
> 
> And with the current code in arch/x86/Makefile_32 I do not
> have -funit-at-a-time.
>...

You do not have this option, but you do not need it since it's enabled 
with -O in all gcc versions that support it except for some vendor 
backports to gcc 3.3.

>...
> This is the relevant snippet from the Makefile:
> KBUILD_CFLAGS += $(shell if [ $(call cc-version) -lt 0400 ] ; then echo $(call cc-option,-fno-unit-at-a-time); fi ;)
> 
> It reads:
> If gcc version is less than 4.00 then enable -funit-at-a-time only for gcc that supports it.
> -funit-at-a-time is NOT enabled for gcc >= 4.00

It is not _explicitely_ enabled for gcc >= 4.0 since it's anyway enabled.

> So it will enable -funit-at-a-time for gcc 3.4 as it is now.
> Which was what we wanted to avoid..
> So I see no reason not to enable it uncondintionally (if gcc supports it) as we have
> used it for 3.4 for as long as we have introduced -funit-at-a-time.

We have never used it with gcc 3.4 on i386.

> 	Sam

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

