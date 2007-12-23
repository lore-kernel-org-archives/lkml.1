Return-Path: <linux-kernel-owner+w=401wt.eu-S1756167AbXLWEkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167AbXLWEkx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 23:40:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753355AbXLWEkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 23:40:46 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43836 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752688AbXLWEkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 23:40:45 -0500
Date: Sat, 22 Dec 2007 20:40:14 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeff Garzik <jeff@garzik.org>
cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [patch] Make MMCONFIG space (extended PCI config space) a driver
 opt-in issue
In-Reply-To: <476DE07A.4000204@garzik.org>
Message-ID: <alpine.LFD.0.9999.0712222036010.21557@woody.linux-foundation.org>
References: <20071222043139.0cd59804@laptopd505.fenrus.org> <476D1D16.5090703@garzik.org> <20071222064719.73fdd9a4@laptopd505.fenrus.org> <alpine.LFD.0.9999.0712221003000.21557@woody.linux-foundation.org> <476DB95F.3090801@garzik.org>
 <alpine.LFD.0.9999.0712221939570.21557@woody.linux-foundation.org> <476DE07A.4000204@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 22 Dec 2007, Jeff Garzik wrote:
> 
> It should be self-evident that mmconfig doesn't work on old hardware, is not
> needed on old hardware, should not be turned on for old hardware, and in
> general should never disturb old hardware.

.. but it does. How do you figure out when to turn it off?

By "old hardware" I don't mean stuff from the last century, that generally 
doesn't even *have* MMCONFIG. I mean the stuff you can buy *today*, which 
will be old by the time people really start _needing_ MMCONFIG.

The fact is, 99% of the hardware you buy *today* has absolutely zero need 
for extended PCI config access. In fact, I would not be surprised at all 
if most hardware sold today generally doesn't have *any* devices that even 
have config registers in the 0x100+ range.

So those are the kinds of machines we want to protect from blowing up. 
Stuff that isn't sold with Vista, and has never been tested (or where 
vista does some work-arounds we don't even know about - somebody was 
mentioning things like looking at the BIOS date etc).

			Linus
