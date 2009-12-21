Return-Path: <linux-kernel-owner+w=401wt.eu-S1757326AbZLUWHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326AbZLUWHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 17:07:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755710AbZLUWHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 17:07:46 -0500
Received: from p01c12o143.mxlogic.net ([208.65.145.66]:35879 "EHLO
	p01c12o143.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757271AbZLUWHp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 17:07:45 -0500
X-MXL-Hash: 4b2ff1b17b018f70-bbdf6607c0bc8f6f87ad0fa125d2d9d7bf8e8b43
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2.6.32 3/3] net: Make ks8851 snl work under Beagle Zippy combo board
Date: Mon, 21 Dec 2009 14:07:14 -0800
Message-ID: <14385191E87B904DBD836449AA30269D538A55@MORGANITE.micrel.com>
In-Reply-To: <14385191E87B904DBD836449AA30269D4F2135@MORGANITE.micrel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2.6.32 3/3] net: Make ks8851 snl work under Beagle Zippy combo board
Thread-Index: Acp0dXNlLZArAeE4TvSZpH/UxTb2MQAB1LkgA4LC7SA=
References: <14385191E87B904DBD836449AA30269D021A42@MORGANITE.micrel.com> <20091203.160511.211490797.davem@davemloft.net> <14385191E87B904DBD836449AA30269D4F2135@MORGANITE.micrel.com>
From: "Ha, Tristram" <Tristram.Ha@Micrel.Com>
To: "David Miller" <davem@davemloft.net>
Cc: <ben@simtec.co.uk>, <netdev@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 21 Dec 2009 22:07:43.0026 (UTC) FILETIME=[04BFD920:01CA828A]
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2009113001)]
X-MAIL-FROM: <tristram.ha@micrel.com>
X-SOURCE-IP: [65.218.208.2]
X-AnalysisOut: [v=1.0 c=1 a=7GNLPhxcCykA:10 a=J3BOMSfJb05aRia9DmE+FQ==:17 ]
X-AnalysisOut: [a=PLuOMZxuCo_0GHCXCEIA:9 a=suxH41XcilWWMxlk4aPl1vtR0aUA:4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ha, Tristram wrote:
> David Miller wrote:
>> 
>> You say "may not be necessary", do you actually know for sure?
>> 
>> This seems questionable, if the interrupt disabling was there for a
>> reason what has changed to make it such that it is no longer
necessary?
> 
> I have tested the KSZ8851 SNL driver using the OMAP Beagle Zippy combo
board, developed by Tin
> Can Tools.  Ben Dooks, who implemented the original driver, has his
own KSZ8851 SNL evaluation
> board, but he probably did not run any performance test on the driver.
I did sent him the
> changes before so that he can verify on his board, but I have not
received any response.   
> 
> So I really do not know if interrupt disabling is necessary or not.
But from my understanding
> of the SPI network driver model, it is almost required the interrupt
be edge triggered, as the
> hardware interrupt cannot be disabled inside the actual interrupt
handling routine.  So if the
> interrupt is level triggered, the interrupt routine will be called
continually, and there is no
> chance for the workqueue to disable the interrupt.  As the interrupt
is edge triggered, I do not
> think the interrupt needs to be disabled.     

The "[PATCH 2.6.33] net: Fix ks8851 snl receive problem" I just
submitted turns off hardware interrupt during interrupt handling.  That
makes the disable_irq() call really unnecessary when the interrupt is
edge-triggered.  The code also works when the interrupt is
level-triggered under Beagle Zippy combo board, but theoretically the
disable_irq() is required when the interrupt is level-triggered.  When I
first worked on the ks8851 driver I was using Linux 2.6.22, and the
level-triggered interrupt code did not work.  That is why I changed the
code to edge-triggered.
