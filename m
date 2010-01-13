Return-Path: <linux-kernel-owner+w=401wt.eu-S1753891Ab0AMBtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891Ab0AMBtr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 20:49:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323Ab0AMBtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 20:49:46 -0500
Received: from mga01.intel.com ([192.55.52.88]:21136 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929Ab0AMBtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 20:49:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,264,1262592000"; 
   d="scan'208";a="530746891"
Subject: Re: [PATCH -v2 5/5] x86: use dmi check to treat disabled cpus as
 hotplug cpus.
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "ananth@in.ibm.com" <ananth@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4B4D0E39.10200@kernel.org>
References: <1263338274-6485-1-git-send-email-yinghai@kernel.org>
	 <1263338274-6485-5-git-send-email-yinghai@kernel.org>
	 <1263340563.2854.1011.camel@sbs-t61.sc.intel.com>
	 <4B4D0E39.10200@kernel.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 12 Jan 2010 17:48:35 -0800
Message-Id: <1263347315.2854.1296.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-12 at 16:05 -0800, Yinghai Lu wrote:
> On 01/12/2010 03:56 PM, Suresh Siddha wrote:
> > On Tue, 2010-01-12 at 15:17 -0800, Yinghai Lu wrote:
> >> some systems that have disable cpus entries because same
> >>   BIOS will support 2 sockets and 4 sockets and more at
> >>   same time, BIOS just leave some disable entries, but
> >>   those system do not support cpu hotplug. we don't need
> >>   treat disabled_cpus as hotplug cpus.
> >> so we can make nr_cpu_ids smaller and save more space
> >>   (pcpu data allocations), and could make some systems run
> >>   with logical flat instead of physical flat apic mode
> >>
> >> -v2: change to black list instead
> > 
> > I don't think this list will work because every HT system with HT
> > disabled in the bios shows that logical cpu as disabled.
> 
> so you want to treat those disabled cpus in the those system as hotplug cpus or not?

They are really not hot plug cpus, so they can also take advantage of
what you are trying to provide with this patch.

Also I am very confused with what exactly you are doing with the dmi
list..

+        printk(KERN_NOTICE "%s detected: treat disabled cpus as hotplug ones\n", d->ident);
+        treat_disabled_cpus_as_hotplug = 0;

???

