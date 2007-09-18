Return-Path: <linux-kernel-owner+w=401wt.eu-S1758922AbXIRWht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758922AbXIRWht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 18:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753017AbXIRWhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 18:37:41 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37519 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753783AbXIRWhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 18:37:40 -0400
Date: Tue, 18 Sep 2007 15:36:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] Clarify pci_iomap() usage for MMIO-only devices
In-Reply-To: <1190154117.6403.127.camel@localhost.localdomain>
Message-ID: <alpine.LFD.0.999.0709181533370.16478@woody.linux-foundation.org>
References: <43e72e890709171322x76ab6b70xd29bf97e3643c553@mail.gmail.com> 
 <20070918113401.6a8a737f@the-village.bc.nu> 
 <43e72e890709181146s604e0f9fl8b0c16627469c77f@mail.gmail.com> 
 <alpine.LFD.0.999.0709181159440.16478@woody.linux-foundation.org> 
 <43e72e890709181207j7c85dc29sb355a9f5a4207411@mail.gmail.com> 
 <alpine.LFD.0.999.0709181219020.16478@woody.linux-foundation.org> 
 <43e72e890709181312sf2b421cn49be3389b3786a2a@mail.gmail.com> 
 <alpine.LFD.0.999.0709181323260.16478@woody.linux-foundation.org>
 <1190154117.6403.127.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 19 Sep 2007, Benjamin Herrenschmidt wrote:
> 
> Also, I've been told that modern x86 chipsets have the ability to remap
> IO space in the CPU physical address space. Is that true ? That would
> allow even x86 to get rid of the condition and just use some magic
> offset at map time.

I've not seen that, but I wouldn't be entirely surprised if IO 
virtualization eventually causes something like this to happen: 
virtualizing PIO is just damn painful right now, due to the lack of any 
way to remap it.

I *think* you may be confused with the PCI config cycles, where the new 
MMIO configuration was introduced (for similar virtualization reasons). 
But it's also possible that this is one of those undocumented areas and 
CPU's actually do have some IO remapping facility.

		Linus
