Return-Path: <linux-kernel-owner+w=401wt.eu-S1754113AbYHMBB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbYHMBB4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 21:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754130AbYHMBBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 21:01:45 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:56431 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079AbYHMBBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 21:01:44 -0400
Subject: Re: [ProbableSpam]Re: [PATCH 2/5] Container Freezer: Make
	refrigerator always available
From: Matt Helsley <matthltc@us.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, Cedric Le Goater <clg@fr.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
In-Reply-To: <200808122249.27553.rjw@sisk.pl>
References: <20080811235323.872291138@us.ibm.com>
	 <20080811235324.661871296@us.ibm.com>  <200808122249.27553.rjw@sisk.pl>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Tue, 12 Aug 2008 18:01:40 -0700
Message-Id: <1218589300.19008.135.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-08-12 at 22:49 +0200, Rafael J. Wysocki wrote:
> On Tuesday, 12 of August 2008, Matt Helsley wrote:
> > Now that the TIF_FREEZE flag is available in all architectures,
> > extract the refrigerator() and freeze_task() from kernel/power/process.c
> > and make it available to all.
> > 
> > The refrigerator() can now be used in a control group subsystem
> > implementing a control group freezer.
> > 
> > Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
> > Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
> > Acked-by: Serge E. Hallyn <serue@us.ibm.com>
> > Tested-by: Matt Helsley <matthltc@us.ibm.com>
> 
> Your Signed-off-by implies your Tested-by (at least it should ;-)).

I wasn't sure that was always true so I added it just in case. I'll take
it out of any future postings.

> > ---
> [--snip--]
> > Index: linux-2.6.27-rc1-mm1/kernel/power/Kconfig
> > ===================================================================
> > --- linux-2.6.27-rc1-mm1.orig/kernel/power/Kconfig
> > +++ linux-2.6.27-rc1-mm1/kernel/power/Kconfig
> > @@ -85,6 +85,9 @@ config PM_SLEEP
> >  	depends on SUSPEND || HIBERNATION || XEN_SAVE_RESTORE
> >  	default y
> >  
> > +config FREEZER
> > +	def_bool PM_SLEEP
> > +
> 
> I'd still prefer this to go into a Kconfig in the parent directory (ie. where
> freezer.c and the Makefile building it are located).  Otherwise it's guaranteed
> to confuse someone.

	I'm thinking of making a patch moving the cgroups config variables into
a kernel/Kconfig.cgroups file. Would moving config FREEZER to such a
file be satisfactory? Paul, what do you think?

Cheers,
	-Matt Helsley

