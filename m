Return-Path: <linux-kernel-owner+w=401wt.eu-S1755443AbZHMT2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbZHMT2e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754044AbZHMT2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:28:33 -0400
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:51739 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753020AbZHMT2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:28:32 -0400
From: Frans Pop <elendil@planet.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Regression] PCI resources allocation problem on HP nx6325
Date: Thu, 13 Aug 2009 21:28:29 +0200
User-Agent: KMail/1.9.9
Cc: mano@roarinelk.homelinux.net, rjw@sisk.pl, willy@linux.intel.com,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       akpm@linux-foundation.org, andrew.patterson@hp.com
References: <200908021619.48285.rjw@sisk.pl> <alpine.LFD.2.01.0908020927410.3352@localhost.localdomain> <20090803165909.GA12824@roarinelk.homelinux.net> <alpine.LFD.2.01.0908041555120.3270@localhost.localdomain> <20090805155102.GA31646@roarinelk.homelinux.net> <alpine.LFD.2.01.0908050902300.3390@localhost.localdomain> <alpine.LFD.2.01.0908050931390.3390@localhost.localdomain> <20090805170934.GA32274@roarinelk.homelinux.net> <alpine.LFD.2.01.0908071051300.3390@localhost.localdomain> <alpine.LFD.2.01.0908071116520.3390@localhost.localdomain> <20090811184740.49f52b57@scarran.roarinelk.net> <20090811184740.49f52b57@scarran.roarinelk.net> <alpine.LFD.2.01.0908131113580.28882@localhost.localdomain>
In-reply-To: <alpine.LFD.2.01.0908131113580.28882@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908132128.31439.elendil@planet.nl>
X-OriginalArrivalTime: 13 Aug 2009 19:28:32.0023 (UTC) FILETIME=[3E34F270:01CA1C4C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> I'm not going to do anything about it right now, since clearly we've
> not changed any actual behavior from before. But if you remind me after
> 2.6.31 is out, I'll look at perhaps making a better
> "pci_claim_resource()" that actually iterates over the different parent
> resources and doesn't just try to find one (and then fail if that
> particular one doesn't work out).

Just for your information, this issue also affects my (old) Toshiba
Satellite A40.

With pre-2.6.31 kernels I always had the following in dmesg:
pci 0000:00:1d.0: BAR 4: can't allocate resource
pci 0000:00:1d.1: BAR 4: can't allocate resource
[...]
pnp 00:08: io resource (0x10-0x1f) overlaps 0000:00:1d.0 BAR 4 (0x0-0x1f), disabling
pnp 00:08: io resource (0x10-0x1f) overlaps 0000:00:1d.1 BAR 4 (0x0-0x1f), disabling

I was very happy to see that for 2.6.31-rc2 those messages were gone.

But with .31-rc5 they are back again, with added "address space collision":
pci 0000:00:1d.0: BAR 4: address space collision on of device [0xcfe0-0xcfff]
pci 0000:00:1d.0: BAR 4: can't allocate resource
pci 0000:00:1d.1: BAR 4: address space collision on of device [0xcf80-0xcf9f]
pci 0000:00:1d.1: BAR 4: can't allocate resource
[...]
pnp 00:08: io resource (0x10-0x1f) overlaps 0000:00:1d.0 BAR 4 (0x0-0x1f), disabling
pnp 00:08: io resource (0x10-0x1f) overlaps 0000:00:1d.1 BAR 4 (0x0-0x1f), disabling

It's never resulted in things not working, but it would still be nice if
it got solved. Please let me know if you'd like anything tested.

Cheers,
FJP
