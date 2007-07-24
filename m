Return-Path: <linux-kernel-owner+w=401wt.eu-S935441AbXGXJUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935441AbXGXJUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 05:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765524AbXGXJUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 05:20:12 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:46839 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762618AbXGXJUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 05:20:10 -0400
Message-ID: <46A5C461.7030806@free.fr>
Date: Tue, 24 Jul 2007 11:20:33 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-rt-users@vger.kernel.org, oprofile-list@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: Pin-pointing the root of unusual application latencies
References: <469600F7.3060603@free.fr> <20070723095357.GA886@elte.hu> <46A4B7C2.1070304@free.fr> <20070723160442.GA7995@elte.hu> <46A5B8E3.4060004@free.fr>
In-Reply-To: <46A5B8E3.4060004@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John Sigler wrote:

> ( check_dektec_in-1095 |#0): new 271 us user-latency.
> ( check_dektec_in-1095 |#0): new 275 us user-latency.
> ( check_dektec_in-1095 |#0): new 290 us user-latency.
> ( check_dektec_in-1095 |#0): new 297 us user-latency.
> ( check_dektec_in-1095 |#0): new 345 us user-latency.
> ( check_dektec_in-1095 |#0): new 358 us user-latency.
> ( check_dektec_in-1095 |#0): new 384 us user-latency.
> ( check_dektec_in-1095 |#0): new 392 us user-latency.
> ( check_dektec_in-1095 |#0): new 395 us user-latency.
> ( check_dektec_in-1095 |#0): new 396 us user-latency.
> ( check_dektec_in-1095 |#0): new 1031 us user-latency.
> ( check_dektec_in-1095 |#0): new 1100 us user-latency.
> ( check_dektec_in-1095 |#0): new 1105 us user-latency.
> ( check_dektec_in-1095 |#0): new 1106 us user-latency.
> 
> Here's the function trace for the 1106-µs latency:
> 
> http://linux.kernel.free.fr/latency/1106-us-trace.txt

The function trace for 400-µs latencies is different:

( check_dektec_in-1145 |#0): new 275 us user-latency.
( check_dektec_in-1145 |#0): new 276 us user-latency.
( check_dektec_in-1145 |#0): new 288 us user-latency.
( check_dektec_in-1145 |#0): new 289 us user-latency.
( check_dektec_in-1145 |#0): new 289 us user-latency.
( check_dektec_in-1145 |#0): new 290 us user-latency.
( check_dektec_in-1145 |#0): new 297 us user-latency.
( check_dektec_in-1145 |#0): new 345 us user-latency.
( check_dektec_in-1145 |#0): new 354 us user-latency.
( check_dektec_in-1145 |#0): new 377 us user-latency.
( check_dektec_in-1145 |#0): new 393 us user-latency.

http://linux.kernel.free.fr/latency/393-us-trace.txt

There are ~200 calls to ioread32 from mdio_read from speedo_timer.

http://lxr.linux.no/source/drivers/net/eepro100.c#L1159
http://lxr.linux.no/source/drivers/net/eepro100.c#L928

In this case, and as far as I understand, the culprit is the eepro100
driver talking to one of the NICs (which one?). Is that correct?

What is the consequence of IRQ10 being shared by eth2 and
by my I/O board?

How can I force Linux to assign different IRQs to every peripheral
if I have free IRQs lines?

Regards.
