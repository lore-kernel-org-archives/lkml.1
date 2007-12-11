Return-Path: <linux-kernel-owner+w=401wt.eu-S1754617AbXLKPyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbXLKPyx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 10:54:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751631AbXLKPyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 10:54:45 -0500
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:36227 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbXLKPyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 10:54:44 -0500
Message-ID: <475EB263.2050405@keyaccess.nl>
Date: Tue, 11 Dec 2007 16:53:07 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Paul Rolland <rol@as2917.net>
CC: David Newall <david@davidnewall.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Krzysztof Halasa <khc@pm.waw.pl>, Pavel Machek <pavel@ucw.cz>,
       Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "David P. Reed" <dpreed@reed.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
References: <475879CD.9080006@reed.com>	<p733auekcly.fsf@bingen.suse.de>	<20071207160439.71b7f46a@the-village.bc.nu>	<20071209125458.GB4381@ucw.cz>	<20071209165908.GA15910@one.firstfloor.org>	<20071209212513.GC24284@elf.ucw.cz>	<475CBDD7.5050602@keyaccess.nl>	<m3bq8y23de.fsf@maximus.localdomain>	<475DE37F.20706@davidnewall.com>	<475DE6F4.80702@zytor.com>	<475DEB23.1000304@davidnewall.com>	<20071211084059.3d03e11d@tux.DEF.witbe.net>	<475E5D4B.8020101@keyaccess.nl>	<475E7DC2.4060509@davidnewall.com>	<475E8D91.20201@keyaccess.nl>	<20071211143224.15900995@tux.DEF.witbe.net>	<475E9B9B.2050709@keyaccess.nl>	<475EACB8.7080608@keyaccess.nl> <20071211163706.2dc82275@tux.DEF.witbe.net>
In-Reply-To: <20071211163706.2dc82275@tux.DEF.witbe.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-12-07 16:37, Paul Rolland wrote:

Great, thanks for the quick replies.

That last one below especially is quite a bit more than 1. As said before, 
most hardware isn't in fact going to need anything but I suppose udelay(2) 
might be the "safer" replacement for the outb then...

> On Tue, 11 Dec 2007 16:28:56 +0100
> Rene Herman <rene.herman@keyaccess.nl> wrote:
> 
>> On 11-12-07 15:15, Rene Herman wrote:
>>
>>> On 11-12-07 14:32, Paul Rolland wrote:
>>>
>> This might be a bit more constant, I suppose. This serialises with cpuid. 
>> Don't see a difference locally, but perhaps you do.
> Well, yes, at least on the PIII and the Opteron... Core2 is still changing
> a lot...
> 
>> On a Duron 1300 with an actual ISA bus, "out" is between 1300 and 1600 for 
>> me and "in" between 1200 and 1500 with a few flukes above that which will I 
>> suppose be caused by the bus (ISA _or_ PCI) being momentarily busy or some 
>> such...

> The results :
> 
> Core 2Duo 1.73 GHz :
> [root@tux tmp]# ./in2
> out: 2777
> in : 2519
> [root@tux tmp]# ./in2
> out: 2440
> in : 2391
> [root@tux tmp]# ./in2
> out: 2460
> in : 2388

Okayish I guess, especially when subsequent runs stay near those values.

2500/1730 = 1.45 us

> Pentium III :
> [root@www-dev /tmp]# ./in2
> out: 746
> in : 747
> [root@www-dev /tmp]# ./in2
> out: 746
> in : 747
> [root@www-dev /tmp]# ./in2
> out: 746
> in : 745

746/600 ~= 1.24 us

> AMD Opteron 150 :
> -bash-3.1# ./in2
> out: 4846
> in : 4845
> -bash-3.1# ./in2
> out: 4846
> in : 4846
> -bash-3.1# ./in2
> out: 4846
> in : 4845

4846 / 2400 = 2.02 us

Rene.

