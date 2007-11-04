Return-Path: <linux-kernel-owner+w=401wt.eu-S1753800AbXKDVTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbXKDVTS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 16:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbXKDVTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 16:19:06 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:52949 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbXKDVTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 16:19:03 -0500
Subject: Re: Quad core CPU detected but shows as single core in 2.6.23.1
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: Chris Snook <csnook@redhat.com>, Zurk Tech <zurktech@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <p737ikx3ksn.fsf@bingen.suse.de>
References: <2ed59cbb0711021231l55fe2df3l23f8da65bb7166f6@mail.gmail.com>
	 <472D2119.8090102@redhat.com>  <p737ikx3ksn.fsf@bingen.suse.de>
Content-Type: text/plain
Date: Sun, 04 Nov 2007 22:18:21 +0100
Message-Id: <1194211101.20832.3.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2007-11-04 at 19:52 +0100, Andi Kleen wrote:
> Chris Snook <csnook@redhat.com> writes:
> 
> >> Marking TSC unstable due to TSCs unsynchronized
> >
> > This is probably wrong.  The TSC is on the northbridge on Barcelona
> > chips, so every core on the die should be in sync.  Hypothetically you
> > could have different speed northbridges in different sockets, but
> > we've never tried very hard to support that case anyway.  We should
> > probably be marking the TSC as stable on Barcelona chips.
> 
> It's a little more complicated. Stable clock is only guaranteed as long 
> as the CPUs all run on the same clock crystal. That is true 
> when they're all on the current motherboard. But at least for K8
> there were several systems that consist of multiple motherboards
> and HT cables inbetween them (like all the 8 socket systems).
> On those the TSCs can drift too with Fam10h. I'm not aware
> of any of those shipping yet, but since it's essentially 
> the same platform as K8 they will appear sooner or later.
> 
> So far we lack a reliable way to detect this condition. If it could
> be detected it would be possible to switch to TSC timing
> for the single motherboard systems.

Would it not be as simple as looking at the BIOS provided topology
information? If nr sockets > 4 assume multiple board.

Of course one could run a multi board solution and not utilize all
sockets, in which case the heuristic would fail, but I guess buying such
an expensive solution and then not sticking in the cpus is rather rare.


