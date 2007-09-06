Return-Path: <linux-kernel-owner+w=401wt.eu-S1757164AbXIFRr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164AbXIFRr2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 13:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754573AbXIFRrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 13:47:21 -0400
Received: from mga03.intel.com ([143.182.124.21]:55830 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754562AbXIFRrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 13:47:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,216,1186383600"; 
   d="scan'208";a="273367081"
From: Jesse Barnes <jesse.barnes@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patches] [patch 3/5] x86: Add PCI extended config space access for AMD Barcelona
Date: Thu, 6 Sep 2007 10:41:14 -0700
User-Agent: KMail/1.9.7
Cc: Arne Georg Gleditsch <argggh@dolphinics.no>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
References: <20070903081736.288288000@amd.com> <kjmps0w9ou8.fsf@pelargir.dolphinics.no> <46DFCCD9.2010306@zytor.com>
In-Reply-To: <46DFCCD9.2010306@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709061041.15488.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 6, 2007 2:48 am H. Peter Anvin wrote:
> Arne Georg Gleditsch wrote:
> > "Yinghai Lu" <yhlu.kernel@gmail.com> writes:
> >> mmconfig is set in NB ( in new CPU), Do we still need to set
> >> mmconfig in SB like mcp55?
> >
> > I wasn't aware that the family 10h-chips had MSRs for setting the
> > mmconfig address space directly in the NB (core?).  Please
> > disregard my previous comment...
>
> Well, to a first order of approximations, *all* northbridges have
> some sort of hardware registers to set mmconfig.  We were talking
> yesterday that it might just make more sense to have code for various
> northbridges to configure mmconfig directly, just like we do for IRQ
> routing (we can't trust the BIOS there, either.)

The problem with doing that is it would mean reserving some address 
space for mmconfig usage.  If the BIOS doesn't completely describe all 
the reserved regions via e820 or similar (apparently a common problem) 
we may end up making mmconfig overlap with another important area...  
It's pretty hard not to trust the BIOS here without completely 
replacing big chunks of it.

Jesse
