Return-Path: <linux-kernel-owner+w=401wt.eu-S966237AbXEVP7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966237AbXEVP7P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 11:59:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758582AbXEVP65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 11:58:57 -0400
Received: from outbound-mail-36.bluehost.com ([69.89.20.190]:43779 "HELO
	outbound-mail-36.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965796AbXEVP64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 11:58:56 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Wayne Sherman <wsherman@gmail.com>
Subject: Re: PCI device problem - MMCONFIG, cannot allocate resource region, resource collisions
Date: Tue, 22 May 2007 08:58:51 -0700
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, Ivan Kokshaysky <ink@jurassic.park.msu.ru>
References: <46524A6D.5050601@gmail.com> <200705211903.46678.jbarnes@virtuousgeek.org> <46525710.7050803@gmail.com>
In-Reply-To: <46525710.7050803@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705220858.51604.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 21, 2007, Wayne Sherman wrote:
> Jesse Barnes wrote:
> > There's a recent thread about PCI resource assignment (sounds like
> > your BIOS might be buggy btw, or you're somehow running out of space),
> > search for the title "PCI bridge range sizing bug".  You may need the
> > kernel to reassign the resource for your NIC before you can use it.  I
> > think Ivan has some test patches along these lines.
> >
> > If you can find out what resource it's colliding with, that might give
> > you a clue.
>
> I don't have anything else plugged in to the PC (except a USB drive).
> BIOS is set to PNP OS.  How do I find out what it is colliding with?
>
> 02:02.0 Non-VGA unclassified device: D-Link System Inc Unknown device
> 4901 (rev 11)
> 	Subsystem: D-Link System Inc Unknown device 4901
> 	Flags: bus master, 66MHz, fast devsel, latency 64, IRQ 11
> 	Memory at <ignored> (32-bit, non-prefetchable)
> 	I/O ports at b800 [size=256]
> 	Expansion ROM at <ignored> [disabled]
> 	Capabilities: [48] Power Management version 2
> 	Capabilities: [50] Vital Product Data

Can you dump the memory BAR for this device?  I guess lspci hides it by 
default.  You may also be able to see it using 'od -t 
x4 /sys/devices/pci0000\:00/0000:02:02.0/config'.  I'm not sure how much 
that'll help though, you may be able to see which device its resources are 
overlapping with, but unless your BIOS gives you an option to disable it 
or change the way PCI space is allocated, you may be stuck...

Jesse
