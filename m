Return-Path: <linux-kernel-owner+w=401wt.eu-S1765604AbXEYVH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765604AbXEYVH5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 17:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754042AbXEYVHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 17:07:49 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:13099 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753966AbXEYVHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 17:07:48 -0400
X-IronPort-AV: i="4.14,581,1170662400"; 
   d="scan'208"; a="154629669:sNHT14720952015"
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Greg KH <gregkh@suse.de>, Jay Cliburn <jacliburn@bellsouth.net>,
       Grzegorz Krzystek <ninex@NineX.eu.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       ninex@o2.pl, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Michael Ellerman <michael@ellerman.id.au>,
       David Miller <davem@davemloft.net>, Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH 1/2] msi: Invert the sense of the MSI enables.
X-Message-Flag: Warning: May contain useful information
References: <20070514093829.377e04bc@osprey.hogchain.net>
	<m18xbrnyxi.fsf@ebiederm.dsl.xmission.com>
	<20070514160005.627435e3@osprey.hogchain.net>
	<m1odkmmft4.fsf@ebiederm.dsl.xmission.com>
	<20070515212200.517fcba2@osprey.hogchain.net>
	<m14pmcmz8r.fsf@ebiederm.dsl.xmission.com>
	<20070516185225.3f3ac082@osprey.hogchain.net>
	<m1sl9wl28m.fsf@ebiederm.dsl.xmission.com>
	<20070522204103.134bf5a2@osprey.hogchain.net>
	<m1veehcz7m.fsf_-_@ebiederm.dsl.xmission.com>
	<20070525052032.GB9386@suse.de>
	<m1myztaq5s.fsf@ebiederm.dsl.xmission.com> <adawsyw52tl.fsf@cisco.com>
	<adasl9k52q8.fsf@cisco.com> <m18xbcc2ai.fsf@ebiederm.dsl.xmission.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 25 May 2007 13:25:26 -0700
In-Reply-To: <m18xbcc2ai.fsf@ebiederm.dsl.xmission.com> (Eric W. Biederman's message of "Fri, 25 May 2007 10:10:13 -0600")
Message-ID: <adafy5k4pmx.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.19 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 25 May 2007 20:25:26.0425 (UTC) FILETIME=[D4561890:01C79F0A]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 > > In addition to PCI INTx compatible interrupt emulation, PCI Express
 > > requires support of MSI or MSI-X or both. 
 > Which suggests that INTx support is required.
 > 
 > I do not find any wording that suggest the opposite.
 > I do see it stated that it is intended to EOL support for INTx at
 > some point.
 > 
 > Where did you see it mentioned that INTx was optional?

I don't see any requirement that a device that generates MSI
interrupts must also be able to signal the same interrupts via INTx.
The spec explicitly says:

    "All PCI Express device Functions that are capable of generating
    interrupts must support MSI or MSI-X or both."

but there is no corresponding explicit requirement that legacy INTx
mode be supported, so it certainly seems permitted for a device not to
generate INTx interrupts.  In fact as you alluded to, the spec says,

    "The legacy INTx emulation mechanism may be deprecated in a future
    version of this specification."

and I wouldn't think the intention would be for one version of the
spec to *require* something that is planned on being deprecated later.

And the Pathscale guys were pretty confident that their device was
compliant with the PCIe spec.

 - R.
