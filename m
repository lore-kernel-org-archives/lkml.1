Return-Path: <linux-kernel-owner+w=401wt.eu-S1755615AbYGSXIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615AbYGSXIp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 19:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753677AbYGSXIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 19:08:38 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63722 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753046AbYGSXIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 19:08:38 -0400
Date: Sun, 20 Jul 2008 00:08:23 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: warn on apic error
In-Reply-To: <20080719125907.GA30979@asus>
Message-ID: <Pine.LNX.4.55.0807192352030.19091@cliff.in.clinika.pl>
References: <20080718172821.GA4149@localhost.localdomain> <20080718174413.GD6897@asus>
 <19f34abd0807181045k239c81e8i1520291922909e93@mail.gmail.com>
 <20080718174931.GE6897@asus> <Pine.LNX.4.55.0807182005330.12125@cliff.in.clinika.pl>
 <20080719125907.GA30979@asus>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Jul 2008, Cyrill Gorcunov wrote:

> [Maciej W. Rozycki - Fri, Jul 18, 2008 at 08:09:20PM +0100]
> | On Fri, 18 Jul 2008, Cyrill Gorcunov wrote:
> | 
> | > iirc, they all were there (though some error codes are specific for
> | > particular processor classes like P4, pentium and other - don't remeber
> | > you could check intel dev manual for this).
> | 
> |  This is an error in some newer Intel documents -- the set of supported
> | bits is the same for all APICs implementing the ESR register and the error
> | interrupt (the 82489DX is the one to provide neither).
> | 
> |   Maciej
> |
> 
> But Maciej, Intel doesn't claim about absence of bit but
> rather about their 'reserved' state so checking the reserved
> bit could be false alarm if it was being set by some reason.

 As I say -- all later manuals have an error here (not the first and
presumably not the last one), where they state the invalid register error
has been only implemented since the P6.  This is not true -- go find the
Pentium manual or experiment with actual hardware to see otherwise.  No
new bits have been added since the introduction of the ESR, so there is no
issue with bits to mask out on older silicon.

 Obviously the checksum and accept error bits are valid for APICs using
the dedicated inter-APIC bus only as for the FSB they are irrelevant.  
They have to be hardwired to zero for backward compatibility though.

  Maciej
