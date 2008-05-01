Return-Path: <linux-kernel-owner+w=401wt.eu-S1765701AbYEAULv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765701AbYEAULv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 16:11:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758334AbYEAULo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 16:11:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37344 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164AbYEAULn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 16:11:43 -0400
Message-ID: <481A23DE.6070905@zytor.com>
Date: Thu, 01 May 2008 13:11:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, TJ <linux@tjworld.net>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Why such a big difference in init-time PCI resource call-paths
 (x86 vs x86_64) ?
References: <1209571638.25051.54.camel@hephaestion.lan.tjworld.net> <200805011116.31782.jbarnes@virtuousgeek.org> <20080501201111.GO20451@one.firstfloor.org>
In-Reply-To: <20080501201111.GO20451@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Thu, May 01, 2008 at 11:16:31AM -0700, Jesse Barnes wrote:
>> On Wednesday, April 30, 2008 9:07 am TJ wrote:
>>> In preparation for writing a Windows-style PCI resource allocation
>>> strategy
>>>
>>>  - use all e820 gaps for IOMEM resources; top-down allocation -
>>>
>>> and thus giving devices with large IOMEM requirements more chance of
>>> allocation in the 32-bit address space below 4GB (see bugzilla #10461),
> 
> I tried that some time ago and it turned out that some systems have
> mappings in holes and don't boot anymore when you fill the holes too much. 
> But that was only considering e820. if you do this it might work if you 
> do it really like windows and consider all resources, including ACPI.

Yes, considering all possible reservation schemes is really critical 
here (including the magic knowledge of the legacy region).

>>> So, why the big difference in implementations?
>>> What are the implications of each?
>>> Is one preferable to the other?
> 
> I don't remember why it is different. Probably wasn't intentional.
> But in general x86-64 is less fragile than i386 here because it has the e820
> allocator and can deal better with conflicts.

Yes, and that's definitely the model we want on both sides.  Working on 
this is way high on my personal priority list at the moment.

	-hpa

