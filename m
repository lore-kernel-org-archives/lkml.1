Return-Path: <linux-kernel-owner+w=401wt.eu-S1759925AbYGPXvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759925AbYGPXvR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 19:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753716AbYGPXvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 19:51:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33725 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752621AbYGPXvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 19:51:03 -0400
Date: Wed, 16 Jul 2008 16:50:33 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
cc: linux-kernel@vger.kernel.org,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [git pull] PCI pull request for 2.6.27
In-Reply-To: <200807161639.24289.jbarnes@virtuousgeek.org>
Message-ID: <alpine.LFD.1.10.0807161647470.2835@woody.linux-foundation.org>
References: <200807161639.24289.jbarnes@virtuousgeek.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 16 Jul 2008, Jesse Barnes wrote:
> 
> Miklos Vajna (1):
>       x86/PCI: janitor work in irq.c

Please don't take patches like this.

If it's janitor work, the end result should be better. But it's not. This 
patch is full of stuff like

-	for(addr = (u8 *) __va(0xf0000); addr < (u8 *) __va(0x100000); addr += 16) {
+	for (addr = (u8 *) __va(0xf0000); addr < (u8 *) __va(0x100000);
+		addr += 16) {
 		rt = pirq_check_routing_table(addr);

Which just brings negative value. The code is _harder_ to look at, not 
easier.

The 80-character limit is less important than making code look obvious and 
indentation being readable. Splitting the for(;;) loop just made the 
indentation look like total crap.

I'm fixing it up (since it also caused trivial conflicts), but I'd ask 
people to just ignore that sh*t-for-brains that is the long-line warning 
when trying to fix it may silence a warning, but results in worse code!

		Linus
