Return-Path: <linux-kernel-owner+w=401wt.eu-S1755975AbXLWDqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975AbXLWDqr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 22:46:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754166AbXLWDqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 22:46:39 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43166 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754016AbXLWDqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 22:46:39 -0500
Date: Sat, 22 Dec 2007 19:46:06 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a driver
 opt-in issue
In-Reply-To: <476DB95F.3090801@garzik.org>
Message-ID: <alpine.LFD.0.9999.0712221939570.21557@woody.linux-foundation.org>
References: <20071222043139.0cd59804@laptopd505.fenrus.org> <476D1D16.5090703@garzik.org> <20071222064719.73fdd9a4@laptopd505.fenrus.org> <alpine.LFD.0.9999.0712221003000.21557@woody.linux-foundation.org> <476DB95F.3090801@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 22 Dec 2007, Jeff Garzik wrote:
>
> I forcibly turn on mmconfig on all my machines, and monitor lkml, to make sure
> I'm aware of the extent of the problem -- and the extent of peoples'
> exaggeration of this problem.

Bullshit.

You have how many machines? Ten?

The problem is that it isn't enough that it works on common machines with 
good hardware. The problem is that we end up chasing insane bugs, wasting 
peoples valuable time and effort, on those *few* - out of *millions* - of 
machines that then surprisingly don't work.

And "surprisingly" is definitely the watch-word. That includes silently 
just not booting (because the first time anybody tries to do a PCI config 
cycle access, the machine just locks up) to some really *odd* behaviour 
(ie everything works fine *except* that reading the PCI card ID from a 
few cards returns a value of 0x0001 rather than the correct one).

The fact is, we're currently turning off MMCONFIG very aggressively, 
exactly because it has caused problems. So most people never even use 
MMCONFIG when it's enabled, because all of our sanity checks that turn it 
off again. And it still has caused odd problems.

> Regardless of whether a driver is loaded or not, you may NEED to see extended
> capabilities.  The system may NEED to see those capabilities just to parse
> them for sane operation.

And that's just not true.

I don't know why you even claim so. There is absolutely *zero* need for 
MMCONFIG for 100% of old hardware, and old hardware is exactly the 
problem. The hardware that people will run next year isn't the issue.

There may be an absolute need for MMCONFIG for future machines and future 
drivers, but there is not a single machine in existence today that really 
depends on it. You're just making things up. At worst, you lose some 
not-so-important error reporting, no more.

So don't go spreading obvious untruths,

			Linus
