Return-Path: <linux-kernel-owner+w=401wt.eu-S1752691AbZFOMjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbZFOMjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 08:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbZFOMjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 08:39:08 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:36979 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751474AbZFOMjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 08:39:07 -0400
X-Trace: 211543255/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.113.131/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.113.131
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnECAIfdNUpPRXGD/2dsb2JhbAAI03mEDQU
X-IronPort-AV: E=Sophos;i="4.42,222,1243810800"; 
   d="scan'208";a="211543255"
Date: Mon, 15 Jun 2009 13:38:12 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Nick Piggin <npiggin@suse.de>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, cl@linux-foundation.org,
       kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, mingo@elte.hu,
       yinghai@kernel.org
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
In-Reply-To: <20090615112355.GB6012@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0906151329310.24256@sister.anvils>
References: <Pine.LNX.4.64.0906121624280.2937@melkki.cs.Helsinki.FI>
 <Pine.LNX.4.64.0906121859420.5963@melkki.cs.Helsinki.FI>
 <20090615081831.GA5411@osiris.boeblingen.de.ibm.com>
 <84144f020906150210w7fa29042xc12efb4a087e3d26@mail.gmail.com>
 <20090615094148.GC1314@wotan.suse.de> <1245059476.12400.7.camel@pasglop>
 <1245059859.23207.16.camel@penberg-laptop> <20090615102737.GA20461@wotan.suse.de>
 <1245062727.12400.23.camel@pasglop> <20090615112355.GB6012@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jun 2009, Nick Piggin wrote:
> On Mon, Jun 15, 2009 at 08:45:27PM +1000, Benjamin Herrenschmidt wrote:
> > On Mon, 2009-06-15 at 12:27 +0200, Nick Piggin wrote:
> > > Init code doesn't deserve to be more lazy than anybody else, and
> > > part of the reason why such a core piece of code is so crufty
> > > is exactly because people have been lazy there.
> > 
> > I think the main problem isn't necessarily init code per se, but the
> > pile of -common- code that can be called both at init time and later.
> 
> Just seems bogus argument. Everwhere else that does this (ie.
> allocations that are called from multiple allocation contexts)
> passes correct gfp flags down.

Fair enough that you jealously defend SL?B code from onslaught, but
FWIW I strongly agree with Ben on all this.  I cannot see the point
of the pain of moving around SL?B versus bootmem, if we immediately
force such a distinction (differently dressed) upon their users again.
I fully agree with Ben that it's the job of the allocator to provide
a service, and part of that job to understand its own limitations at
different stages of running.

Hugh
