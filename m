Return-Path: <linux-kernel-owner+w=401wt.eu-S1756319AbXLWEpL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319AbXLWEpL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 23:45:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754800AbXLWEo6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 23:44:58 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35853 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754099AbXLWEo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 23:44:57 -0500
Date: Sat, 22 Dec 2007 20:44:37 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a driver
 opt-in issue
In-Reply-To: <476DE19F.5040702@garzik.org>
Message-ID: <alpine.LFD.0.9999.0712222040520.21557@woody.linux-foundation.org>
References: <20071222043139.0cd59804@laptopd505.fenrus.org> <476D1D16.5090703@garzik.org> <20071222064719.73fdd9a4@laptopd505.fenrus.org> <alpine.LFD.0.9999.0712221003000.21557@woody.linux-foundation.org> <476DB95F.3090801@garzik.org>
 <alpine.LFD.0.9999.0712221939570.21557@woody.linux-foundation.org> <476DE07A.4000204@garzik.org> <476DE19F.5040702@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 22 Dec 2007, Jeff Garzik wrote:
>
> Jeff Garzik wrote:
> > Maybe that day will never come, but it is nonetheless quite possible without
> > today's PCI Express spec for this to happen.
> 
> er, s/without/within/

You're talking specs. I'm talking machines.

I agree with you 100% that as per specs, you need to support MMCONFIG, 
because anything can happen.

As per *reality*, though, machines sold today simply don't need it. So 
there is no upside, and there is definitely downside.

I want to limit that downside. Right now, the easiest way to limit it 
seems to be to say that those (very very few) drivers that actually care 
could enable it. That way, we automatically limit it to only those 
machines that have hardware that cares.

And yes, if you want the capability following to notice automatically when 
capabilities really do go into the 0x100+ range, that's fine. I suspect 
that there aren't really very many cards that do that (because they 
wouldn't work with WinXP etc), so I doubt it will actually enable MMCONFIG 
for any noticeable amount of hardware sold today. Which is exactly what I 
want. I do *not* want to enable MMCONFIG unless it is shown to actually be 
needed.

And no, "specs" do not show it is needed. MMCONFIG is needed depending on 
the actual *hardware* the kernel runs on, not based on some external 
specs.

		Linus
