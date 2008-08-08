Return-Path: <linux-kernel-owner+w=401wt.eu-S1756161AbYHHBPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161AbYHHBPe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 21:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbYHHBP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 21:15:26 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:55620 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752170AbYHHBPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 21:15:25 -0400
Subject: Re: [PATCH]Fix broken VMI in 2.6.27-rc..
From: Zachary Amsden <zach@vmware.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@kernel.org>, Alok Kataria <akataria@vmware.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <489B8EF4.1030105@goop.org>
References: <1218136365.23770.52.camel@alok-dev1>
	 <489B6710.9000604@kernel.org>
	 <1218144438.20178.336.camel@bodhitayantram.eng.vmware.com>
	 <489B836A.3050209@goop.org> <489B84EF.6050009@kernel.org>
	 <489B8948.6060003@goop.org> <489B8A68.10900@kernel.org>
	 <489B8EF4.1030105@goop.org>
Content-Type: text/plain
Date: Thu, 07 Aug 2008 18:14:05 -0700
Message-Id: <1218158045.20178.394.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-07 at 17:10 -0700, Jeremy Fitzhardinge wrote:
> H. Peter Anvin wrote:
> > Jeremy Fitzhardinge wrote:
> >> H. Peter Anvin wrote:
> >>> The fixmap area should never have been made movable.  It's utter
> >>> braindamage.
> >>
> >> Shrug.  It's been like that for a couple of years now.  It was one of
> >> the very first paravirt-ops patches.  It wasn't controversial then,
> >> and nobody seems to have noticed since.
> >
> > The Linux kernel was never a paragon of perfection - it was never
> > meant to be.  Just because a bit of cruft went unnoticed into the
> > kernel doesn't mean we shouldn't fix it.
> 
> I don't really see what the issue is.
> 
> Fixmaps are primarily used for things that need to be mapped early
> before we can allocate address space dynamically.  They're predominantly
> used for boot-time init, and rarely on any performance-critical path.
> The only vaguely regular use a fixmap gets during runtime is poking at
> apics, and that's dominated by IO time, and kmap_atomic.  Statically,
> there's only 100 references in the kernel.  And it only affects 32-bit.
> 
> Having fixmaps at link-time fixed addresses would be nice, I suppose,
> but hardly worth going to vast effort over.

Using my interplanetary ideas, linking the fixmap at runtime would allow
optimal placement of the fixmap, any hypervisor areas, vmalloc, and
pkmap space.  That might allow one to increase the amount of lowmem
available for direct mapping depending on some platform variables such
as hypervisor reserved space, physical memory size, APIC present.. those
aren't known until boot time.  Actually, NCPUs is a good one, since we
require atomic kmap space dependent on NCPUs, which could be given back
to linear memory map.

That might actually be more worthwhile than link time fixed addresses.

Zach

