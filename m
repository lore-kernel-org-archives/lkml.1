Return-Path: <linux-kernel-owner+w=401wt.eu-S1755835Ab0ATAg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835Ab0ATAg0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 19:36:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755469Ab0ATAgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 19:36:25 -0500
Received: from p01c11o142.mxlogic.net ([208.65.144.65]:57289 "EHLO
	p01c11o142.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755456Ab0ATAgY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 19:36:24 -0500
X-MXL-Hash: 4b5650081ab7771a-b167402f6fa4c4f2f001ca1b8a333c04230dbb65
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2.6.33 1/3] net: Micrel KSZ8841/2 PCI Ethernet driver
Date: Tue, 19 Jan 2010 16:34:38 -0800
Message-ID: <14385191E87B904DBD836449AA30269D580B08@MORGANITE.micrel.com>
In-Reply-To: <20100119161147.6faca543@nehalam>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2.6.33 1/3] net: Micrel KSZ8841/2 PCI Ethernet driver
Thread-Index: AcqZZTI36gGhTN5kSUyDmtltdSRs4wAAhdpQ
References: <14385191E87B904DBD836449AA30269D021A4A@MORGANITE.micrel.com><20100116.012004.166836523.davem@davemloft.net><14385191E87B904DBD836449AA30269D580A76@MORGANITE.micrel.com><20100119134059.63b355e4@nehalam><14385191E87B904DBD836449AA30269D580AEB@MORGANITE.micrel.com> <20100119161147.6faca543@nehalam>
From: "Ha, Tristram" <Tristram.Ha@Micrel.Com>
To: "Stephen Hemminger" <shemminger@vyatta.com>
Cc: "David Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 20 Jan 2010 00:36:05.0981 (UTC) FILETIME=[8D4DB8D0:01CA9968]
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010011101)]
X-MAIL-FROM: <tristram.ha@micrel.com>
X-SOURCE-IP: [65.218.208.2]
X-AnalysisOut: [v=1.0 c=1 a=x45bwnNEFwQA:10 a=J3BOMSfJb05aRia9DmE+FQ==:17 ]
X-AnalysisOut: [a=Q4n7fi2PAAAA:8 a=cQ1WGwX1fEd0FpHk_GkA:9 a=Nxxooj7JutTB_Z]
X-AnalysisOut: [YdSVgA:7 a=lZEBtJbqJOMO1l5XBfqspFk4aOwA:4 a=yJsD6ztlz_8A:1]
X-AnalysisOut: [0 a=VCFr0Y9aPfISQLLi:21 a=8R49uEq8fEl7Aph4:21]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger wrote:
> On Tue, 19 Jan 2010 15:48:50 -0800
> "Ha, Tristram" <Tristram.Ha@Micrel.Com> wrote:
> 
>> Stephen Hemminger wrote:
>>>> Now for the driver implementation for STP support.  I programmed
>>>> the switch's static MAC table to always pass the following frames
>>>> to the
>>>> host: BPDU frames with specific multicast address, broadcast
>>>> frames, unicast frames with the device bridge's MAC address, and
>>>> multicast frames with ICMPv6 multicast address.  All other frames
>>>> are not
>> passed
>>>> to the host and are handled by the switch, forwarding each frame
>>>> with its standard forwarding logic.  The port can be shut off if it
>>>> is blocked and those frames will not pass through that port.  The
>>>> host gets BPDU frames so that the bridge can determine each port's
state.
>>>> The other broadcast, unicast, and multicast frames passed to the
>>>> host are necessary if some other network devices want to
>>>> communicate with the host.  As the forwarding is done by hardware
>>>> rather than
>> software,
>>>> overall performance does increase.
>>> 
>>> What about LACP needed by bridging?
>>> 
>> 
>> I am not aware of LACP and do not know how this protocol works under
>> bridging.  If the requirement is certain multicast frames do not get
>> forwarded and must pass to the host bridge, I can add those fixed
>> multicast addresses.  The static MAC table has 8 entries, so there
are
>> 4 more to use.
> 
> Anything 01:80:C2:00:00:00 should go local host.
> LACP is part of 802.3ad bonding and uses 01:80:C2:00:02
> 
> In general anything to 01:80:C2:00:00:XX is likely to be used by some
IEEE 802 standard for link
> only multicast. 

If the strict requirement is to support all 01:80:C2:00:00:XX multicast
addresses, my scheme will not work.  It was designed only for STP, as
most our customers request that feature.

I will pass your suggestions to our hardware engineers so that they can
develop a better switch engine.
