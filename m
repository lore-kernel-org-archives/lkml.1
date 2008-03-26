Return-Path: <linux-kernel-owner+w=401wt.eu-S1761457AbYCZANG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761457AbYCZANG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 20:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757557AbYCZAMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 20:12:55 -0400
Received: from ozlabs.org ([203.10.76.45]:48433 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756343AbYCZAMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 20:12:54 -0400
Subject: Re: ohci1394 problem (MMIO broken) (was 2.6.25-rc6-git6: Reported
	regressions from 2.6.24)
From: Benjamin Herrenschmidt <benh@ozlabs.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Thomas Meyer <thomas@m3y3r.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Myles Watson <mylesgw@gmail.com>
In-Reply-To: <86802c440803251703o3f46e6dct754c81eecb82dae1@mail.gmail.com>
References: <200803220259.48534.rjw@sisk.pl>
	 <47E5350D.101@s5r6.in-berlin.de> <47E540E7.7030108@m3y3r.de>
	 <47E54FA6.3060809@s5r6.in-berlin.de> <47E557D5.9020604@s5r6.in-berlin.de>
	 <alpine.LFD.1.00.0803221423060.3020@woody.linux-foundation.org>
	 <1206488005.10573.8.camel@pasglop>
	 <86802c440803251703o3f46e6dct754c81eecb82dae1@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 26 Mar 2008 11:12:01 +1100
Message-Id: <1206490321.10573.10.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-03-25 at 17:03 -0700, Yinghai Lu wrote:
> >  The good news is that I have done a patch to fix it, which has been
> >  in -mm for about a month:
> iomap-fix-64-bits-resources-on-32-bits.patch
> 
> does it support if size is 4G above, like 256G?

The patch just fixes pci_iomap to use resource_size_t, which fixes bugs
with MMIO addresses/size being cropped. It doesn't fix some limitations
we still, I think, have in the PCI code with 64 bits BARs on 32 bits
platforms (that we could, in fact, probably remove when resource_size_t
is 64 bits but we haven't done it yet, at least as far as I remember).

Ben.


