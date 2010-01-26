Return-Path: <linux-kernel-owner+w=401wt.eu-S1754768Ab0AZSXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab0AZSXO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 13:23:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754726Ab0AZSXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 13:23:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:56307 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753995Ab0AZSXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 13:23:12 -0500
Message-ID: <4B5F32A9.7090105@kernel.org>
Date: Tue, 26 Jan 2010 10:21:29 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jeff Garrett <jeff@jgarrett.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Myron Stowe <myron.stowe@hp.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #15124] PCI host bridge windows ignored (works with pci=use_crs)
References: <md-TZL3UUvL.A.FiE.xJMXLB@chimera> <20100126071912.GA7543@jgarrett.org> <201001261348.59508.rjw@sisk.pl> <201001261032.37053.bjorn.helgaas@hp.com> <alpine.LFD.2.00.1001260955060.3574@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1001260955060.3574@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2010 10:16 AM, Linus Torvalds wrote:
> 
> 
> On Tue, 26 Jan 2010, Bjorn Helgaas wrote:
>>
>> which IS big enough, and we know the bridge is in fact forwarding the
>> [mem 0xd0000000-0xdfffffff 64bit pref] region, because the Radeon works
>> when Jeff boots with "pci=use_crs".
> 
> I bet it's a subtractive decode thing. Sure, it could be just another 
> undocumented range register (does anybody have the datasheet for that 
> thing?) but Intel tends to often have subtractive decode.
> 
> That system in question has three PCI express root ports, but two of them 
> have IO and memory disabled according to the lspci info. So maybe it's as 
> simple as that "I/O Hub PCI Express Root Port 7" just catching anything 
> that nobody else does, and the single IOH host chip doing the same?
> 
>> I think we should remove intel_bus.c before .33.  It's breaking boxes
>> and we don't know how to fix it.  Even if we do find out how to fix it,
>> I think we should move toward using _CRS instead, because that's what
>> Windows uses and it's an easy way for the firmware to tell us about
>> platform quirks.
> 
> I suspect that for 33 it is indeed best to just revert. But somebody is 
> bound to have information on how the actual hardware works. Yinghai?

I have asked intel if there is any bit that could be enabled the routing.
there is no info about for their documentations.

Yinghai
