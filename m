Return-Path: <linux-kernel-owner+w=401wt.eu-S1757065AbXEIMRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065AbXEIMRZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 08:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbXEIMRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 08:17:18 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:48288 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992AbXEIMRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 08:17:17 -0400
Date: Wed, 9 May 2007 17:46:41 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Pavel Machek <pavel@ucw.cz>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, rjw@sisk.pl,
       James.Bottomley@SteelEye.com, aneesh.kumar@gmail.com, drzeus@drzeus.cx,
       dwmw2@infradead.org, greg@kroah.com, mingo@elte.hu, neilb@suse.de,
       oleg@tv-sign.ru, paulmck@linux.vnet.ibm.com, vatsa@in.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 128/197] freezer: add try_to_freeze calls to all kernel threads
Message-ID: <20070509121641.GA27109@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <200705090934.l499YTvX019783@shell0.pdx.osdl.net> <4641A5F1.5080901@s5r6.in-berlin.de> <20070509104949.GA8164@elf.ucw.cz> <4641B92D.1030909@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4641B92D.1030909@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefan, 
On Wed, May 09, 2007 at 02:06:05PM +0200, Stefan Richter wrote:
> Pavel Machek wrote:
> >> > Add try_to_freeze() calls to the remaining kernel threads that do not call
> >> > try_to_freeze() already, although they set PF_NOFREEZE.
> >> > 
> >> > In the future we are going to replace PF_NOFREEZE with a set of flags that
> >> > will be set to indicate in which situations the task should not be frozen (for
> >> > example, there can be a task that should be frozen for the CPU hotplugging and
> >> > should not be frozen for the system suspend).
> [...]
> >> Why add no-op-try_to_freeze() everywhere now, instead of adding it later
> >> when it will actually be needed?  (I.e. "in the future".)
> > 
> > It is needed later in the patch series... for kprobes, etc.
> 
> So does freezer_exempt() still do what its name says, or does it
> freezer_exempt_but_not_always() now?

freezer_exempt() as of now does what its name says. I.e, exempt the
thread from all kinds of freeze chills.

But with more subsystems using the process freezer, the exemption needs
to be event specific. There may be threads which should not be frozen 
for say kprobes, should be frozen for cpu-hotplug. This selective
freezing is not yet available. But it will be soon...

> -- 
> Stefan Richter
> -=====-=-=== -=-= -=--=
> http://arcgraph.de/sr/

Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
