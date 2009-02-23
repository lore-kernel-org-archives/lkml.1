Return-Path: <linux-kernel-owner+w=401wt.eu-S1754389AbZBWDvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389AbZBWDvF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 22:51:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751517AbZBWDuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 22:50:54 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48601 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751379AbZBWDux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 22:50:53 -0500
Date: Sun, 22 Feb 2009 19:50:19 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: George Rapp <george.rapp@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: pci 0000:01:00.0: BAR 0: can't allocate resource
In-Reply-To: <f1f3dd8f0902221910n2722b024pe3ec8748fd3aed5b@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0902221941510.3111@localhost.localdomain>
References: <f1f3dd8f0902221910n2722b024pe3ec8748fd3aed5b@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 22 Feb 2009, George Rapp wrote:
> 
> In case the attachments don't survive Gmail, dmesg output is at
> http://novia.net/~gwr/dmesg_2.6.29-0.33.rc5, and output of 'lspci -vv' is at
> http://novia.net/~gwr/lspci-vv_2.6.29-0.33.rc5

Can you also show the contents of /proc/iomem?

It does look like it's this one:

	pci 0000:01:00.0: BAR 0: can't allocate mem resource [0xe0000000-0xe7ffffff]

and the problem is that the kernel cannot find enough space to map the 
required 128MB region for the graphics aperture.

Which is really odd, because the bridge to that PCI bus#1 is this:

	pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
	pci 0000:00:01.0:   IO window: 0x9000-0x9fff
	pci 0000:00:01.0:   MEM window: 0xf0000000-0xf1ffffff
	pci 0000:00:01.0:   PREFETCH window: 0x000000d8000000-0x000000e7ffffff

and that prefetch window is _huge_. Certainly big enough to fit BAR 0, but 
maybe there is something else in it.

		Linus
