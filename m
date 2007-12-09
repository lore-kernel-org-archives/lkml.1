Return-Path: <linux-kernel-owner+w=401wt.eu-S1754723AbXLIAry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbXLIAry (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 19:47:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753085AbXLIArq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 19:47:46 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35112 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752945AbXLIArp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 19:47:45 -0500
Date: Sat, 8 Dec 2007 16:47:17 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Marco Gatti <marco@pianoinflames.de>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Bug: get EXT3-fs error Allocating block in system zone
In-Reply-To: <475B0AD7.10500@pianoinflames.de>
Message-ID: <alpine.LFD.0.9999.0712081644560.12046@woody.linux-foundation.org>
References: <4755BEA1.4090604@pianoinflames.de> <20071206162500.1f76a234.akpm@linux-foundation.org> <alpine.LFD.0.9999.0712061631510.13796@woody.linux-foundation.org> <475B0AD7.10500@pianoinflames.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 8 Dec 2007, Marco Gatti wrote:
> 
> Today, I tested with different amounts of RAM:
> 
> 2 GB: everything works fine
> 4 GB: same issue as described before with allocating block in system zone
> 
> So what to do, in order to use more than 2 Gigs of RAM?

Was there a dmesg out there somewhere?

With 4G of RAM, you probably have some of it above the 4GB mark (because 
of RAM remapping etc, and the PCI decode hole in the low 4GB). It does 
sound like this is a DMA problem, and your controller cannot correctly DMA 
to the upper 4GB.

So what controller/driver, what's the dmesg, and let's see if we can fix 
it by adding a DMA mask to it to limit it to the low 32 bits.

		Linus
