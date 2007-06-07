Return-Path: <linux-kernel-owner+w=401wt.eu-S1758862AbXFGIQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758862AbXFGIQg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 04:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754054AbXFGIQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 04:16:23 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52217 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbXFGIQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 04:16:22 -0400
Date: Thu, 7 Jun 2007 10:16:19 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jesse Barnes <jesse.barnes@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Justin Piszcz <jpiszcz@lucidpixels.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Message-ID: <20070607081619.GA15226@one.firstfloor.org>
References: <200706061229.24486.jesse.barnes@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706061229.24486.jesse.barnes@intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2007 at 12:29:23PM -0700, Jesse Barnes wrote:
> On some machines, buggy BIOSes don't properly setup WB MTRRs to
> cover all available RAM, meaning the last few megs (or even gigs)
> of memory will be marked uncached.  Since Linux tends to allocate
> from high memory addresses first, this causes the machine to be
> unusably slow as soon as the kernel starts really using memory
> (i.e. right around init time).

In theory -- while not recommended -- a BIOS could also
use a default fallback MTRR for cached and use explicit MTRRs to 
map the non existing ranges uncached. Would it make sense to handle this case?

Right now if someone used a default WC MTRR to make the memory
cached you would clip all memory.

Perhaps a fail safe would be good -- always leave some
memory left over even if it looks wrong.

Should also probably have some command line option 
to disable the check in case something bad happens with it.

Another thing that might be sense to investigate in relationship
to this patch is large page mappings with MTRRs. iirc P4 and also K8
splits pages internally with MTRR boundaries and might have some other 
bad side effects. Should we use this as hints to use 4K pages
for the boundary areas?

-Andi

