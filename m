Return-Path: <linux-kernel-owner+w=401wt.eu-S1755366AbXIYOgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366AbXIYOgQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 10:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752370AbXIYOgA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 10:36:00 -0400
Received: from www.osadl.org ([213.239.205.134]:60974 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751468AbXIYOf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 10:35:59 -0400
Subject: Re: 2.6.23-rc8-mm1, -rc7-mm1 kill audio on HP nx6325
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Takashi Iwai <tiwai@suse.de>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200709251629.46493.rjw@sisk.pl>
References: <200709251408.54361.rjw@sisk.pl>
	 <200709251520.09794.rjw@sisk.pl> <1190727843.4035.345.camel@chaos>
	 <200709251629.46493.rjw@sisk.pl>
Content-Type: text/plain
Date: Tue, 25 Sep 2007 16:35:52 +0200
Message-Id: <1190730952.17409.1.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-25 at 16:29 +0200, Rafael J. Wysocki wrote: 
> > > lookup failed for 18446604438082158592
> > > [--snipped some USB messages--]
> > > ALSA /home/rafael/src/mm/linux-2.6.23-rc8-mm1/sound/pci/hda/hda_intel.c:1756: hda-intel: ioremap error: 2349334528 16384
> > 
> > Stupid me, hex formatting would have been easier to read :)
> > 
> > Lookup failed for 0xFFFF 8100 8C08 0000
> > ioremap:          0x0000 0000 8C08 0000 length 16384
> > 
> > It seems, that this patch only reveals some other wreckage. The code is
> > called as part of ioremap, where it adjusts the caching attributes of
> > the mapping, which was setup right before change_page_attr_address() is
> > called.
> 
> Hm, it looks like the first address is a kernel one and the second one is
> physical, so they apparently match, which means that the lookup shouldn't fail,
> if I understand this correctly.

Yes, the lookup address is virtual and it should be the one, which was
mapped right before the call to change_page_attr_address(). I'm looking
into that right now.

	tglx


