Return-Path: <linux-kernel-owner+w=401wt.eu-S1764971AbXEVCD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764971AbXEVCD4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 22:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758803AbXEVCDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 22:03:49 -0400
Received: from outbound-mail-73.bluehost.com ([69.89.20.8]:41169 "HELO
	outbound-mail-73.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758761AbXEVCDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 22:03:48 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: System Design Works <wsherman@gmail.com>
Subject: Re: PCI device problem - MMCONFIG, cannot allocate resource region, resource collisions
Date: Mon, 21 May 2007 19:03:46 -0700
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, Ivan Kokshaysky <ink@jurassic.park.msu.ru>
References: <46524A6D.5050601@gmail.com>
In-Reply-To: <46524A6D.5050601@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705211903.46678.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 76.102.120.196 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 21, 2007, System Design Works wrote:
> The kernel has a problem allocating resources for my PCI NIC.  Here is
> what the kernel is reporting:
>
> # uname -a
> Linux wopr 2.6.20-gentoo-r8 #7 SMP Sun May 20 20:56:56 PDT 2007 i686 AMD
> Athlon(tm) 64 X2 Dual Core Processor 3800+ AuthenticAMD GNU/Linux
>
> # dmesg
> ...
> PCI: BIOS Bug:  MCFG area at e0000000 is not E820-reserved
> PCI: Not using MMCONFIG.

This is actually an unrelated problem.  We're a little too conservative 
about using MCFG space (though this turns out to be a good thing on some 
of my machines), but shouldn't affect the rest of your PCI resource 
assignment.

> ...
> PCI: Cannot allocate resource region 0 of device 0000:02:02.0
> ...
> PCI: Device 0000:02:02.0 not available because of resource collisions
> skge: 0000:02:02.0 cannot enable PCI device
> skge: probe of 0000:02:02.0 failed with error -22
> ...
>
> I have seen other posts reporting similar error messages.  I would like
> to help resolve this problem, and I can do some testing if needed.  More
> info:
>
> Kernel boot params:   pci=nomsi

There's a recent thread about PCI resource assignment (sounds like your 
BIOS might be buggy btw, or you're somehow running out of space), search 
for the title "PCI bridge range sizing bug".  You may need the kernel to 
reassign the resource for your NIC before you can use it.  I think Ivan 
has some test patches along these lines.

If you can find out what resource it's colliding with, that might give you 
a clue.

Jesse
