Return-Path: <linux-kernel-owner+w=401wt.eu-S1758120AbYDSKow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758120AbYDSKow (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 06:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753508AbYDSKop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 06:44:45 -0400
Received: from smtp1.wifiinternet.cz ([89.31.47.1]:63463 "EHLO
	bor.wifiinternet.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753477AbYDSKon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 06:44:43 -0400
Message-ID: <4809CBA7.1090508@seznam.cz>
Date: Sat, 19 Apr 2008 12:38:31 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: microblaze-uclinux@itee.uq.edu.au
CC: Arnd Bergmann <arnd@arndb.de>, John Williams <john.williams@petalogix.com>,
       jwboyer@linux.vnet.ibm.com, benh@kernel.crashing.org,
       John Linn <linnj@xilinx.com>, git-dev <git-dev@xilinx.com>,
       Grant Likely <grant.likely@secretlab.ca>, git <git@xilinx.com>,
       linux-kernel@vger.kernel.org, paulus@samba.org
Subject: Re: [microblaze-uclinux] Re: Microblaze Linux release
References: <48020A21.4000404@seznam.cz> <200804140538.30268.arnd@arndb.de> <200804140801.57464.arnd@arndb.de> <4804A59B.5040909@seznam.cz> <20080418175602.5E15E670052@mail81-sin.bigfish.com>
In-Reply-To: <20080418175602.5E15E670052@mail81-sin.bigfish.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve

>>> * the consistent.c implementation looks strange. Is any of that code
>>> even used anywhere? What is it good for, considering that you don't
> have
>>> an mmu?
>> We have prepared MMU code. I hope that this code for FDT kernel comes
> soon.
>> This code is written by John Williams. I have never changed it. I see
> that this
>> code solves problems around ucached_shadows stuff.
>>
> http://developer.petalogix.com/wiki/UserGuide/AdvancedTopics/EnablingUnc
> achedShadow
>> JW. Can you comment this?
> 
> It probably makes sense to grab: arch/microblaze/mm/dma-coherent.c from
> git.xilinx.com and drop consistent.c.  I believe this is the more
> 'modern' way to implement this functionality.  I think it's easiest for
> you to just grab this file.

I'll look at it.

>>> * Your dma_mapping.h does BUG() for almost everything. I suspect you
> could
>>> easily replace it with a trivial implementation, like the x86_32
> one.
>> OK. I'll synchronize this.
> 
> This is also in git.xilinx.com.

ok.

>>> * You don't seem to have any code for PCI, so the pci.h and
> pci-bridge.h
>>> files don't make much sense.
>> Yes you are right. I don't have any PCI code but I think that this
> code for MB
>> exists. Steve or John: Do you have any code for PCI?
> 
> I'd recommend dropping anything having to do with PCI: I don't know that
> there is much interest in it on microblaze.

I think I'll do it

> Other comments:
> 
> memset/memmove/memcpy are broken under gcc4.  There are fixed versions
> of this at git.xilinx.com.  Again, it's probably easiest if you just
> grab the files directly.

NO. I fixed it. The problem was different as wrote Jan Engelhardt in previous
email. Changes are in repository. You have in xilinx repository only byte copy
and huge if 1 else endif. This is not acceptable. That's only as my explanation.

> It would also be good to have irq_of_parse_and_map, which drivers will
> need.  I'll send you a patch for this one.

This parts of code is coming with uartlite driver.

Thanks for your comments,
Michal

