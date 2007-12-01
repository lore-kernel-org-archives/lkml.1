Return-Path: <linux-kernel-owner+w=401wt.eu-S1761129AbXLABEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761129AbXLABEg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 20:04:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758669AbXLABEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 20:04:15 -0500
Received: from pip9.gyao.ne.jp ([61.122.117.247]:49693 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760795AbXLABEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 20:04:13 -0500
Date: Sat, 1 Dec 2007 10:03:50 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: davem@davemloft.net, wli@holomorphy.com, mingo@redhat.com,
       ralf@linux-mips.org, linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: use of fixmap on non-x86/sh?
Message-ID: <20071201010350.GA15027@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Kumar Gala <galak@kernel.crashing.org>, davem@davemloft.net,
	wli@holomorphy.com, mingo@redhat.com, ralf@linux-mips.org,
	linux-kernel@vger.kernel.org,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <D16EA8BE-3C87-4345-8832-AB6112EE0FEA@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D16EA8BE-3C87-4345-8832-AB6112EE0FEA@kernel.crashing.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2007 at 04:14:55PM -0600, Kumar Gala wrote:
> Ben and I are talking about using fixmap on ppc for similar  
> applications to it use on x86.  However in poking around other arch's  
> (sparc, mips) they appear to have some support but not as complete as  
> x86.
> 
> For example both SPARC & MIPS reference __set_fixmap() in asm/fixmap.h  
> but I can't find an implementation on either.
> 
That's probably because people got lazy with copying around the
definitions -- perhaps surprisingly this happens quite frequently in arch
headers ;-)

MIPS has a fixrange_init() which does things in more or less one shot.
__set_fixmap() is a good abstraction if you're interested in poking at
individual fixmaps, but at least the kmap fixmaps have special handling all
over the place (look for kmap_pte in the various highmem implementations),
and there are few fixmaps otherwise.

> So I was wondering if there was some reason fixmap isn't as well  
> supported or if its just used for a specific function on those SPARC,  
> MIPS, etc. and they dont need as much functionality out of it as x86  
> does.
> 
There are of course things that make this more attractive on x86,
especially with regards to the global bit and preservation across a TLB
flush, there's a note in arch/sh/mm/init.c above __set_fixmap() about
that. fixmap doesn't really have any special behaviour that makes an
architecture implementation problematic at least.
