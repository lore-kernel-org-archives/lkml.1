Return-Path: <linux-kernel-owner+w=401wt.eu-S1758260AbXFZPSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758260AbXFZPSz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 11:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754352AbXFZPSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 11:18:48 -0400
Received: from outbound-mail-36.bluehost.com ([69.89.20.190]:54749 "HELO
	outbound-mail-36.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752085AbXFZPSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 11:18:47 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Date: Tue, 26 Jun 2007 08:18:33 -0700
User-Agent: KMail/1.9.7
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Justin Piszcz <jpiszcz@lucidpixels.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
References: <200706251434.43863.jesse.barnes@intel.com> <20070626150348.GB7877@one.firstfloor.org> <200706260807.45362.jbarnes@virtuousgeek.org>
In-Reply-To: <200706260807.45362.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706260818.33759.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.103.130.182 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 26, 2007 8:07:45 am Jesse Barnes wrote:
> On Tuesday, June 26, 2007 8:03:48 am Andi Kleen wrote:
> > On Mon, Jun 25, 2007 at 08:30:52PM -0700, Jesse Barnes wrote:
> > > Oh, and FYI I've seen new systems with a default mapping type of WB,
> > > with a few uncached holes for MMIO.  That means PAT will be absolutely
> > > required on those systems if we want to use WC for the framebuffer or
> > > other memory.
> >
> > Why? As long as there are still MTRRs free you could use them for
> > WC even in this setup.
>
> According to the manual, you can't use WC or WT MTRRs on top of a WB MTRR
> range.  Only UC MTRRs can override WB MTRRs, but PAT doesn't have this
> restriction.

Actually, it looks like WT on top of WB is ok, but not WC on top of WB, 
quoting from the manual:

> 1. If the physical address falls within the first 1 MByte of physical
> memory and fixed MTRRs are enabled, the processor uses the memory type
> stored for the appropriate fixed-range MTRR.
>
> 2. Otherwise, the processor attempts to match the physical address with a
> memory type set by the variable-range MTRRs:
>
>     a. If one variable memory range matches, the processor uses the memory
>        type stored in the IA32_MTRR_PHYSBASEn register for that range.
>     b. If two or more variable memory ranges match and the memory types are
>        identical, then that memory type is used.
>     c. If two or more variable memory ranges match and one of the memory
>        types is UC, the UC memory type used.
>     d. If two or more variable memory ranges match and the memory types are
>        WT and WB, the WT memory type is used.
>     e. For overlaps not defined by the above rules, processor behavior is
>        undefined.
>
> 3. If no fixed or variable memory range matches, the processor uses the
> default memory type.

