Return-Path: <linux-kernel-owner+w=401wt.eu-S1755484AbXLDWfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbXLDWfj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 17:35:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754832AbXLDWfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 17:35:20 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:34716 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098AbXLDWfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 17:35:18 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4755D612.1090103@s5r6.in-berlin.de>
Date: Tue, 04 Dec 2007 23:34:58 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.9) Gecko/20071122 SeaMonkey/1.1.6
MIME-Version: 1.0
To: Bernhard Kaindl <bkaindl@ffii.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>, Andi Kleen <ak@suse.de>,
       Bernhard Kaindl <bk@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: remote debugging via FireWire * __fast__ firedump!
References: <200702101242.48467.ak@suse.de> <45CDCDCD.5000609@s5r6.in-berlin.de> <alpine.DEB.0.9999.0712040426100.3769@vic.ffii.org> <4755D186.20204@s5r6.in-berlin.de>
In-Reply-To: <4755D186.20204@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Bernhard Kaindl wrote:
>> The biggest block size that worked here was 2048 bytes, which was
>> enough to get nearly 10MB/s of data transfer rate from the remote
>> memory to disk.
> 
> The maximum payload size of block requests depends on three things:
> 1. speed of the connection between the two nodes (debugged machine and
> debugging machine), 2. link layer controllers of the two nodes, 3.
> software on the debugging machine.
> 
> 1.) S100: 512 bytes, S200: 1024 bytes, S400: 2048 bytes, S800 and more:
> 4096 bytes.

PS:
If there are only 1394a nodes, you can read the connection speed from
the speed map registers on the debugging machine.  It becomes difficult
for 1394b nodes and some mixtures of 1394a and b nodes.  But consumer
1394b hardware is always S800 capable.  Consumer 1394a hardware is
always S400 capable.  Except consumer camcorders which are AFAIK
typically limited to S100, but they have only one port and will
therefore never sit between debugging and debugged PC.  So it's not as
difficult in 99.9% of the cases:  You can expect S400, some people might
get S800.  But you can't use the bigger S800 block size if the debugging
machine runs ohci1394.

> 2.) Controllers on CardBus cards are limited to 1024 bytes payload of
> asynchronous packets, for reasons I don't know.  The other available
> controllers only have the above mentioned speed-dependent limit.

This is relevant if the debugging or the debugged PC have a CardBus
card.  Actually this is the limit of all 1394a CardBus card I have seen;
I don't know about 1394b CardBus cards, or Express cards.  (I suppose
Express cards have no limits of this kind, as they are just PCIe cards
in a different formfactor.)

This payload limitation of the link can be read from the bus info blocks
of the debugged and the debugging machine.  Though I am not entirely
sure right now if the ohci1394_earlyinit driven machine will have its
bus info block properly set up.
-- 
Stefan Richter
-=====-=-=== ==-- --=--
http://arcgraph.de/sr/
