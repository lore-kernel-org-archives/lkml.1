Return-Path: <linux-kernel-owner+w=401wt.eu-S1756129AbXIYUkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129AbXIYUkl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 16:40:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751950AbXIYUke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 16:40:34 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:61215 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751750AbXIYUkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 16:40:33 -0400
Date: Tue, 25 Sep 2007 16:40:28 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 3/5] Add samples subdir
Message-ID: <20070925204028.GA16652@Krystal>
References: <20070925121145.262664884@polymtl.ca> <20070925121251.954162366@polymtl.ca> <20070925190036.GA14579@uranus.ravnborg.org> <20070925133234.cdd9edf1.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070925133234.cdd9edf1.randy.dunlap@oracle.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:40:15 up 57 days, 20:59,  5 users,  load average: 0.29, 0.30, 0.24
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Randy Dunlap (randy.dunlap@oracle.com) wrote:
> On Tue, 25 Sep 2007 21:00:36 +0200 Sam Ravnborg wrote:
> 
> Hi Sam,
> 
> Thanks for looking.  I was hoping that you would find time to
> look/comment on it.
> 
> > Hi Mathieu & Randy.
> > 
> > On Tue, Sep 25, 2007 at 08:11:48AM -0400, Mathieu Desnoyers wrote:
> > > From: Randy Dunlap <randy.dunlap@oracle.com>
> > > 
> > > Begin infrastructure for kernel code samples in the samples/ directory.
> > > Add its Kconfig and Kbuild files.
> > > Source its Kconfig file in all arch/ Kconfigs.
> > 
> > Sorry for not commenting on this before...
> > The samples directory contains sample code so it is wrong to actually
> > include it as part of the kernel IMHO.
> > We only want to keep the samples buildable and to do so
> > we can make a much simpler hack in the top-level Makefile.
> > Consider following patch:
> > 
> > @@ -760,6 +760,9 @@ vmlinux: $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) $(kallsyms.o) vmlinux.o
> >  ifdef CONFIG_HEADERS_CHECK
> >         $(Q)$(MAKE) -f $(srctree)/Makefile headers_check
> >  endif
> > +ifdef CONFIG_SAMPLES
> > +       $(Q)$(MAKE) $(build)=samples
> > +endif
> >         $(call vmlinux-modpost)
> >         $(call if_changed_rule,vmlinux__)
> >         $(Q)rm -f .old_version
> > 
> > 
> > With this we build the samples when CONFIG_SAMPLES are selected and
> > when the kernel is about to be linked.
> > 
> > 
> > As for the Kconfig file I am in favour of it but think a much more
> > natural place is to source it in lib/Kconfig.debug.
> > Then it will appear in "Kernel hacking" and the smaples
> > are used for kernel hacking and not for regular people
> > building their own kernel.
> > 
> > Sourcing samples/Kconfig from lib/Kconfig.debug will then
> > take effect for all archs so the result is a much simpler
> > Kconfig patch too.
> 
> These changes all sound good to me.
> 
> Mathieu, can you find time to do this or should I do it?
> 

I'll take care of it.

> ---
> ~Randy
> Phaedrus says that Quality is about caring.

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
