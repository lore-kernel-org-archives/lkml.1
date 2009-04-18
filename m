Return-Path: <linux-kernel-owner+w=401wt.eu-S1759491AbZDRUNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759491AbZDRUNT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 16:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755228AbZDRUND
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 16:13:03 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:55340 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654AbZDRUNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 16:13:01 -0400
Date: Sun, 19 Apr 2009 00:13:17 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Subject: Re: [PATCH] x86/pci: make pci_mem_start to be aligned only -v4
Message-ID: <20090418201317.GB23229@jurassic.park.msu.ru>
References: <alpine.LFD.2.00.0904160938090.4042@localhost.localdomain> <20090416165640.GA13927@elte.hu> <49E76864.9060309@kernel.org> <20090416172803.GB16618@elte.hu> <49E7916C.7050701@kernel.org> <alpine.LFD.2.00.0904161540590.4042@localhost.localdomain> <49E99054.6050208@kernel.org> <20090418092216.GP7678@elte.hu> <alpine.LFD.2.00.0904181151230.4042@localhost.localdomain> <20090418191425.GA19565@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090418191425.GA19565@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 18, 2009 at 09:14:25PM +0200, Ingo Molnar wrote:
> This way we intentionally create a 'free physical address space' 
> hole space that is the same as the rounding logic. No rounding 
> needed anywhere - as all the remaining address space is well-rounded 
> already. Plus we'd also _see_ all our rounding logic by looking at 
> the '(guard)' entries.
> 
> Or maybe there's some aspect of gap-rounding that cannot be 
> expressed in such a static way?

My gut feeling is that you guys do overcomplicate a simple issue
which can be fixed with a one-liner like this:

	pci_mem_start = pci_mem_start < 0xc0000000 ? : 0xc0000000;

This 0xc0000000 (3G) seems to be a pretty fundamental thing for certain
32-bit OS. ;-)

Ivan.
