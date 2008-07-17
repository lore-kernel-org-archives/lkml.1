Return-Path: <linux-kernel-owner+w=401wt.eu-S933119AbYGQV13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933119AbYGQV13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 17:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760494AbYGQV1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 17:27:17 -0400
Received: from isilmar.linta.de ([213.133.102.198]:43491 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757825AbYGQV1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 17:27:17 -0400
Date: Thu, 17 Jul 2008 23:27:15 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Jason Baron <jbaron@redhat.com>, Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, joe@perches.com,
       nick@nick-andrew.net, randy.dunlap@oracle.com
Subject: Re: [PATCH 6/7] dynamic debug v2 - convert cpufreq
Message-ID: <20080717212714.GA12617@isilmar.linta.de>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Jason Baron <jbaron@redhat.com>, Greg KH <greg@kroah.com>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	joe@perches.com, nick@nick-andrew.net, randy.dunlap@oracle.com
References: <20080715213613.GG23331@redhat.com> <20080715230731.GA15208@isilmar.linta.de> <20080717210531.GA13252@redhat.com> <20080717211531.GA16569@kroah.com> <20080715213613.GG23331@redhat.com> <20080715230731.GA15208@isilmar.linta.de> <20080717210531.GA13252@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080717211531.GA16569@kroah.com> <20080717210531.GA13252@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 02:15:31PM -0700, Greg KH wrote:
> On Thu, Jul 17, 2008 at 05:05:32PM -0400, Jason Baron wrote:
> > --- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> > +++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> > @@ -25,6 +25,7 @@
> >   * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >   */
> >  
> > +#include <linux/dynamic_debug_cpufreq.h>
> >  #include <linux/kernel.h>
> >  #include <linux/module.h>
> >  #include <linux/init.h>
> 
> kernel.h includes dynamic_debug.h right?  Then why not just put the
> _cpufreq.h stuff in the current cpufreq.h file(s)?

Seconded. Makes the cpufreq-related patch even smaller, for we won't have to
touch all drivers.

On Thu, Jul 17, 2008 at 05:05:32PM -0400, Jason Baron wrote:
> > > +#if defined(CONFIG_CPU_FREQ_DEBUG) || defined (CONFIG_DYNAMIC_PRINTK_DEBUG)
> > ...
> > > +#if defined(CONFIG_CPU_FREQ_DEBUG) || defined (CONFIG_DYNAMIC_PRINTK_DEBUG)
> > 
> > can't we just depend on thing on another?
> > 
> 
> We could make CONFIG_CPU_FREQ_DEBUG force CONFIG_DYNAMIC_PRINTK_DEBUG to be on.
> However, i'm trying to allow CONFIG_CPU_FREQ_DEBUG to be turned on without
> enabling CONFIG_DYNAMIC_PRINTK_DEBUG. That's consistent with how i'm trying to
> do this patch series. That is, individual subsystems can turn their respective
> debugging on without forcing on CONFIG_DYNAMIC_PRINTK_DEBUG.

Makes sense, and we can discuss depending one thing on another later on. 

Looking forward to seeing this infrastructure merged. I guess it will help a
lot.

Best,
	Dominik
