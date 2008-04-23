Return-Path: <linux-kernel-owner+w=401wt.eu-S1756229AbYDWVek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229AbYDWVek (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 17:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbYDWVed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 17:34:33 -0400
Received: from service2.sh.cvut.cz ([147.32.127.218]:57368 "EHLO
	service2.sh.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbYDWVeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 17:34:31 -0400
Message-ID: <480FABB6.10000@seznam.cz>
Date: Wed, 23 Apr 2008 23:35:50 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: benh@kernel.crashing.org
Cc: Arnd Bergmann <arnd@arndb.de>,
       Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       John Williams <john.williams@petalogix.com>, jwboyer@linux.vnet.ibm.com,
       John Linn <John.Linn@xilinx.com>, git-dev@xilinx.com,
       Grant Likely <grant.likely@secretlab.ca>, git@xilinx.com,
       microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org,
       paulus@samba.org
Subject: Re: Microblaze Linux release
References: <48020A21.4000404@seznam.cz> <200804140801.57464.arnd@arndb.de>	 <4804A59B.5040909@seznam.cz>  <200804151532.11619.arnd@arndb.de> <1208296358.6958.237.camel@pasglop>
In-Reply-To: <1208296358.6958.237.camel@pasglop>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


>> I'd recommend splitting prom.c into code that can be shared between powerpc
>> and microblaze and architecture specific code. Anything that deals with
>> LMB should go into powerpc, and you can simply use the alloc_bootmem
>> mechanism for your architecture.
> 
> That is non trivial... the unflatten DT code among others relies heavily
> on the LMB's to allocate the objects.
> 
> We could split the early accessors, unflatten code, and kernel-side
> accessors at one point, though we already did most of it no ?
> 
> Ben.

I look at latest LMB version currenty in lib folder. There is some changes which
I think go against version.

I would like to ask some question about.

in include/asm-powerpc/lmb.h is written LMB_REAL_LIMIT.

Is this real limit memory limit? Why I ask. I think powerpc start with main
memory from zero address and you can set your high limit from zero. In this case
is high limit equal to size of memory.

In Microblaze systems we don't have main memory from zero. Starting point can be
everywhere in 2^32.

I hope I can avoid in this constant in MB system and only direct start and size
mem with DTS description. Am I right?

The similar code was added to of files which are in arch/powerpc/kernel/ folder.
I would like to fix LMB and OF together.

I have some fixed around coding style violation. I'll send them ASAP.

I don't have any idea what files use Sparc. Can you inform me about? I don't
want to break something with MB port.

Thanks for info.

Regards,
Michal Simek
