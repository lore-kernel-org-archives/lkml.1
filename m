Return-Path: <linux-kernel-owner+w=401wt.eu-S1758085AbXIFRyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085AbXIFRyj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 13:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753201AbXIFRyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 13:54:32 -0400
Received: from mga03.intel.com ([143.182.124.21]:45028 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018AbXIFRyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 13:54:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,216,1186383600"; 
   d="scan'208";a="273371127"
From: Jesse Barnes <jesse.barnes@intel.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [patches] [patch 3/5] x86: Add PCI extended config space access for AMD Barcelona
Date: Thu, 6 Sep 2007 10:48:25 -0700
User-Agent: KMail/1.9.7
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "Arne Georg Gleditsch" <argggh@dolphinics.no>,
       "Andreas Herrmann" <andreas.herrmann3@amd.com>,
       "Robert Richter" <robert.richter@amd.com>,
       "Arjan van de Ven" <arjan@infradead.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
References: <20070903081736.288288000@amd.com> <200709061041.15488.jesse.barnes@intel.com> <86802c440709061050x714a2bbbn776fb93cb46cdc49@mail.gmail.com>
In-Reply-To: <86802c440709061050x714a2bbbn776fb93cb46cdc49@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709061048.26532.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 6, 2007 10:50 am Yinghai Lu wrote:
> On 9/6/07, Jesse Barnes <jesse.barnes@intel.com> wrote:
> > The problem with doing that is it would mean reserving some address
> > space for mmconfig usage.  If the BIOS doesn't completely describe
> > all the reserved regions via e820 or similar (apparently a common
> > problem) we may end up making mmconfig overlap with another
> > important area... It's pretty hard not to trust the BIOS here
> > without completely replacing big chunks of it.
>
> for Family 10h, you can use mmio range high beyond than the RAM
> range...( just don't conflict with HT reserved range...)

Sure, and on some Intel platforms we can configure things similarly.  
But any such changes will be platform specific.  I'm just not sure 
allocating mmconfig space ourselves is worth the trouble.  Besides, 
most machines made in the last few years can do it, as long as we look 
at the right BIOS bits (i.e. MCFG not e820) and remember to disable PCI 
device decode when probing BAR sizes for example. :)

Jesse
