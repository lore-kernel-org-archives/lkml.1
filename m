Return-Path: <linux-kernel-owner+w=401wt.eu-S1758177AbZKXP5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177AbZKXP5i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 10:57:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758156AbZKXP5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 10:57:37 -0500
Received: from mga11.intel.com ([192.55.52.93]:45076 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758151AbZKXP5g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 10:57:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,280,1257148800"; 
   d="scan'208";a="749975139"
From: "Allan, Bruce W" <bruce.w.allan@intel.com>
To: Jarek Poplawski <jarkao2@gmail.com>,
       Caleb Cushing <xenoterracide@gmail.com>
CC: "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       Frans Pop <elendil@planet.nl>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>,
       "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
Date: Tue, 24 Nov 2009 07:57:41 -0800
Subject: RE: [E1000-devel] large packet loss take2 2.6.31.x
Thread-Topic: [E1000-devel] large packet loss take2 2.6.31.x
Thread-Index: Acps+BT39Dnw/hIiT42xcKhKWZi3zwAJiSsQ
Message-ID: <8DD2590731AB5D4C9DBF71A877482A903E2AA445@orsmsx509.amr.corp.intel.com>
References: <81bfc67a0911232217n41b9ac02w3b7770b789e5d209@mail.gmail.com>
 <20091124111946.GA7883@ff.dom.local>
In-Reply-To: <20091124111946.GA7883@ff.dom.local>
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



>-----Original Message-----
>From: Jarek Poplawski [mailto:jarkao2@gmail.com]
>Sent: Tuesday, November 24, 2009 3:20 AM
>To: Caleb Cushing
>Cc: e1000-devel@lists.sourceforge.net; netdev@vger.kernel.org; Frans Pop;
>Brandeburg, Jesse; linux-kernel@vger.kernel.org; Andi Kleen; Kirsher,
>Jeffrey T
>Subject: Re: [E1000-devel] large packet loss take2 2.6.31.x
>
>On Tue, Nov 24, 2009 at 01:17:09AM -0500, Caleb Cushing wrote:
>> > Btw, currently I don't consider this dropping means there has to be
>> > a bug. It could be otherwise - a feature... e.g. when a new kernel
>> > can transmit faster (then dropping in some other, slower place can
>> > happen).
>>
>> um... where would it be dropping that we wouldn't have a bug? I mean
>> sure faster is great... but if it makes my network not work right...
>
>E.g. if it were dropped because of a queue overflow (but it doesn't
>seem to be the case, at least at your box) or because of memory
>problems while handling a lot of traffic.
>
>>
>> I've added all (I think) information you've asked for to the bug
>> http://bugzilla.kernel.org/show_bug.cgi?id=13835 except for ethtool
>> and netstat on the router side. ethtool complains about not having
>> driver or capability (maybe because it's a 2.4 kernel?) and the
>> version of netstat doesn't support -s. I disabled everything that I
>> can think of that would send/receive packets before doing the test
>> client side, except dhcp/dns windows box's were probably sending some
>> broadcasts too. but the traffic should be pretty low. I did remember
>> to set the txqueuelen didn't seem to make a difference
>
>Alas it's not all information I asked. E.g. "netstat -s before faulty
>kernel" and "netstat -s after faulty kernel" seem to be the same file:
>netstat_after.slave4.log.gz. Anyway, since there are problems with
>getting stats from the router we still can't compare them, or check
>for the dropped stats. (Btw, could you check for /proc/net/softnet_stat
>yet?)
>
>So, it might be the kernel problem you reported, but there is not
>enough data to prove it. Then my proposal is to try to repeat this
>problem in more "testing friendly" conditions - preferably against
>some other, more up-to-date linux box, if possible?
>
>> only error in dmesg I see is
>>
>> e1000e 0000:00:19.0: pci_enable_pcie_error_reporting failed 0xfffffffb
>
>I added e1000e maintainers to CC to have a look at this warning.
>
>Jarek P.

The "pci_enable_pcie_error_reporting failed" message is a non-fatal warning that has recently been removed.

