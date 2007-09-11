Return-Path: <linux-kernel-owner+w=401wt.eu-S1763420AbXIKKKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763420AbXIKKKw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 06:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760530AbXIKKKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 06:10:44 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58069 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750818AbXIKKKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 06:10:43 -0400
Date: Tue, 11 Sep 2007 11:16:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Chuck Ebbert <cebbert@redhat.com>, Karl Bellve <Karl.Bellve@umassmed.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: PCI: Unable to reserve mem region problem
Message-ID: <20070911111641.1e26a17c@the-village.bc.nu>
In-Reply-To: <46E5F300.20602@shaw.ca>
References: <fa.kIR1dSmxlPM+uRVmi9kPkHkX/W8@ifi.uio.no>
	<fa.mWCFmDlYQmMO/aBFdKFbo8OVII4@ifi.uio.no>
	<fa.xf8XcHy8Nla3C3Q0MmArV00z04k@ifi.uio.no>
	<46E5F300.20602@shaw.ca>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > https://bugzilla.redhat.com/show_bug.cgi?id=280641
> 
> The last BAR on the nForce4 ADMA controllers on this board are at 
> 0xdfefe000 and 0xdfefd000. But it looks like PnP ACPI is also reserving 
> those memory ranges:
> 
> Aug 30 14:08:02 alcor kernel: pnp: 00:09: iomem range 
> 0xdfefd000-0xdfefd3ff has been reserved
> Aug 30 14:08:02 alcor kernel: pnp: 00:09: iomem range 
> 0xdfefe000-0xdfefe3ff has been reserved
> 
> Which I very much doubt it should be doing, the BIOS doesn't need to 
> reserve PCI BAR ranges in the ACPI tables. This sounds like a BIOS bug. 
> You might want to check for an update from Supermicro.

They may be doing it to force the system out of ADMA mode. Right now we
just blow up in that case but it appears other-OS may fall back (which is
I suspect what we need to be doing)
