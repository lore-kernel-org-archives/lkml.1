Return-Path: <linux-kernel-owner+w=401wt.eu-S1756199Ab0ATANf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199Ab0ATANf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 19:13:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754420Ab0ATANe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 19:13:34 -0500
Received: from p01c11o149.mxlogic.net ([208.65.144.72]:52422 "EHLO
	p01c11o149.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab0ATANd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 19:13:33 -0500
X-MXL-Hash: 4b564aad6b45f7bf-a4a2191493250d6e868409e5842f6de1b96cea3a
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2.6.33 1/3] net: Micrel KSZ8841/2 PCI Ethernet driver
Date: Tue, 19 Jan 2010 16:12:04 -0800
Message-ID: <14385191E87B904DBD836449AA30269D580AF2@MORGANITE.micrel.com>
In-Reply-To: <20100119213214.024b7794@lxorguk.ukuu.org.uk>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2.6.33 1/3] net: Micrel KSZ8841/2 PCI Ethernet driver
Thread-Index: AcqZToOXPQnnXNh9TGCipiKUVkRpHwAE3eCg
References: <14385191E87B904DBD836449AA30269D021A4A@MORGANITE.micrel.com><20100116145014.172ad340@lxorguk.ukuu.org.uk><14385191E87B904DBD836449AA30269D580A93@MORGANITE.micrel.com> <20100119213214.024b7794@lxorguk.ukuu.org.uk>
From: "Ha, Tristram" <Tristram.Ha@Micrel.Com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: "Dave Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 20 Jan 2010 00:13:31.0938 (UTC) FILETIME=[663B2820:01CA9965]
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010011101)]
X-MAIL-FROM: <tristram.ha@micrel.com>
X-SOURCE-IP: [65.218.208.2]
X-AnalysisOut: [v=1.0 c=1 a=x45bwnNEFwQA:10 a=J3BOMSfJb05aRia9DmE+FQ==:17 ]
X-AnalysisOut: [a=qkhriJv9anJh3HDZJfgA:9 a=ani1mmDPjnNqpJhqrzIA:7 a=r7nFKa]
X-AnalysisOut: [if5rf-bsK0eUx0CbN-mzIA:4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>>> If you make a private copy of pdev in your struct you should
>>> refcount
>> it and use
>>> pci_dev_get/pci_dev_put when you take and release the reference.
> 
>> I do not understand how pci_dev_get/pci_dev_put work.  Does the pdev
>> pointer actually change during the lifetime of the PCI driver?
> 
> No but it can go away if the device is removed. The pci_dev_get
ensures it won't go away while
> you have a pointer to it. and the pci_dev_put gives up your reference.

> 

If the PCI device is removed, like physically removing the card,
shouldn't the kernel also close the network device assocated with the
PCI device?  The driver does actually cleanup the network devices and
free all memory when the pci remove function is called.

>From the PCI network drivers included in the kernel I found most drivers
use pci_dev_put only on devices that are outside their own PCI devices,
retrieved from the pci_get_device call.  (They never call pci_dev_get.)
That makes sense as those PCI devices are outside PCI driver control.
