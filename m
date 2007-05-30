Return-Path: <linux-kernel-owner+w=401wt.eu-S1762159AbXE3Wbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762159AbXE3Wbj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 18:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752888AbXE3WbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 18:31:13 -0400
Received: from terminus.zytor.com ([192.83.249.54]:38870 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657AbXE3WbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 18:31:11 -0400
Message-ID: <465DFB25.4070009@zytor.com>
Date: Wed, 30 May 2007 15:31:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Dave Airlie <airlied@gmail.com>, Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: GFP_DMA32 and PAE x86 machines
References: <21d7e9970705301410m16ded9esdf7a49371c60a155@mail.gmail.com> <465DECD7.8030104@zytor.com> <21d7e9970705301507o2a89e824xdc6a980e8dbedaaf@mail.gmail.com> <200705310024.25937.ak@suse.de>
In-Reply-To: <200705310024.25937.ak@suse.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Thursday 31 May 2007 00:07:45 Dave Airlie wrote:
>> Depending on split all lowmem is below 1GB which isn't exactly
>> optimal, I'd llike all 4GB for DMA.
> 
> Well it would be for a quite specialized limited use case: 
> - Memory the kernel doesn't need to map (after all kmap is evil) 
> - You need more than 500MB or so.
> - 32bit kernel and user cannot run 64bit kernel
> - Machine has >3GB of RAM 

There aren't really a whole lot of 32-bit boxen with > 4 GB of RAM (for
4 GB or less -- 2-3 GB or less if the chipset supports remapping --
normal HIGHMEM is all in the required area), and the few that are tend
to be running specialized applications (git.kernel.org is one of those
machines.)

Since it appears that legacy memory standards, SDRAM and DDR-1, aren't
dropping in price like DDR-2 is, I suspect that will more or less remain
that way.

The other problem -- which is a problem in general -- is the
proliferation of DMA masks, and that doesn't look like it's going to get
any better.

	-hpa
