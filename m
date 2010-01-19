Return-Path: <linux-kernel-owner+w=401wt.eu-S1756045Ab0ASXvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045Ab0ASXvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 18:51:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754453Ab0ASXvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 18:51:16 -0500
Received: from p01c11o145.mxlogic.net ([208.65.144.68]:43718 "EHLO
	p01c11o145.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab0ASXvP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 18:51:15 -0500
X-MXL-Hash: 4b5645724d6fd035-9c03f737cb028b1c659cd367117fea55ce44e574
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2.6.33 1/3] net: Micrel KSZ8841/2 PCI Ethernet driver
Date: Tue, 19 Jan 2010 15:48:50 -0800
Message-ID: <14385191E87B904DBD836449AA30269D580AEB@MORGANITE.micrel.com>
In-Reply-To: <20100119134059.63b355e4@nehalam>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2.6.33 1/3] net: Micrel KSZ8841/2 PCI Ethernet driver
Thread-Index: AcqZUB6UBQ2oDPFBTf6i0qfrlMHyGQAECGPQ
References: <14385191E87B904DBD836449AA30269D021A4A@MORGANITE.micrel.com><20100116.012004.166836523.davem@davemloft.net><14385191E87B904DBD836449AA30269D580A76@MORGANITE.micrel.com> <20100119134059.63b355e4@nehalam>
From: "Ha, Tristram" <Tristram.Ha@Micrel.Com>
To: "Stephen Hemminger" <shemminger@vyatta.com>
Cc: "David Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 19 Jan 2010 23:50:17.0729 (UTC) FILETIME=[2737BF10:01CA9962]
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010011101)]
X-MAIL-FROM: <tristram.ha@micrel.com>
X-SOURCE-IP: [65.218.208.2]
X-AnalysisOut: [v=1.0 c=1 a=x45bwnNEFwQA:10 a=J3BOMSfJb05aRia9DmE+FQ==:17 ]
X-AnalysisOut: [a=1GBejmwKG2_QdL1ab2MA:9 a=S3JQwUgHkVr-zlHKzFQA:7 a=qHcHb0]
X-AnalysisOut: [_M9ySV75JFmsww_IgNaVEA:4 a=sp_g_uzmb-PZfTFz:21 a=t8uOHXnEr]
X-AnalysisOut: [tty-KPo:21]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger wrote:
>> Now for the driver implementation for STP support.  I programmed the
>> switch's static MAC table to always pass the following frames to the
>> host: BPDU frames with specific multicast address, broadcast frames,
>> unicast frames with the device bridge's MAC address, and multicast
>> frames with ICMPv6 multicast address.  All other frames are not
passed
>> to the host and are handled by the switch, forwarding each frame with
>> its standard forwarding logic.  The port can be shut off if it is
>> blocked and those frames will not pass through that port.  The host
>> gets BPDU frames so that the bridge can determine each port's state.
>> The other broadcast, unicast, and multicast frames passed to the host
>> are necessary if some other network devices want to communicate with
>> the host.  As the forwarding is done by hardware rather than
software,
>> overall performance does increase.
> 
> What about LACP needed by bridging?
> 

I am not aware of LACP and do not know how this protocol works under
bridging.  If the requirement is certain multicast frames do not get
forwarded and must pass to the host bridge, I can add those fixed
multicast addresses.  The static MAC table has 8 entries, so there are 4
more to use.
