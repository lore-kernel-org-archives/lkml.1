Return-Path: <linux-kernel-owner+w=401wt.eu-S1758794AbZEEWTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758794AbZEEWTU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 18:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753821AbZEEWTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 18:19:08 -0400
Received: from cantor.suse.de ([195.135.220.2]:52514 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752996AbZEEWTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 18:19:06 -0400
Date: Tue, 5 May 2009 15:14:03 -0700
From: Greg KH <gregkh@suse.de>
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Cc: linux-kernel@vger.kernel.org, kosaki.motohiro@jp.fujitsu.com,
       akpm@linux-foundation.org, cl@linux-foundation.org,
       dave@linux.vnet.ibm.com, ebmunson@us.ibm.com, mel@csn.ul.ie,
       stable@kernel.org
Subject: Re: patch
	mm-fix-committed_as-underflow-on-large-nr_cpus-environment.patch
	added to 2.6.29-stable tree
Message-ID: <20090505221403.GA4714@suse.de>
References: <20090504220454.3F71148FB8@coco.kroah.org> <200905052036.24106.s.L-H@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905052036.24106.s.L-H@gmx.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 05, 2009 at 08:36:19PM +0200, Stefan Lippers-Hollmann wrote:
> Hi
> 
> On Dienstag, 5. Mai 2009, gregkh@suse.de wrote:
> [...]
> > From 00a62ce91e554198ef28234c91c36f850f5a3bc9 Mon Sep 17 00:00:00 2001
> > From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > Date: Thu, 30 Apr 2009 15:08:51 -0700
> > Subject: mm: fix Committed_AS underflow on large NR_CPUS environment
> > 
> > From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > 
> > commit 00a62ce91e554198ef28234c91c36f850f5a3bc9 upstream.
> > 
> > The Committed_AS field can underflow in certain situations:
> > 
> > >         # while true; do cat /proc/meminfo  | grep _AS; sleep 1; done | uniq -c
> > >               1 Committed_AS: 18446744073709323392 kB
> > >              11 Committed_AS: 18446744073709455488 kB
> > >               6 Committed_AS:    35136 kB
> > >               5 Committed_AS: 18446744073709454400 kB
> > >               7 Committed_AS:    35904 kB
> > >               3 Committed_AS: 18446744073709453248 kB
> > >               2 Committed_AS:    34752 kB
> > >               9 Committed_AS: 18446744073709453248 kB
> > >               8 Committed_AS:    34752 kB
> > >               3 Committed_AS: 18446744073709320960 kB
> > >               7 Committed_AS: 18446744073709454080 kB
> > >               3 Committed_AS: 18446744073709320960 kB
> > >               5 Committed_AS: 18446744073709454080 kB
> > >               6 Committed_AS: 18446744073709320960 kB
> > 
> > Because NR_CPUS can be greater than 1000 and meminfo_proc_show() does
> > not check for underflow.
> > 
> > But NR_CPUS proportional isn't good calculation.  In general,
> > possibility of lock contention is proportional to the number of online
> > cpus, not theorical maximum cpus (NR_CPUS).
> > 
> > The current kernel has generic percpu-counter stuff.  using it is right
> > way.  it makes code simplify and percpu_counter_read_positive() don't
> > make underflow issue.
> 
> This patch reproducably panics on all systems I could test so far on 
> 2.6.29.2 + the current stable queue:
> - Acer Aspire One, Intel Atom N270, Intel 945GC chipset (i386)
> - AMD64 3200+, nVidia nforce3 chipset (amd64)
> - AMD64 X2 4200+, nVidia nforce4 chipset (amd64)
> 
> Kernel panic (sorry, this is from a bad webcam and only the last part of 
> the messages scrolling by - I can try to get a serial console tomorrow), 
> taken from an AMD64 3200+, nVidia nforce3 chipset (amd64).
> http://sidux.com/slh/mm-fix-committed_as-underflow-on-large-nr_cpus-environment/panic.gif [198 KB]
> 
> Reverting just this patch fixes the problem for me.
> 
> Kernel configurations:
> http://sidux.com/slh/mm-fix-committed_as-underflow-on-large-nr_cpus-environment/config-2.6.29-2.slh.5.3-sidux-686   [96 KB]
> http://sidux.com/slh/mm-fix-committed_as-underflow-on-large-nr_cpus-environment/config-2.6.29-2.slh.5.6-sidux-amd64 [91 KB]

Yes, I just confirmed this on my machines as well, so I'm going to drop
it from the stable queue.

If anyone thinks it is really necessary for the 2.6.29-stable tree,
please resubmit it after fixing it and testing that it works :)

thanks,

greg k-h
