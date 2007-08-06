Return-Path: <linux-kernel-owner+w=401wt.eu-S1764632AbXHFWtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764632AbXHFWtO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 18:49:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765607AbXHFWsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 18:48:46 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:41792 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765851AbXHFWsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 18:48:45 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46B7A537.9020807@s5r6.in-berlin.de>
Date: Tue, 07 Aug 2007 00:48:23 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.5) Gecko/20070804 SeaMonkey/1.1.3
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Olaf Hering <olh@suse.de>, linuxppc-dev@ozlabs.org, stable@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.22.y] ieee1394: revert "sbp2: enforce 32bit	DMA	mapping"
References: <fa.Qn3Snqoik3hhnxcA6HqjGV0Yzck@ifi.uio.no> <46B4B3DC.7020609@shaw.ca> <46B4B7C6.1040107@s5r6.in-berlin.de> <1186272926.938.8.camel@localhost.localdomain> <46B5824B.1000103@s5r6.in-berlin.de> <1186351473.938.21.camel@localhost.localdomain> <20070806135124.GA2900@suse.de> <1186436848.938.75.camel@localhost.localdomain> <46B79F25.50205@s5r6.in-berlin.de> <46B79FD7.9020801@shaw.ca>
In-Reply-To: <46B79FD7.9020801@shaw.ca>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Stefan Richter wrote:
>> So that's the story why that dma_set_mask went into sbp2:  Sbp2 wants
>> mappings in a _subset_ of the OHCI-1394 controllers DMA range.
>>
>> Anyway.  For now I will simply go with what 2.6.23-rc has and what
>> 2.6.21 had:  No dma_set_mask anywhere in the 1394 subsystem.  We can
>> revisit this whenever an actual need arises.
> 
> Not sure this is a very good idea. This seems rather likely to fail on
> x86_64 machines with >4GB of RAM for example..

I'll deal with it when a bug report comes in.

  1.) The ieee1394 subsystem is known to work on x86_64 with more than 4
GB RAM, so I gather that architecture code already sets a proper DMA
mask for all those 32bit PCI OHCI-1394 implementations out there.

  2.) I haven't heard of an OHCI-1394 chip whose overall DMA range was
bigger than the Physical Range.  There are only two chips, from ALi and
from Fujitsu, whose Physical Range is curiously bigger than the actual
DMA range.
-- 
Stefan Richter
-=====-=-=== =--- --===
http://arcgraph.de/sr/
