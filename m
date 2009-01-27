Return-Path: <linux-kernel-owner+w=401wt.eu-S1755581AbZA0Aho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581AbZA0Aho (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 19:37:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753581AbZA0Ahc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 19:37:32 -0500
Received: from mga02.intel.com ([134.134.136.20]:10513 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752526AbZA0Ahb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 19:37:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,328,1231142400"; 
   d="scan'208";a="484832693"
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
To: Greg KH <gregkh@suse.de>, Jesper Krogh <jesper@krogh.cc>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
Date: Mon, 26 Jan 2009 16:37:29 -0800
Subject: RE: Linux 2.6.27.13
Thread-Topic: Linux 2.6.27.13
Thread-Index: Acl/+my6jsCNNhBUTnKvPfPxd5tvIwAEbOTA
Message-ID: <F169D4F5E1F1974DBFAFABF47F60C10A1C2250D0@orsmsx507.amr.corp.intel.com>
References: <20090125004823.GA6711@kroah.com> <497E16A0.50607@krogh.cc>
 <20090126210730.GB24164@suse.de>
In-Reply-To: <20090126210730.GB24164@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Mon, Jan 26, 2009 at 09:01:36PM +0100, Jesper Krogh wrote:
>> Greg KH wrote:
>>> We (the -stable team) are announcing the release of the 2.6.27.13
>>> kernel. It contains a wide range of bugfixes, and all users of the
>>> 2.6.27 kernel series are strongly encouraged to upgrade.
>>> I'll also be replying to this message with a copy of the patch
>>> between 
>>> 2.6.27.12 and 2.6.27.13
>> 
>> Hi.
>> 
>> I'm getting some e1000 noise on a 2.6.27.6, I search the log up to
>> .13 but couldn't find any log messsage that looked like it fixed it.
>> 
>> 
>> [862734.501786] ------------[ cut here ]------------
>> [862734.501793] WARNING: at net/sched/sch_generic.c:219
>> dev_watchdog+0x1f8/0x210() [862734.501795] NETDEV WATCHDOG: eth0
>> (e1000): transmit timed out 
> 
> I've been getting a lot of reports about this as well.  Did it show up
> in 2.6.27.6?
> 
> Netdev developers, any ideas of what would be causing this?

no immediate idea, but a quick test to help isolate which functionality
could be causing problems is to disable TSO on all four interfaces using
ethtool.

It could be that GSO is somehow playing into this as well, but I don't
know why (you could disable it with ethtool too).

It could be unrelated but I've noticed that TCP window size can grow much
larger now than it used to (especially talking to LRO enabled clients) 
and this might cause some kind of an overflow in the TCP transmit
offloading hardware in the e1000 parts.


>> 
>> Complete dmesg here:
>> http://krogh.cc/~jesper/dmesg-2.6.27.6.txt
>> 
>> The system is running with bonded interfaces with  (lspci output)
>> 06:01.0 Ethernet controller: Intel Corporation 82546EB Gigabit
>> Ethernet Controller (Copper) (rev 03) 06:01.1 Ethernet controller:
>> Intel Corporation 82546EB Gigabit Ethernet Controller (Copper) (rev
>> 03) 06:02.0 Ethernet controller: Intel Corporation 82546EB Gigabit
>> Ethernet Controller (Copper) (rev 03) 06:02.1 Ethernet controller:
>> Intel Corporation 82546EB Gigabit Ethernet Controller (Copper) (rev
>> 03)   
>> 
>> The system is still "fully functional", and I havent notiched
>> anything wrong, but there sure is a lot of link ups and downs on
>> that bond. 

in your log I saw one tx timeout for each interface, one first one by itself
and then several more all within a few minutes, but then no more for
a really long time.

My first reaction is to ask you what test you're running, and ask you to
run the e1000_dump code (see google) to dump the tx descriptor rings at 
the time of failure.

I can get you that code with updates if you're willing to test, but 
it might take a couple of days.

Jesse