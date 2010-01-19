Return-Path: <linux-kernel-owner+w=401wt.eu-S1754141Ab0ASVxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab0ASVxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 16:53:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753957Ab0ASVxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 16:53:42 -0500
Received: from p01c11o145.mxlogic.net ([208.65.144.68]:48184 "EHLO
	p01c11o145.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024Ab0ASVxk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 16:53:40 -0500
X-MXL-Hash: 4b5629e471289d6d-9c3bfa7e554b516756c2d6ed2690bdf366562849
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH 2.6.33 1/3] net: Micrel KSZ8841/2 PCI Ethernet driver
Date: Tue, 19 Jan 2010 13:51:58 -0800
Message-ID: <14385191E87B904DBD836449AA30269D580AA0@MORGANITE.micrel.com>
In-Reply-To: <4B51E64B.6010706@openwrt.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2.6.33 1/3] net: Micrel KSZ8841/2 PCI Ethernet driver
Thread-Index: AcqWx0EO8dd4XRr1Q96OJ8BIBfpQngChtj/g
References: <14385191E87B904DBD836449AA30269D021A4A@MORGANITE.micrel.com> <e2d7436a1001160800u11206f54iaf07bb92331a256a@mail.gmail.com> <4B51E64B.6010706@openwrt.org>
From: "Ha, Tristram" <Tristram.Ha@Micrel.Com>
To: "Felix Fietkau" <nbd@openwrt.org>
Cc: "Dave Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, "Michael Buesch" <mb@bu3sch.de>,
       =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
X-OriginalArrivalTime: 19 Jan 2010 21:53:26.0246 (UTC) FILETIME=[D40C5860:01CA9951]
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010011101)]
X-MAIL-FROM: <tristram.ha@micrel.com>
X-SOURCE-IP: [65.218.208.2]
X-AnalysisOut: [v=1.0 c=1 a=x45bwnNEFwQA:10 a=J3BOMSfJb05aRia9DmE+FQ==:17 ]
X-AnalysisOut: [a=jdP34snFAAAA:8 a=iz9dbIbQihdyCHnt67kA:9 a=cwGAV17HgoBrOi]
X-AnalysisOut: [ThScIA:7 a=R761wUns6VhfHTiCZIu-Wp6XtAwA:4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> If my assumptions are correct, then I thing it would be better to have
>> a driver that presents this device as two: one - an ethernet device,
>> and second - a switch management interface like the one used in OpenWRT.
>> 
>> Here are some links for reference:
>> http://downloads.openwrt.org/kamikaze/8.09.2/kamikaze_8.09.2_source.ta r.bz2;
>> subdir: package/switch/src/
>>   -> switch management driver for ADMTEK Adm6996 and Broadcom
>> BCM5325E/536x
> Don't look at that ;)
> The code you're referring to is just a simple hack of mine that is a few years old now. It's
> going to be removed as soon as the drivers have been ported to a proper API. 
> 
> I've been working on a switch configuration API based on netlink, which is being used on some of
> the other platforms in OpenWrt. 
> 
> You can find the sources here:
> https://dev.openwrt.org/export/19173/trunk/target/linux/generic-2.6/files/drivers/net/phy/swconfig.c
> https://dev.openwrt.org/export/19173/trunk/target/linux/generic-2.6/files/include/linux/switch.h
> 
> It's meant to be used with drivers that hook into the PHY abstraction layer.
> You can find an example of such a driver here:
> https://dev.openwrt.org/export/19173/trunk/target/linux/generic-2.6/files/drivers/net/phy/rtl8306.c
> 
> I'll do the final cleanups and submit it for review once I have time to do so.
> 
> - Felix

Your work looks interesting, but rtl8036 seems to use MDIO page registers to access its own internal registers.  Micrel switches do not have that feature and so cannot use that way.

I am looking at those PHY drivers and try to figure out how they work under mdio bus.  I am using Micrel's own KSZ8695P and KSZ9692P SoC to develop and debug the KSZ884X PCI driver.  KSZ9692P actually has two external PHYs so that the PHY driver can run on it.  But the driver does not load because I probably need to add some hooks to the mdio bus driver to do the actual hardware access.  Can somebody give me some pointers to this mdio bus support?  Does the PHY driver create a user interface like eth0 so that it can be accessed using some tools like ethtool?

Anyway I am afraid the phy driver model does not work on KSZ884X.  I cannot think of how the mdio bus accesses hardware registers located on a PCI device.
