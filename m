Return-Path: <linux-kernel-owner+w=401wt.eu-S1753354AbXL1XXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbXL1XXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 18:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbXL1XXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 18:23:09 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:43767 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262AbXL1XXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 18:23:08 -0500
Date: Sat, 29 Dec 2007 01:22:56 +0200
From: Adrian Bunk <bunk@kernel.org>
To: David Miller <davem@davemloft.net>,
       Martin Habets <errandir_news@mph.eclipse.co.uk>
Cc: m.kozlowski@tuxland.pl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: 2.6.24-rc6-mm1: some section mismatches on sparc64
Message-ID: <20071228232255.GB9105@does.not.exist>
References: <20071222233056.d652743e.akpm@linux-foundation.org> <200712261329.08313.m.kozlowski@tuxland.pl> <20071226.190504.20990618.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071226.190504.20990618.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 26, 2007 at 07:05:04PM -0800, David Miller wrote:
> From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
> Date: Wed, 26 Dec 2007 13:29:07 +0100
> 
> > WARNING: vmlinux.o(.text+0x46b04): Section mismatch: reference to .init.text:sun4v_ktsb_register (between 'smp_callin' and 'smp_fill_in_sib_core_maps')
> 
> Well known and I see them every build and so does everyone
> else on sparc64.
> 
> They are harmless and as time allows I try to find ways
> to get rid of them but it's very low priority.

At least the sunserial_console_match() one is an obvious Oops 
(EXPORT_SYMBOL of an __init function).

The comment in the description of
commit 58d784a5c754cd66ecd4791222162504d3c16c74 the warning was bogus    
is bullshit.

I'm not sure whether this might count as a 2.6.24-rc regression or 
whether 2.6.23 is simply differently but similarly broken (does anyone 
actually use the Sun console drivers modular?).

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

