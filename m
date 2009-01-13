Return-Path: <linux-kernel-owner+w=401wt.eu-S1756663AbZAMVhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663AbZAMVhX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 16:37:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754509AbZAMVhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 16:37:05 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44494 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754412AbZAMVhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 16:37:03 -0500
Date: Tue, 13 Jan 2009 13:35:44 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Connor Behan <connor.behan@gmail.com>
cc: Grant Grundler <grundler@parisc-linux.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Linux PCI <linux-pci@vger.kernel.org>, Gary Hade <garyhade@us.ibm.com>
Subject: Re: Can't allocate resources for PCI video card behind bridge
In-Reply-To: <496D0653.3040709@gmail.com>
Message-ID: <alpine.LFD.2.00.0901131331330.6528@localhost.localdomain>
References: <49665493.4070808@gmail.com> <200901082057.00170.rjw@sisk.pl> <200901081226.38909.jbarnes@virtuousgeek.org> <200901091530.58694.bjorn.helgaas@hp.com> <20090110200902.GA14664@colo.lackof.org> <496BFFAA.3000707@gmail.com>
 <alpine.LFD.2.00.0901121856150.6528@localhost.localdomain> <496D0653.3040709@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 13 Jan 2009, Connor Behan wrote:
>
> I was about to say that the kernel where this worked once doesn't allow this
> to work again. I downgraded to 2.6.27 and got the same problem. But then I
> also downgraded udev, mkinitcpio, lilo, device-mapper, pciutils and hwdetect
> and reset the defaults on my BIOS and took out pci=assign-busses and then the
> card started working.

Ok, can you now try to upgrade just the kernel? IOW, it would be good to 
try to figure out what it is that triggers this problem.

> dmesg: http://pastebin.com/m68dd0ce
> lspci: http://pastebin.com/m4c01d354

Yes, now I see a new bridge:

	08:00.0 PCI bridge: PLX Technology, Inc. PEX8112 x1 Lane PCI Express-to-PCI Bridge (rev aa) (prog-if 00 [Normal decode])

and behind this bridge is this:

	09:00.0 VGA compatible controller: ATI Technologies Inc RV505 [Radeon X1550 Series] (prog-if 00 [VGA controller])
	09:00.1 Display controller: ATI Technologies Inc RV505 [Radeon X1550 Series] (Secondary)

> It's quite a bit different from when I remember it working the other time. The
> errors on BARs 7, 8 and 9 still show up and the card is on bus 09.

Yup. It's all ok. 

> However after I did this I updated all those packages to the newest 
> versions except I did so one at a time not all at once. Now I'm up to 
> date and still have this card working. So I'm sorry to bother you with 
> this, the kernel does not need to be patched for this at all. It's 
> either a BIOS problem or a distro problem caused by updating too many 
> packages at once. Either way it's fixed now. Thanks alot.

Well, your dmesg is now from a 2.6.27 kernel, so I'd like to double-check 
and verify that upgrading the kernel really works now. It does sound like 
some non-kernel-related issue, but still..

		Linus
