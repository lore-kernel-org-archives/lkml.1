Return-Path: <linux-kernel-owner+w=401wt.eu-S1762500AbYEFNTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762500AbYEFNTm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 09:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751023AbYEFNTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 09:19:32 -0400
Received: from smtp1.wifiinternet.cz ([89.31.47.1]:50136 "EHLO
	bor.wifiinternet.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750992AbYEFNTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 09:19:31 -0400
Message-ID: <48205B0D.70202@seznam.cz>
Date: Tue, 06 May 2008 15:20:13 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Geert Uytterhoeven <geert@linux-m68k.org>, Michal Simek <monstr@seznam.cz>,
       John Williams <john.williams@petalogix.com>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       stephen.neuendorffer@xilinx.com, John.Linn@xilinx.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca
Subject: Re: [PATCH 36/56] microblaze_v2: dma support
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz> <48202AB6.4010201@seznam.cz> <Pine.LNX.4.64.0805061317120.10091@anakin> <200805061324.06282.arnd@arndb.de>
In-Reply-To: <200805061324.06282.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

here is proposed struct.

struct scatterlist {
      dma_addr_t      	dma_address;
      unsigned long	page_link;
#ifdef CONFIG_DEBUG_SG
      unsigned long	sg_magic;
#endif
      unsigned int    	length;
      unsigned int    	offset;
};

Is it OK now?

Michal


>>> struct scatterlist {
>>>       unsigned long page_link;
>>>       unsigned int    offset;
>>>       unsigned int    length;
>>>       dma_addr_t      dma_address;
>>> };
>> If unsigned long is 32-bit but dma_addr_t is 64-bit, there may be a gap
>> between length and dma_address.
>>
> 
> But moving dma_address to the front only has the effect to create implicit
> padding at the end of struct scatterlist, so you don't gain anything
> either way.
> 
> It's only an internal definition that can be changed at any time without
> breaking applications, so I wouldn't worry about it, and better leave
> it identical to the other architectures.
> 
> The one thing that should indeed be changed is the addition of
> 'unsigned long sg_magic' that is needed for CONFIG_DEBUG_SG.
> 
> 	Arnd <><

