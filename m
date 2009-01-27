Return-Path: <linux-kernel-owner+w=401wt.eu-S1756039AbZA0ThE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbZA0ThE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 14:37:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756815AbZA0Tgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 14:36:51 -0500
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:33275 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756762AbZA0Tgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 14:36:50 -0500
Message-ID: <497F6257.4070101@krogh.cc>
Date: Tue, 27 Jan 2009 20:36:55 +0100
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
CC: Greg KH <gregkh@suse.de>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
Subject: Re: Linux 2.6.27.13
References: <20090125004823.GA6711@kroah.com> <497E16A0.50607@krogh.cc> <20090126210730.GB24164@suse.de> <F169D4F5E1F1974DBFAFABF47F60C10A1C2250D0@orsmsx507.amr.corp.intel.com>
In-Reply-To: <F169D4F5E1F1974DBFAFABF47F60C10A1C2250D0@orsmsx507.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brandeburg, Jesse wrote:
> Greg KH wrote:
>> On Mon, Jan 26, 2009 at 09:01:36PM +0100, Jesper Krogh wrote:
>>> Greg KH wrote:
>>>> We (the -stable team) are announcing the release of the 2.6.27.13
>>>> kernel. It contains a wide range of bugfixes, and all users of the
>>>> 2.6.27 kernel series are strongly encouraged to upgrade.
>>>> I'll also be replying to this message with a copy of the patch
>>>> between 
>>>> 2.6.27.12 and 2.6.27.13
>>> Hi.
>>>
>>> I'm getting some e1000 noise on a 2.6.27.6, I search the log up to
>>> .13 but couldn't find any log messsage that looked like it fixed it.
>>>
>>>
>>> [862734.501786] ------------[ cut here ]------------
>>> [862734.501793] WARNING: at net/sched/sch_generic.c:219
>>> dev_watchdog+0x1f8/0x210() [862734.501795] NETDEV WATCHDOG: eth0
>>> (e1000): transmit timed out 
>> I've been getting a lot of reports about this as well.  Did it show up
>> in 2.6.27.6?
>>
>> Netdev developers, any ideas of what would be causing this?
> 
> no immediate idea, but a quick test to help isolate which functionality
> could be causing problems is to disable TSO on all four interfaces using
> ethtool.
> 
> It could be that GSO is somehow playing into this as well, but I don't
> know why (you could disable it with ethtool too).
> 
> It could be unrelated but I've noticed that TCP window size can grow much
> larger now than it used to (especially talking to LRO enabled clients) 
> and this might cause some kind of an overflow in the TCP transmit
> offloading hardware in the e1000 parts.
> 
> 
>>> Complete dmesg here:
>>> http://krogh.cc/~jesper/dmesg-2.6.27.6.txt
>>>
>>> The system is running with bonded interfaces with  (lspci output)
>>> 06:01.0 Ethernet controller: Intel Corporation 82546EB Gigabit
>>> Ethernet Controller (Copper) (rev 03) 06:01.1 Ethernet controller:
>>> Intel Corporation 82546EB Gigabit Ethernet Controller (Copper) (rev
>>> 03) 06:02.0 Ethernet controller: Intel Corporation 82546EB Gigabit
>>> Ethernet Controller (Copper) (rev 03) 06:02.1 Ethernet controller:
>>> Intel Corporation 82546EB Gigabit Ethernet Controller (Copper) (rev
>>> 03)   
>>>
>>> The system is still "fully functional", and I havent notiched
>>> anything wrong, but there sure is a lot of link ups and downs on
>>> that bond. 
> 
> in your log I saw one tx timeout for each interface, one first one by itself
> and then several more all within a few minutes, but then no more for
> a really long time.
> 
> My first reaction is to ask you what test you're running, and ask you to
> run the e1000_dump code (see google) to dump the tx descriptor rings at 
> the time of failure.
> 
> I can get you that code with updates if you're willing to test, but 
> it might take a couple of days.

I would love to have it at hand, but it is a production system, so it'll 
be upgraded to 2.6.27.latest at next reboot. So It should be working 
with that one.

Jesper

-- 
Jesper
