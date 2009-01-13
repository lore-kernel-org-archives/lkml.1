Return-Path: <linux-kernel-owner+w=401wt.eu-S1755404AbZAMDGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbZAMDGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 22:06:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751914AbZAMDGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 22:06:08 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51014 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751193AbZAMDGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 22:06:05 -0500
Date: Mon, 12 Jan 2009 19:05:06 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Connor Behan <connor.behan@gmail.com>
cc: Grant Grundler <grundler@parisc-linux.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Linux PCI <linux-pci@vger.kernel.org>, Gary Hade <garyhade@us.ibm.com>
Subject: Re: Can't allocate resources for PCI video card behind bridge
In-Reply-To: <496BFFAA.3000707@gmail.com>
Message-ID: <alpine.LFD.2.00.0901121856150.6528@localhost.localdomain>
References: <49665493.4070808@gmail.com> <200901082057.00170.rjw@sisk.pl> <200901081226.38909.jbarnes@virtuousgeek.org> <200901091530.58694.bjorn.helgaas@hp.com> <20090110200902.GA14664@colo.lackof.org> <496BFFAA.3000707@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 12 Jan 2009, Connor Behan wrote:
>
> I tried this patch but the kernel I'm using with that applied gives me the
> following dmesg: http://pastebin.com/f7a01c86 and the following lspci -vvv:
> http://pastebin.com/f3e473a13. Are there any other patches that claim to solve
> this?

As far as I can tell from the lspci, the only devices behind the docking 
bridge are

	0a:01.0 IDE interface: Silicon Image, Inc. PCI0648 (rev 01) (prog-if 8f [Master SecP SecO PriP PriO])
	0a:02.0 CardBus bridge: Texas Instruments PCI1420 PC card Cardbus Controller
	0a:02.1 CardBus bridge: Texas Instruments PCI1420 PC card Cardbus Controller

and they all like they should work. Apparently exactly because the docking 
bridge is this one:

	00:04.0 PCI bridge: Texas Instruments PCI2032 PCI Docking Bridge (prog-if 01 [Subtractive decode])

and that bridge itself is already transparent, so the fact that we 
couldn't allocate any explicit windows for it really seems like it 
shouldn't matter.

> I know it can be solved without patches because of that one fluke
> attempt where it worked - I just had no way of knowing which options actually
> contributed to that success while it lasted. The only thing I remember about
> my dmesg output when I had this working was that it did NOT give the "can't
> allocate resource" errors for BARs 7, 8 and 9.

So those are the docking bridge resources, but if I understood correctly, 
what you have issues with is that you want a graphics card in the dock to 
work - and I can't even see it in the lspci output. I see this one:

	01:00.0 VGA compatible controller: ATI Technologies Inc Rage Mobility M3 AGP 2x (rev 02) (prog-if 00 [VGA controller])

but that is the built-in laptop graphics. You say that you have another 
graphics card that used to be at 02:00.0, but it's not showing up at ALL, 
so this is more than some random resource allocation issue - this is a 
device not even even being enumerated. That's very different - it implies 
that some bridge isn't turned on at all.

Can you do the dmesg and lspci for the kernel where this works?

		Linus
