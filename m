Return-Path: <linux-kernel-owner+w=401wt.eu-S1754191AbXDPS0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191AbXDPS0o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 14:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754180AbXDPS0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 14:26:44 -0400
Received: from ns.suse.de ([195.135.220.2]:59248 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154AbXDPS0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 14:26:43 -0400
To: Mikko Tiihonen <mikko.tiihonen@iki.fi>
Cc: clemens@ladisch.de, bob.picco@hp.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] hpet: Enable hidden HPET on NVidia motherboards
References: <1176708094.22969.7.camel@dual.local>
From: Andi Kleen <andi@firstfloor.org>
Date: 16 Apr 2007 21:24:46 +0200
In-Reply-To: <1176708094.22969.7.camel@dual.local>
Message-ID: <p734png6s1t.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mikko Tiihonen <mikko.tiihonen@iki.fi> writes:

> It looks probable that most NVidia chipsets have the HPET address at
> 0x44. It might be possible to enable the HPET even if BIOS did not

That seems like a dangerous assumption. If anything this needs to  be keyed
on specific PCI IDs.

And the way you coded a recursive PCI scan is just .... <looking for words, censoring
some that come to mind first> ... not nice.

> initialize it properly by writing the wanted address there. Some other
> pci config space bits might need to be fiddled around too, most likely
> candidates are 0x74 bit 2 and 0xA3 bit ?. One or both of them have been
> identified to change in some motherboards when HPET is enabled/disabled
> in BIOS.

Or just add a random generator and poke random bits? Should be roughly
equivalent.

Also there should be done anything here without confirmation from
Nvidia that HPET is actually supposed to work. Sometimes hardware
is disabled by BIOS because it is seriously broken (there was at least
one other chipset that could corrupt your flash if you force enabled
HPET in some steppings) 

-Andi
 
