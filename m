Return-Path: <linux-kernel-owner+w=401wt.eu-S1754106AbXLMNOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbXLMNOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 08:14:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751759AbXLMNOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 08:14:00 -0500
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:50218 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbXLMNN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 08:13:59 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 216.15.117.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18gARDt+r01IyYEVtETsSMg
Message-ID: <47612FF9.8060402@reed.com>
Date: Thu, 13 Dec 2007 08:13:29 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.5) Gecko/20070727 Fedora/2.0.0.5-2.fc7 Thunderbird/2.0.0.5 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: David Newall <david@davidnewall.com>,
       Rene Herman <rene.herman@keyaccess.nl>, Paul Rolland <rol@as2917.net>,
       "H. Peter Anvin" <hpa@zytor.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Pavel Machek <pavel@ucw.cz>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
References: <475879CD.9080006@reed.com>	<p733auekcly.fsf@bingen.suse.de>	<20071207160439.71b7f46a@the-village.bc.nu>	<20071209125458.GB4381@ucw.cz>	<20071209165908.GA15910@one.firstfloor.org>	<20071209212513.GC24284@elf.ucw.cz>	<475CBDD7.5050602@keyaccess.nl>	<m3bq8y23de.fsf@maximus.localdomain>	<475DE37F.20706@davidnewall.com>	<475DE6F4.80702@zytor.com>	<475DEB23.1000304@davidnewall.com>	<20071211084059.3d03e11d@tux.DEF.witbe.net>	<475E5D4B.8020101@keyaccess.nl>	<475E7DC2.4060509@davidnewall.com>	<475E8D91.20201@keyaccess.nl>	<475E95A3.3070801@davidnewall.com>	<20071211142552.2ae6ea9a@the-village.bc.nu>	<47605E4B.6050904@davidnewall.com> <20071212230030.00511c3f@the-village.bc.nu>
In-Reply-To: <20071212230030.00511c3f@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Perhaps what was meant is that ISA-tuned timings make little sense on 
devices that are part of the chipset or on the PCI or PCI-X buses?

On the other hand, since we don't know in many cases whether the "_p" 
was supposed to mean "the time it takes to execute an "out al,80h" on 
whatever bus structure happens to be on whatever machine, the problem is 
unsolvable.

Ranting about whether ISA/LPC is on what machines seems to be of little 
value in contributing to a constructive solution.

It seems to me that in the long term, driver writers would do well to 
think more clearly about the timings their devices require, when that is 
possible.   They are probably implementation dependent - depending on 
the clock speed of the particular clock that is driving the particular 
i/o device.

Then there's the social problem of a community development project - 
which is to get people to tune their code but preserve its ability to 
run on older and variant machines.

Alan Cox wrote:
>> Yes, it's now clear that all of this is so.  Regrettably, it's used in 
>> dozens of drivers, most having nothing to do with an ISA/LPC bus.
>>
>> If it really is specific to the ISA architecture, then it should only be 
>> used in architecture specific code.
>>     
>
> ISA/LPC is not architecture specific. In fact ISA/LPC bus components get
> everywhere because the PC market drives the cost per unit for those
> components down to nearly nothing.
>
>   
