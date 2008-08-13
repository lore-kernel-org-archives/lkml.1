Return-Path: <linux-kernel-owner+w=401wt.eu-S1756567AbYHMSiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567AbYHMSiL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 14:38:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751748AbYHMSh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 14:37:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46920 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447AbYHMSh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 14:37:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matt Helsley <matthltc@us.ibm.com>
Subject: Re: [ProbableSpam]Re: [PATCH 2/5] Container Freezer: Make refrigerator always available
Date: Wed, 13 Aug 2008 16:31:48 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, Cedric Le Goater <clg@fr.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
References: <20080811235323.872291138@us.ibm.com> <200808122249.27553.rjw@sisk.pl> <1218589300.19008.135.camel@localhost.localdomain>
In-Reply-To: <1218589300.19008.135.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808131631.49889.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 13 of August 2008, Matt Helsley wrote:
> 
> On Tue, 2008-08-12 at 22:49 +0200, Rafael J. Wysocki wrote:
> > On Tuesday, 12 of August 2008, Matt Helsley wrote:
> > > Now that the TIF_FREEZE flag is available in all architectures,
> > > extract the refrigerator() and freeze_task() from kernel/power/process.c
> > > and make it available to all.
> > > 
> > > The refrigerator() can now be used in a control group subsystem
> > > implementing a control group freezer.
> > > 
> > > Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
> > > Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
> > > Acked-by: Serge E. Hallyn <serue@us.ibm.com>
> > > Tested-by: Matt Helsley <matthltc@us.ibm.com>
> > 
> > Your Signed-off-by implies your Tested-by (at least it should ;-)).
> 
> I wasn't sure that was always true so I added it just in case. I'll take
> it out of any future postings.
> 
> > > ---
> > [--snip--]
> > > Index: linux-2.6.27-rc1-mm1/kernel/power/Kconfig
> > > ===================================================================
> > > --- linux-2.6.27-rc1-mm1.orig/kernel/power/Kconfig
> > > +++ linux-2.6.27-rc1-mm1/kernel/power/Kconfig
> > > @@ -85,6 +85,9 @@ config PM_SLEEP
> > >  	depends on SUSPEND || HIBERNATION || XEN_SAVE_RESTORE
> > >  	default y
> > >  
> > > +config FREEZER
> > > +	def_bool PM_SLEEP
> > > +
> > 
> > I'd still prefer this to go into a Kconfig in the parent directory (ie. where
> > freezer.c and the Makefile building it are located).  Otherwise it's guaranteed
> > to confuse someone.
> 
> 	I'm thinking of making a patch moving the cgroups config variables into
> a kernel/Kconfig.cgroups file. Would moving config FREEZER to such a
> file be satisfactory? Paul, what do you think?

Well, in fact FREEZER is not directly dependent on cgroups, as it can also
depend on PM_SLEEP, even if cgroups are not used at all.

I would just add 'Kconfig.freezer' to 'kernel', put 'config FREEZER' in there
and make it depend on whatever needs it.  Of course,
'source "kernel/Kconfig.freezer"' would have to be added to top-level
Kconfigs for all architectures, but please note that only a few architectures
include 'kernel/power/Kconfig', so you'd have to change the top-level
Kconfigs anyway.

Alternatively, you can just add 'config FREEZER' directly to the top-level
Kconfigs.

Thanks,
Rafael
