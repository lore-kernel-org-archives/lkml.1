Return-Path: <linux-kernel-owner+w=401wt.eu-S1756187AbZBEEGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187AbZBEEGw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 23:06:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753111AbZBEEGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 23:06:42 -0500
Received: from gate.crashing.org ([63.228.1.57]:39310 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752372AbZBEEGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 23:06:41 -0500
Subject: Re: [PATCH 3/7] PCI PM: Fix saving of device state in
 pci_legacy_suspend
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: michael@ellerman.id.au
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, rjw@sisk.pl, jbarnes@virtuousgeek.org,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
In-Reply-To: <1233802690.15714.25.camel@localhost>
References: <200902040154.36018.rjw@sisk.pl>
	 <200902040159.10258.rjw@sisk.pl> <200902040159.10258.rjw@sisk.pl>
	 <1233712613.16867.136.camel@pasglop> <200902041115.00842.elendil@planet.nl>
	 <1233783502.4612.7.camel@pasglop>
	 <alpine.LFD.2.00.0902041355320.3247@localhost.localdomain>
	 <1233794410.4612.34.camel@pasglop>  <1233795431.15714.13.camel@localhost>
	 <1233797363.4612.49.camel@pasglop>  <1233802690.15714.25.camel@localhost>
Content-Type: text/plain
Date: Thu, 05 Feb 2009 15:06:10 +1100
Message-Id: <1233806770.4612.68.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Well I'm glad you listened to me when I told you not to fire off a rant
> email before I had another look at it ;)
> 
> Because Arjan has patched the generic bug.h so that we at least get the
> printk on powerpc, and then use our version of __WARN().

Right. A deep breath later or two ... the current upstream code in
pci-driver.c doesn't have a message, which is why I didn't see it. The
-new- code from Rafael does, and it would work thanks to Arjan fix. Now
I should indeed stop listening to you telling me it's broken before I
get a chance to verify it :-)

> As far as the code gen, with gcc 4.3.1 (debian).

 .../...

> So it's jumping over the if body, rather than moving it out of the
> straight line. It is hinting it right, so we should check if that helps
> us at all.

Right, gcc is full of sh*t as usual. Now try replacing the magic trap
which we still use in there, with a normal C function call (ie branch
out of line), see if it makes a difference. The trap statement uses an
inline asm statement and I know for a fact that the mere existence of
such a thing will make gcc already dubious idea of whether to go out of
line or not completely bonkers.

Cheers,
Ben.


