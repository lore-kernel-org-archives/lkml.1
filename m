Return-Path: <linux-kernel-owner+w=401wt.eu-S1756705AbXISVfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705AbXISVfj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 17:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757261AbXISVfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 17:35:19 -0400
Received: from outbound-mail-39.bluehost.com ([69.89.20.193]:54526 "HELO
	outbound-mail-39.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756847AbXISVfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 17:35:17 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: [PATCH]PCI:disable resource decode in PCI BAR detection
Date: Wed, 19 Sep 2007 14:34:44 -0700
User-Agent: KMail/1.9.7
Cc: Shaohua Li <shaohua.li@intel.com>, Robert Hancock <hancockr@shaw.ca>,
       Greg KH <gregkh@suse.de>, Matthew Wilcox <matthew@wil.cx>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Andrew Morton <akpm@linux-foundation.org>
References: <fa.13eJumylqINOxOaoEj9cthw0d0M@ifi.uio.no> <1189992107.26772.4.camel@sli10-conroe.sh.intel.com> <20070918135305.A26491@jurassic.park.msu.ru>
In-Reply-To: <20070918135305.A26491@jurassic.park.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709191434.45127.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.103.130.182 authed with jbarnes@virtuousgeek.org}
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box128.bluehost.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [642 0] / [47 12]
X-AntiAbuse: Sender Address Domain - virtuousgeek.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 18, 2007 2:53 am Ivan Kokshaysky wrote:
> On Mon, Sep 17, 2007 at 09:21:47AM +0800, Shaohua Li wrote:
> > I can confirm this is an add-in graphics card. the bfd is 00:02.0,
> > so it's not behind any AGP/PCI-E bridge.
>
> AFAIKS, 00:02.0 is *integrated* controller. Can you check that
> "graphic adapter priority" setting in BIOS is "PCI Express" and not
> "Internal VGA"? In the latter case an add-on card might be turned
> completely off, so it doesn't even show up in lspci output.

Yeah, it's integrated gfx.  See the PRM at intel.com for the decode 
rules.

I've been following this thread and I see a lot of fear about moving to 
probing BARs as outlined in the PCI spec.  I haven't seen much in the 
way of hard evidence though, mostly just handwaving or red herrings 
(and even one comment implying that -mm wasn't a real testbed for 
patches) that don't have much to do with the actual "disable, size, 
re-enable" logic.  Has a conclusion been reached yet?

Keep in mind that any failures that occur due to this patch should be 
easy to track down (boot hang), but we have yet to see any in real 
life.  Moreover, reversion is trivial, and we could move to a more 
complex scheme at that time if needed, but why bother unless we're sure 
we need to?

Thanks,
Jesse
