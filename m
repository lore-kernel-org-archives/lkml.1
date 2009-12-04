Return-Path: <linux-kernel-owner+w=401wt.eu-S1755499AbZLDBU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499AbZLDBU0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 20:20:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754846AbZLDBUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 20:20:23 -0500
Received: from p01c11o145.mxlogic.net ([208.65.144.68]:49468 "EHLO
	p01c11o145.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbZLDBUW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 20:20:22 -0500
X-MXL-Hash: 4b1863dd524f4ebb-854619c402b976ff3843cd8a1970f1a51d70d509
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2.6.32 3/3] net: Make ks8851 snl work under Beagle Zippy combo board
Date: Thu, 3 Dec 2009 17:17:09 -0800
Message-ID: <14385191E87B904DBD836449AA30269D4F2135@MORGANITE.micrel.com>
In-Reply-To: <20091203.160511.211490797.davem@davemloft.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2.6.32 3/3] net: Make ks8851 snl work under Beagle Zippy combo board
Thread-Index: Acp0dXNlLZArAeE4TvSZpH/UxTb2MQAB1Lkg
References: <14385191E87B904DBD836449AA30269D021A42@MORGANITE.micrel.com> <20091203.160511.211490797.davem@davemloft.net>
From: "Ha, Tristram" <Tristram.Ha@Micrel.Com>
To: "David Miller" <davem@davemloft.net>
Cc: <ben@simtec.co.uk>, <netdev@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 04 Dec 2009 01:20:27.0858 (UTC) FILETIME=[F67DAB20:01CA747F]
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2009113001)]
X-MAIL-FROM: <tristram.ha@micrel.com>
X-SOURCE-IP: [65.218.208.2]
X-AnalysisOut: [v=1.0 c=1 a=7GNLPhxcCykA:10 a=J3BOMSfJb05aRia9DmE+FQ==:17 ]
X-AnalysisOut: [a=Q4n7fi2PAAAA:8 a=rIV8yS8U-Ialy3RWZCsA:9 a=I1EBxjxhta6g_p]
X-AnalysisOut: [SnijzobCTOpgwA:4 a=yJsD6ztlz_8A:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: "Ha, Tristram" <Tristram.Ha@Micrel.Com>
> Date: Thu, 3 Dec 2009 13:30:03 -0800
> 
>> From: Tristram Ha <Tristram.Ha@micrel.com>
>> 
>> The Micrel KSZ8851 SNL Ethernet chip is used in the OMAP Beagle Zippy
combo board.  Requesting
>> interrupt using level triggering flag hangs the system because the
interrupt handling routine
>> is called continually.  Using edge triggering avoids this problem.
As a result, disabling
>> interrupt may not be necessary.   
>> 
>> Signed-off-by: Tristram Ha <Tristram.Ha@micrel.com>
> 
> You say "may not be necessary", do you actually know for sure?
> 
> This seems questionable, if the interrupt disabling was there for a
reason what has changed to
> make it such that it is no longer necessary? 

I have tested the KSZ8851 SNL driver using the OMAP Beagle Zippy combo
board, developed by Tin Can Tools.  Ben Dooks, who implemented the
original driver, has his own KSZ8851 SNL evaluation board, but he
probably did not run any performance test on the driver.  I did sent him
the changes before so that he can verify on his board, but I have not
received any response.

So I really do not know if interrupt disabling is necessary or not.  But
from my understanding of the SPI network driver model, it is almost
required the interrupt be edge triggered, as the hardware interrupt
cannot be disabled inside the actual interrupt handling routine.  So if
the interrupt is level triggered, the interrupt routine will be called
continually, and there is no chance for the workqueue to disable the
interrupt.  As the interrupt is edge triggered, I do not think the
interrupt needs to be disabled.
