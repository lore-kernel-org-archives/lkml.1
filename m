Return-Path: <linux-kernel-owner+w=401wt.eu-S1763096AbXFBBJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763096AbXFBBJS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 21:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757090AbXFBBJJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 21:09:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:18551 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752902AbXFBBJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 21:09:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,374,1175497200"; 
   d="scan'208";a="252349575"
Date: Fri, 1 Jun 2007 18:05:39 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Andi Kleen <andi@firstfloor.org>, Justin Piszcz <jpiszcz@lucidpixels.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Intel's response Linux/MTRR/8GB Memory Support / Why doesn't the kernel realize the BIOS has problems and re-map appropriately?
Message-ID: <20070602010539.GA13512@linux-os.sc.intel.com>
References: <Pine.LNX.4.64.0706011410130.3716@p34.internal.lan> <200706011407.51779.jbarnes@virtuousgeek.org> <20070601211943.GO7217@one.firstfloor.org> <200706011441.57149.jbarnes@virtuousgeek.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706011441.57149.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2007 at 02:41:57PM -0700, Jesse Barnes wrote:
> On Friday, June 1, 2007 2:19:43 Andi Kleen wrote:
> > And normally the MTRRs win, don't they (if I remember the table correctly)
> > So if the MTRR says UC and PAT disagrees it might not actually help
> 
> I just checked, yes the MTRRs win for UC types.  But it sounds like the cases 
> we're talking about are actually situations where there's no MTRR coverage, 
> so the default type is used.  The manual doesn't specifically call out how 
> memory using the default type interacts with PAT, but it may well be that it 
> stays uncached if the default type is uncached.  Again that argues for fixing 
> the MTRR mapping problem in some way.
> 

I feel, having a silent/transparent workaround is not a good idea. With that
chances are BIOS bug will go unnoticed (having an error message in dmesg may not
get noticed either). Probably we should just panic at boot with a
detailed message about the e820 mtrr discrepancy (which can be logged as
a BUG to BIOS provider) and suggest a temporary workaround of "mem=___".

Thanks,
Venki
