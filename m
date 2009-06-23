Return-Path: <linux-kernel-owner+w=401wt.eu-S1751702AbZFWEbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702AbZFWEbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 00:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750745AbZFWEb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 00:31:28 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:49854 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbZFWEb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 00:31:27 -0400
Date: Tue, 23 Jun 2009 10:00:58 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, poornima nayak <mpnayak@linux.vnet.ibm.com>,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Subject: Re: [BUG] timer_migration interface accepts any number as input in
	2.6.30-git9
Message-ID: <20090623043058.GA3249@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <1245229936.3345.67.camel@localhost.localdomain> <20090617102126.GA28647@linux.vnet.ibm.com> <1245669728.4368.1.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1245669728.4368.1.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* poornima nayak <mpnayak@linux.vnet.ibm.com> [2009-06-22 16:52:08]:

> Hi Arun, 
> 
> Patch given by you fixes the reported bug.
> 
> Regds
> Poornima

Hi Ingo,

Can you please include this minor interface bug fix for timer
migration?

thanks,

Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
Reported-by: Poornima Nayak <mpnayak@linux.vnet.ibm.com>
Tested-by: Poornima Nayak <mpnayak@linux.vnet.ibm.com>
---
 kernel/sysctl.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux.trees.git/kernel/sysctl.c
===================================================================
--- linux.trees.git.orig/kernel/sysctl.c
+++ linux.trees.git/kernel/sysctl.c
@@ -335,7 +335,10 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_timer_migration,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &zero,
+		.extra2		= &one,
 	},
 #endif
 	{


> On Wed, 2009-06-17 at 15:51 +0530, Arun R Bharadwaj wrote:
> > * poornima nayak <mpnayak@linux.vnet.ibm.com> [2009-06-17 14:42:16]:
> > 
> > > Hi
> > > 
> > > Timer migration interface /proc/sys/kernel/timer_migration in
> > > 2.6.30-git9 accepts any numerical value as input.
> > > Steps to reproduce 
> > > 1. echo -6666666 > /proc/sys/kernel/timer_migration
> > > 2. cat /proc/sys/kernel/timer_migration
> > > -6666666
> > > 
> > > 1. echo 44444444444444444444444444444444444444444444444444444444444 > /proc/sys/kernel/timer_migration
> > > 2. cat /proc/sys/kernel/timer_migration
> > > -1357789412
> > > 
> > > Expected behavior: Should 'echo: write error: Invalid argument' while
> > > setting any value other then 0 & 1
> > > 
> > > Regards
> > > Poornima
> > > 
> > 
> > Hi Poornima,
> > 
> > Thanks for reporting the bug.
> > Hope this patch removes the bug.
> > The patch is based against the latest -tip/master.
> > 
> > --arun
> > 
> > 
> > Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
> > ---
> >  kernel/sysctl.c |    5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > Index: linux.trees.git/kernel/sysctl.c
> > ===================================================================
> > --- linux.trees.git.orig/kernel/sysctl.c
> > +++ linux.trees.git/kernel/sysctl.c
> > @@ -335,7 +335,10 @@ static struct ctl_table kern_table[] = {
> >  		.data		= &sysctl_timer_migration,
> >  		.maxlen		= sizeof(unsigned int),
> >  		.mode		= 0644,
> > -		.proc_handler	= &proc_dointvec,
> > +		.proc_handler	= &proc_dointvec_minmax,
> > +		.strategy	= &sysctl_intvec,
> > +		.extra1		= &zero,
> > +		.extra2		= &one,
> >  	},
> >  #endif
> >  	{
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
