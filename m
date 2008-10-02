Return-Path: <linux-kernel-owner+w=401wt.eu-S1754572AbYJBSC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbYJBSC6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 14:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753652AbYJBSCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 14:02:50 -0400
Received: from www.tglx.de ([62.245.132.106]:44249 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753571AbYJBSCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 14:02:50 -0400
Date: Thu, 2 Oct 2008 20:02:30 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
cc: Olaf Kirch <okir@suse.de>, Jiri Kosina <jkosina@suse.cz>,
       linux-kernel@vger.kernel.org, linux-netdev@vger.kernel.org,
       kkeil@suse.de, agospoda@redhat.com, arjan@linux.intel.com,
       "Graham, David" <david.graham@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>,
       "Ronciak, John" <john.ronciak@intel.com>, chris.jones@canonical.com,
       tim.gardner@intel.com, airlied@gmail.com
Subject: RE: [RFC PATCH 07/12] e1000e: debug contention on NVM SWFLAG
In-Reply-To: <36D9DB17C6DE9E40B059440DB8D95F52064FB25C@orsmsx418.amr.corp.intel.com>
Message-ID: <alpine.LFD.1.10.0810021959030.5549@apollo.tec.linutronix.de>
References: <20080930030825.22950.18891.stgit@jbrandeb-bw.jf.intel.com> <20080930031952.22950.45228.stgit@jbrandeb-bw.jf.intel.com> <Pine.LNX.4.64.0810021624380.1887@twin.jikos.cz> <200810021703.43770.okir@suse.de>
 <36D9DB17C6DE9E40B059440DB8D95F52064FB25C@orsmsx418.amr.corp.intel.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Oct 2008, Brandeburg, Jesse wrote:

> Olaf Kirch wrote:
> > Looks like the e1000 watchdog racing with some dhclient activity
> > (upping the interface). 
>  
> > I just noticed that the driver actually uses register pages. So it
> > looks like it's possible to have something like this without the
> > mutex: 
> > 
> > 	process A selects page A
> > 	process B selects page B
> > 	process A writes to register at offset A'
> 
> I think that is possible, which is why the mutex patch would be good for
> the future.  However we have not shown that to be happening as a root
> cause, but I don't rule it out.

Nevertheless I vote strongly for putting that check in _NOW_. It has
proven that there is concurrent access and that's definitely a bug by
all means.

> so, why now?  Drivers since before the e1000/e1000e split had this same
> code, with no reports of problems.  This code has been heavily tested,
> and one of the platforms easily reproducing this has been available for
> 3 years now (ich8), with code that is basically unchanged in the driver.

Well, timing of events changes slightly over time and we definitely
had some major changes in the last three years which influence timing
(high res timers, dynticks, NAPI ....)

Thanks,

	tglx
