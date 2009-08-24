Return-Path: <linux-kernel-owner+w=401wt.eu-S1751122AbZHXBDF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751122AbZHXBDF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 21:03:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751101AbZHXBDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 21:03:04 -0400
Received: from verein.lst.de ([213.95.11.210]:53711 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080AbZHXBDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 21:03:03 -0400
Date: Mon, 24 Aug 2009 03:01:53 +0200
From: Christoph Hellwig <hch@lst.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Arnd Bergmann <arnd@arndb.de>, kyle@mcmartin.ca, rth@twiddle.net,
       ink@jurassic.park.msu.ru
Subject: Re: linux-next: powerpc tree build warning
Message-ID: <20090824010153.GB21533@lst.de>
References: <20090824102256.3e8d69b6.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090824102256.3e8d69b6.sfr@canb.auug.org.au>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 10:22:56AM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next build (powerpc ppc64_defconfig) produced this warning:
> 
> kernel/time/tick-sched.c: In function 'tick_nohz_stop_sched_tick':
> kernel/time/tick-sched.c:261: warning: format '%02x' expects type 'unsigned int', but argument 2 has type 'long unsigned int'
> 
> Introduced by commit 6826a57d1abc8ac9f59b24f1a008554c6560a995 ("powerpc:
> Switch to asm-generic/hardirq.h") which changed
> irq_cpustat_t::__softirq_pending from "unsigned int" to "unsigned long"
> on powerpc.

Hah, that's an interesting one.  In currently mainline the following
architectures have it as unsigned long:

	alpha, parisc and blackfin/microblaze via asm-generic

and all others have it as unsigned int.  For blackfin and microblaze
it obviously doesn't matter, so the question is why alpha and parisc
have it as usinged long.  We defintively should standardize on one,
and unless alpha and parisc have good reasons for needing a long
value that would be unsigned int.
