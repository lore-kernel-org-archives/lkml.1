Return-Path: <linux-kernel-owner+w=401wt.eu-S1753993AbZHMSTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbZHMSTy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 14:19:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752065AbZHMSTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 14:19:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49675 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751383AbZHMSTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 14:19:53 -0400
Date: Thu, 13 Aug 2009 11:16:17 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Manuel Lauss <mano@roarinelk.homelinux.net>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Wilcox <willy@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrew Patterson <andrew.patterson@hp.com>
Subject: Re: [Regression] PCI resources allocation problem on HP nx6325
In-Reply-To: <20090811184740.49f52b57@scarran.roarinelk.net>
Message-ID: <alpine.LFD.2.01.0908131113580.28882@localhost.localdomain>
References: <200908021619.48285.rjw@sisk.pl> <alpine.LFD.2.01.0908020927410.3352@localhost.localdomain> <20090803165909.GA12824@roarinelk.homelinux.net> <alpine.LFD.2.01.0908041555120.3270@localhost.localdomain> <20090805155102.GA31646@roarinelk.homelinux.net>
 <alpine.LFD.2.01.0908050902300.3390@localhost.localdomain> <alpine.LFD.2.01.0908050931390.3390@localhost.localdomain> <20090805170934.GA32274@roarinelk.homelinux.net> <alpine.LFD.2.01.0908071051300.3390@localhost.localdomain> <alpine.LFD.2.01.0908071116520.3390@localhost.localdomain>
 <20090811184740.49f52b57@scarran.roarinelk.net>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 11 Aug 2009, Manuel Lauss wrote:
> 
> > So this patch is not something that I'm going to apply to my tree, but 
> > it's worth testing out to just verify that yes, I finally understand 
> > exactly what's going on. Because if I'm right, your warning will now go 
> > away (and it could be replaced by _other_ issues, of course ;).
> 
> The warning is gone, and /proc/iomem is identical to 2.6.30.
> I'd say you've hit the nail on the head ;)

Ok, thanks.

I'm not going to do anything about it right now, since clearly we've not 
changed any actual behavior from before. But if you remind me after 2.6.31 
is out, I'll look at perhaps making a better "pci_claim_resource()" that 
actually iterates over the different parent resources and doesn't just try 
to find one (and then fail if that particular one doesn't work out).

		Thanks,
			Linus
