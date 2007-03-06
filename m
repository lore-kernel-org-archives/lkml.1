Return-Path: <linux-kernel-owner+w=401wt.eu-S933686AbXCFAn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933686AbXCFAn1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 19:43:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933687AbXCFAn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 19:43:27 -0500
Received: from smtp.osdl.org ([65.172.181.24]:43163 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933686AbXCFAn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 19:43:26 -0500
Date: Mon, 5 Mar 2007 16:38:22 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Emil Karlson <jkarlson@cc.hut.fi>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>, Ingo Molnar <mingo@elte.hu>,
       Soeren Sonnenburg <kernel@nn7.de>, Len Brown <lenb@kernel.org>
Subject: Re: [5/6] 2.6.21-rc2: known regressions
In-Reply-To: <Pine.LNX.4.64.0703051542030.3998@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0703051626490.3998@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> 
 <20070305015040.GJ3441@stusta.de> <1173138193.24738.236.camel@localhost.localdomain>
 <Pine.LNX.4.64.0703051542030.3998@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 Mar 2007, Linus Torvalds wrote:
> On Tue, 6 Mar 2007, Thomas Gleixner wrote:
> > > 
> > > Subject    : macbook pro suspend to ram broken  (clockevents)
> > > References : http://lkml.org/lkml/2007/3/4/110
> > > Submitter  : Soeren Sonnenburg <kernel@nn7.de>
> > > Caused-By  : Thomas Gleixner <tglx@linutronix.de>
> > >              commit e9e2cdb412412326c4827fc78ba27f410d837e6e
> > > Status     : unknown
> > 
> > I can reproduce this on my dual core VAIO. There are some issues:
> 
> Yeah, I think I can too, on my dual-core Mac Mini. 
> 
> I'm not done with my bisection, but e9e2cdb4 is among the 28 commits left, 
> so I'm pretty sure I'm hitting the same bug. I'll do a few more bootups to 
> be 100% sure.

Ok, it's in the last six candidates, so yeah, I'm pretty sure. I'll do a 
final compile/boot cycle to verify, but if you don't hear from me, you can 
pretty much assume that was it.

Thomas, Ingo, I'd _really_ like to get -rc3 out there, but I'd like to cut 
down the regression list a bit, and a number of them were about resume 
from RAM, and this is probably it. So I'd *really* like to get this one 
nailed, especially since the causing commit is known. Can you look at it 
as a high-priority thing, please?

I don't see anything interesting in my logs.

	..
	Time: acpi_pm clocksource has been installed.
	Real Time Clock Driver v1.12ac
	hpet_acpi_add: no address or irqs in _CRS
	..

(I also see "Time: tsc clocksource has been installed." on some boots)

		Linus

