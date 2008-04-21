Return-Path: <linux-kernel-owner+w=401wt.eu-S1761659AbYDUTlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761659AbYDUTlj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 15:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757331AbYDUTla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 15:41:30 -0400
Received: from one.firstfloor.org ([213.235.205.2]:40498 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756978AbYDUTl3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 15:41:29 -0400
Message-ID: <480CEDE5.3060008@firstfloor.org>
Date: Mon, 21 Apr 2008 21:41:25 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: linux-pci@atrey.karlin.mff.cuni.cz, Jean Delvare <jdelvare@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Tejun Heo <htejun@gmail.com>, Tom Long Nguyen <tom.l.nguyen@intel.com>,
       Randy Dunlap <rdunlap@xenotime.net>, Jeff Garzik <jgarzik@pobox.com>
Subject: Re: PCI MSI breaks when booting with nosmp
References: <200804172140.02311.jdelvare@suse.de> <200804211043.10410.jbarnes@virtuousgeek.org> <87d4oj6o9a.fsf@basil.nowhere.org> <200804211207.00961.jbarnes@virtuousgeek.org>
In-Reply-To: <200804211207.00961.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Monday, April 21, 2008 11:45 am Andi Kleen wrote:
>> Jesse Barnes <jbarnes@virtuousgeek.org> writes:
>>> Ok, I see this too on my desktop machine.  It looks like we're not
>>> getting interrupts setup correctly in the nosmp case.  Still digging
>>> through to see why though...
>> NoSMP disables the io-apic and a lot of modern systems don't work without
>> APIC.
>>
>> If you just want to run with a single cpu for testing etc. always use
>> maxcpus=1 (not 0, that will disable the APIC too)
> 
> Right...  but it looks like the MSI code is buggy when noapic is specified via 
> nosmp or maxcpus=0.  We should either fix it to work with noapic or disable 
> it like we do the ioapic when nosmp or maxcpus=0:

First that would likely not compile on architectures without PCI?

Also there is more code in the guts of arch/x86 that disables the
IO-APIC and likely has the same problem. Best probably you put it all
into a single function that does it all properly instead of continuning
to open code it.

Just don't break the other architectures in main.c

-Andi
