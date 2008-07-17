Return-Path: <linux-kernel-owner+w=401wt.eu-S1761089AbYGQWUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761089AbYGQWUg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 18:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757828AbYGQWU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 18:20:27 -0400
Received: from isilmar.linta.de ([213.133.102.198]:52823 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755363AbYGQWU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 18:20:26 -0400
Date: Fri, 18 Jul 2008 00:20:24 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Jason Baron <jbaron@redhat.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, joe@perches.com, nick@nick-andrew.net,
       randy.dunlap@oracle.com
Subject: Re: [PATCH 6/7] dynamic debug v2 - convert cpufreq
Message-ID: <20080717222024.GA21960@isilmar.linta.de>
Mail-Followup-To: Dominik Brodowski <linux@dominikbrodowski.net>,
	Jason Baron <jbaron@redhat.com>, Greg KH <greg@kroah.com>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	joe@perches.com, nick@nick-andrew.net, randy.dunlap@oracle.com
References: <20080715213613.GG23331@redhat.com> <20080715230731.GA15208@isilmar.linta.de> <20080717210531.GA13252@redhat.com> <20080717211531.GA16569@kroah.com> <20080717214651.GC13252@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080717214651.GC13252@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 05:46:51PM -0400, Jason Baron wrote:
> Then why not just put the
> > _cpufreq.h stuff in the current cpufreq.h file(s)?
> > 
> 
> 1) cpufreq.h is included by other subsystems, and thus those other subsystems
> potentially have the wrong debugging information.

...

> If we could pull the subsystem specific header in dynamic_printk.h for each 
> subsytem that would do the trick and be really clean, but i'm not sure of an
> easy way to do that...

<within all cpufreq drivers>
#define DYNAMIC_DEBUG_CPU_FREQ 1

<dynamic_printk.h>
#ifdef DYNAMIC_DEBUG_CPU_FREQ
#define DYNAMIC_DEBUG_NUM_FLAGS "3"
...
#else
...
...
#endif


or -- even better -- could we determine the definition of
DYNAMIC_DEBUG_CPU_FREQ on the fly? It needs to be set to true for exactly all
"modules" which contain a call to cpufreq_debug_printk()...

> 2) For the case where CONFIG_CPU_FREQ_DEBUG is set and 
> CONFIG_DYNAMIC_PRINTK_DEBUG is not set i need to be able get the proper
> definition of 'dynamic_dbg_enabled()' out of dynamic_print.h (included by
> kernel.h). This proper definition is obtained by setting 'DEBUG', and
> thus i need to define this before the kernel.h include. 
> 
> We can solve #2 by defining an explicit definition for dynamic_dbg_enabled() 
> when only CONFIG_CPU_FREQ_DEBUG within cpufreq.h. roughly:
> 
> #ifdef CONFIG_CPU_FREQ_DEBUG
> #define cpufreq_debug_printk(flag) 
> 	if (cpufreq_debug & flag)
> 		 __cpufreq_debug_printk()
> 
> However, the way i have it now I don't need two definitions for 
> cpufreq_debug_printk....

Not that much of a nuiseance, IMO. Or SELECT CONFIG_DYNAMIC_PRINTK_DEBUG
when CONFIG_CPU_FREQ_DEBUG is enabled (if davej agrees ;) )

Best,
	Dominik
