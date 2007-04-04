Return-Path: <linux-kernel-owner+w=401wt.eu-S966164AbXDDBvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966164AbXDDBvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 21:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966268AbXDDBvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 21:51:43 -0400
Received: from warden-p.diginsite.com ([208.29.163.248]:44611 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S966164AbXDDBvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 21:51:42 -0400
Date: Tue, 3 Apr 2007 18:23:07 -0700 (PDT)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: David Miller <davem@davemloft.net>, dwmw2@infradead.org,
       flar@allandria.com, paulus@samba.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
In-Reply-To: <20070404024400.56d016e1@the-village.bc.nu>
Message-ID: <Pine.LNX.4.63.0704031817020.21680@qynat.qvtvafvgr.pbz>
References: <1175644642.10567.31.camel@shinybook.infradead.org><200704032210
 02.GA13210@cynthia.pants.nu><1175648051.10567.61.camel@shinybook.infradead.
 org><20070403.181645.68159458.davem@davemloft.net><20070404022828.5c9b97f3@
 the-village.bc.nu><Pine.LNX.4.63.0704031804350.21680@qynat.qvtvafvgr.pbz>
 <20070404024400.56d016e1@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2007, Alan Cox wrote:

>>> You don't get machines with 64 ethernet ports on add-in cards. There are
>>> good reasons for the naming schemes in use.
>>
>> I've seen machines offering up to 48, what's the magic number that makes you
>> need to chagne nameing schemes?
>
> Have you tried working with 48 ports when they are not numbered 0-47 or
> in some logical fashion ?

no, but that's what we're wanting with serial ports as well. a system with 50 
serial ports should have them numbered 0-49, not typea0-5, typeb0-39, typec0-5

>> I also know of systems with 50 serial ports on them. the fact that some of the
>> serial ports on the front panel were named differently then other serial ports
>> on the front panel sure didn't make my life easier in dealing with them.
>
> Well the better designed serial setups on Linux use numbering so that you
> can look on the multiplexor boxes and know straight away what the
> correlation between port number and name is. In the same was as "S0 is
> console 1" is nice to have its also nice to have "mux 1 port 4" easily
> calculable not think
>
> 	"Well now we've got 2 console ports thats S0/S1, a 4 port PCI
> card found before us so thats S2 to S5, so we must start as S6 to mux 1
> port 4 is going to be umm .. S10"
>
> Let alone the hell that breaks out when you add a new card using this
> system.
>
> The ethernet one works better because you've usually got a MAC address
> per port (although its not required by any means), which means that the
> scripts in the distro can do naming persistency for you and hide the
> whole exciting game from you.

people working with ~50 serial ports or ethernet ports aren't useing stock 
distros anyway.

> Which is also another reason for building the "all serial devices"
> mapping by using udev, as it can provide multiple simultaneous views. The
> serial console unfortunately rather breaks that approach as Dave pointed
> out

I would reverse this. instead of having a bunch of different names and then 
requiring a tool to create sane names from them, start off with a nice nameing 
scheme and have a tool that tells you the under-the-covers details.

so leave all the ports numbered 0-49, but let people who need to know run a 
tool (even if it's dmesg -s 200000 |grep ttyS) to learn the details of what 
hardware is used to run what port.

for 99.99% of the users they will never need to use this tool (things will just 
work becouse they only have one type, or someone else put lables on the box 
before shipping it to you), and in the other 0.01% of the users, they are 
running a tool anyway to get the gory details of things so it isn't a big 
harship for them.

David Lang

