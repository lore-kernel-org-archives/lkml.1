Return-Path: <linux-kernel-owner+w=401wt.eu-S1755918AbXLUUZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918AbXLUUZS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 15:25:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457AbXLUUZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 15:25:06 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:41177 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870AbXLUUZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 15:25:04 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <476C20F9.1@s5r6.in-berlin.de>
Date: Fri, 21 Dec 2007 21:24:25 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: akepner@sgi.com
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>, grundler@parisc-linux.org,
       jbarnes@virtuousgeek.org, jes@sgi.com, randy.dunlap@oracle.com,
       rdreier@cisco.com, James.Bottomley@steeleye.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] dma: passing "attributes" to dma_map_* routines
References: <20071218001758.GO21916@sgi.com> <4767FA62.9060002@s5r6.in-berlin.de> <20071218200759.GE412@sgi.com> <1198184185.6779.16.camel@pasglop> <20071221180022.GW412@sgi.com>
In-Reply-To: <20071221180022.GW412@sgi.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

akepner@sgi.com wrote:
> On Fri, Dec 21, 2007 at 07:56:25AM +1100, Benjamin Herrenschmidt wrote:
>> ...
>> Can't you just have a primitive to sync things up that you call
>> explicitely from your driver after fetching a new status entry ?
> 
> Well, the only mechanisms I know to get things synced are the ones 
> I mentioned before: 1) generate an interrupt, 2) write to memory 
> which has the "barrier" attribute. Obviously 1 is out - giving  
> the memory used for status indications the barrier attribute is 
> the most primitive means I'm aware of.

I don't know what it is in detail what Arthur et al are facing, but this
is how it looks to me:

A sync call like Benjamin suggests has two preconditions.

  1. The interconnect hardware actually offers such a functionality.
I.e. there is a way for the CPU to request flushing of pending DMAs, and
the interconnect is able to generate an interrupt to signal when it is done.

  2. The protocols which the devices use are suitable for this.  I.e.
 there are no race conditions during the window between when the DMAs
were flushed and when the CPU has finished reading the status memory area.

Even _if_ both is true, a regime with such a call would obviously be
more complex and might be harder to get to perform well, compared to the
regime where the interconnect hardware is told beforehand that some
particular DMA writes must never be reordered relative to earlier and
later DMA writes.
-- 
Stefan Richter
-=====-=-=== ==-- =-=-=
http://arcgraph.de/sr/
