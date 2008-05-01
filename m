Return-Path: <linux-kernel-owner+w=401wt.eu-S1765597AbYEAVMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765597AbYEAVMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 17:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757096AbYEAVMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 17:12:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52864 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756835AbYEAVMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 17:12:22 -0400
Message-ID: <481A3216.9030705@zytor.com>
Date: Thu, 01 May 2008 14:11:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Andi Kleen <andi@firstfloor.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, TJ <linux@tjworld.net>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Why such a big difference in init-time PCI resource call-paths
 (x86 vs x86_64) ?
References: <1209571638.25051.54.camel@hephaestion.lan.tjworld.net>	 <200805011116.31782.jbarnes@virtuousgeek.org>	 <20080501201111.GO20451@one.firstfloor.org> <86802c440805011410q17c24653l292ccb6dad211a06@mail.gmail.com>
In-Reply-To: <86802c440805011410q17c24653l292ccb6dad211a06@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Thu, May 1, 2008 at 1:11 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> On Thu, May 01, 2008 at 11:16:31AM -0700, Jesse Barnes wrote:
>>  > On Wednesday, April 30, 2008 9:07 am TJ wrote:
>>  > > In preparation for writing a Windows-style PCI resource allocation
>>  > > strategy
>>  > >
>>  > >  - use all e820 gaps for IOMEM resources; top-down allocation -
>>  > >
>>  > > and thus giving devices with large IOMEM requirements more chance of
>>  > > allocation in the 32-bit address space below 4GB (see bugzilla #10461),
>>
>>  I tried that some time ago and it turned out that some systems have
>>  mappings in holes and don't boot anymore when you fill the holes too much.
>>  But that was only considering e820. if you do this it might work if you
>>  do it really like windows and consider all resources, including ACPI.
> 
> wonder if using holes in MTRR AND e820 could help...
> 

Typically not, since the MTRRs won't tell you what is free address space 
and what is occupied by non-BAR I/O devices.

	-hpa
