Return-Path: <linux-kernel-owner+w=401wt.eu-S1755213AbXFDUcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213AbXFDUcQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 16:32:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751994AbXFDUcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 16:32:00 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:51723 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbXFDUcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 16:32:00 -0400
Date: Mon, 4 Jun 2007 22:31:58 +0200
From: Andreas Mohr <andi@rhlx01.hs-esslingen.de>
To: Antonio Mignolli <antoniomignolli@gmail.com>
Cc: linux-kernel@vger.kernel.org, Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: lid switch hangs notebook
Message-ID: <20070604203158.GB8456@rhlx01.hs-esslingen.de>
References: <a790ea7a0703120753i232ace2bg7272fa479b821e32@mail.gmail.com> <20070315110606.741c2dc4.akpm@linux-foundation.org> <200704131553.54787.bjorn.helgaas@hp.com> <a790ea7a0706040357g799e8756ue758e95d5b460307@mail.gmail.com> <20070604185719.GA25527@rhlx01.hs-esslingen.de> <a790ea7a0706041326h7bf1bc77kf4db7ac48b8ab209@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a790ea7a0706041326h7bf1bc77kf4db7ac48b8ab209@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-Priority: none
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jun 04, 2007 at 10:26:05PM +0200, Antonio Mignolli wrote:
> Interesting...
> The lid problem was solved, but many others arised.
> I don't remember what lapic is, I didn't put the lapic on kernel
> command line, but it seemed to be active by default:
> # find /sys -name "*lapic*"
> /sys/devices/system/lapic_nmi
> /sys/devices/system/lapic_nmi/lapic_nmi0
> /sys/devices/system/lapic
> /sys/devices/system/lapic/lapic0
> 
> I put a "nolapic" in cmdline, and this time no hangs,
> even WITH acpi support in kernel, pressing the button
> a dozen of times (without nolapic it hanged after a couple of times).

Just sounds like local APIC issues are really wide-spread then ;)
I'm really wondering whether it's the kernel which is not doing enough here.
Too many BIOSes with issues, it seems.

> BUT:
> - Module b44 (broadcom network adapter) fails to load, giving,
>    with debug actived:
>    b44 0000:01:0e.0: Cannot find proper PCI device base address, aborting.

Known issue I think, b44 stuff was discussed on LKML very recently.

> - Alsa does not work

Hmm. Known issue, too, I think. ALSA stuff was... (c.f. above ;).

> ... No time for analyze other issues.
> 
> Thanks for helping,
> I'll take a look to lapic.

Maybe try pci=routeirq or some other useful parameters from
Documentation/kernel-parameters.txt.

And believe me that I'll take a HARD look at lapic stuff, too.

Andreas Mohr
