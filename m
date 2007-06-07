Return-Path: <linux-kernel-owner+w=401wt.eu-S934183AbXFGRfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934183AbXFGRfk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 13:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbXFGRfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 13:35:31 -0400
Received: from mga03.intel.com ([143.182.124.21]:34490 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbXFGRfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 13:35:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,395,1175497200"; 
   d="scan'208";a="236712863"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Date: Thu, 7 Jun 2007 10:35:18 -0700
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, Justin Piszcz <jpiszcz@lucidpixels.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <200706061229.24486.jesse.barnes@intel.com> <20070607081619.GA15226@one.firstfloor.org>
In-Reply-To: <20070607081619.GA15226@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706071035.18356.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 7, 2007 1:16 am Andi Kleen wrote:
> On Wed, Jun 06, 2007 at 12:29:23PM -0700, Jesse Barnes wrote:
> > On some machines, buggy BIOSes don't properly setup WB MTRRs to
> > cover all available RAM, meaning the last few megs (or even gigs)
> > of memory will be marked uncached.  Since Linux tends to allocate
> > from high memory addresses first, this causes the machine to be
> > unusably slow as soon as the kernel starts really using memory
> > (i.e. right around init time).
>
> In theory -- while not recommended -- a BIOS could also
> use a default fallback MTRR for cached and use explicit MTRRs to
> map the non existing ranges uncached. Would it make sense to handle
> this case?

Probably.  I could just check the default memory type and bail out if 
it's cacheable.

> Should also probably have some command line option
> to disable the check in case something bad happens with it.

Sure.

> Another thing that might be sense to investigate in relationship
> to this patch is large page mappings with MTRRs. iirc P4 and also K8
> splits pages internally with MTRR boundaries and might have some
> other bad side effects. Should we use this as hints to use 4K pages
> for the boundary areas?

Or I could trim to the nearest large page boundary...  We'd lose a 
little more memory but it would keep things simple.

Jesse
