Return-Path: <linux-kernel-owner+w=401wt.eu-S1756899AbZDNVa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899AbZDNVa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 17:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754056AbZDNVau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 17:30:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53767 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605AbZDNVat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 17:30:49 -0400
Message-ID: <49E4FFBC.4040901@zytor.com>
Date: Tue, 14 Apr 2009 14:27:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, yannick.roehlly@free.fr
Subject: Re: [PATCH] x86/pci: make pci_mem_start to be aligned only
References: <bug-11103-13546@http.bugzilla.kernel.org/> <200904101913.n3AJDhMm018684@demeter.kernel.org> <49DFABCC.3070001@kernel.org> <49E00E9F.8030605@kernel.org> <49E4F6D6.6030709@kernel.org> <49E4F71F.10107@kernel.org> <alpine.LFD.2.00.0904141359020.18124@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904141359020.18124@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> The reason? We've definitely seen ACPI code or integrated graphics stuff 
> that steals a lot of memory at the end, which means that end-of-RAM might 
> be not at 2GB, but at 2GB-16MB-1MB, for example (1MB of "ACPI data", and 
> 16MB of "stolen video ram").

This is pretty much standard these days.  It's hard to implement ACPI 
without doing so.  Throw in the SMI T-seg for even more fun.

> Now, the BIOS _hopefully_ marks those areas clearly reserved, and as a 
> result we don't end up allocating PCI data in there, but the gap was there 
> literally to make sure we always leave that gap, very much on purpose.

It would be nice if we would mark that memory reserved ourselves.

> thing, so that if the gap is large, then we'll certainly get to 32MB too, 
> but I think your patch matters the most exactly when the gap is small. 
> Maybe we could just raise the initial minimum rounding from 1MB to 32MB?

Since we're talking about address space, not actual memory, it seems 
rather hard to end up in a situation where either one of these is not true:

- we will have real hardware demand for a large alignment datum.
- we will have so much address space available that it doesn't matter.

The latter case would be e.g. a machine with a today-anemic handful of 
megabytes of RAM.

	-hpa[1]

[1] who remembers running a Linux server on a 0.59 bogomips i386/16 with
     3 MB of half-speed memory...

