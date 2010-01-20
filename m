Return-Path: <linux-kernel-owner+w=401wt.eu-S1752972Ab0ATLTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972Ab0ATLTx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 06:19:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588Ab0ATLTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 06:19:50 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:54057 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420Ab0ATLTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 06:19:49 -0500
Message-ID: <4B56E66C.50004@monstr.eu>
Date: Wed, 20 Jan 2010 12:18:04 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: linux-kernel@vger.kernel.org, michal.simek@petalogix.com, arnd@arndb.de,
       linux-arch@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: Generic DMA - BUG_ON
References: <1263982111-24123-1-git-send-email-monstr@monstr.eu> <20100120105350.GA23394@flint.arm.linux.org.uk> <20100120110031.GD8665@amd.com>
In-Reply-To: <20100120110031.GD8665@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel wrote:
> On Wed, Jan 20, 2010 at 10:53:50AM +0000, Russell King wrote:
>> and ops is NULL, then this code will oops; you will get a full register
>> dump and backtrace.  You can use this information along with markup_oops.pl
>> to find out where the problem is.
> 
> You can't rely on the oops if the code runs in process context. The
> process may have address 0 mapped which would result in a security hole.
> We had two of these bugs last year.

That's the same problem which I had some days ago and Microblaze misses 
valuable backtrace (because we don't have FP or constant frame size).

> 
> But I don't see any point in checking for dma_ops != NULL too. Any
> developer would mention such a bug long before init is started.

I agree that checking adds extra cycles to every dma-api call.

I like as wrote Russel to check if ops exists or not.

Let's look at code which is there.
dma_map_single_attrs - calls ops->map_page without any checking
The same for dma_map_sg_attrs, dma_map_page

The rest of functions is ok. If any checking will be there, I don't have 
any problem with it.

Michal




> 
> 	Joerg
> 
> 


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
