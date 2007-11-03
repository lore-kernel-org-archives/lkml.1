Return-Path: <linux-kernel-owner+w=401wt.eu-S1755510AbXKCOnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510AbXKCOnf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 10:43:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754294AbXKCOn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 10:43:27 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:43775 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278AbXKCOn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 10:43:26 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <472C88E9.60103@s5r6.in-berlin.de>
Date: Sat, 03 Nov 2007 15:42:49 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Torsten Kaiser <just.for.lkml@googlemail.com>
CC: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: 2.6.24-rc1-54866f032307063776b4eff7eadb131d47f9f9b4 fails to
 boot: kernel BUG at include/linux/scatterlist.h:49!
References: <64bb37e0711021503x4844b905yba1e9a681c4e788a@mail.gmail.com>	 <472BA567.8040301@s5r6.in-berlin.de> <64bb37e0711030614q4be3a2b6j5d3c55b26cb07030@mail.gmail.com>
In-Reply-To: <64bb37e0711030614q4be3a2b6j5d3c55b26cb07030@mail.gmail.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Torsten Kaiser wrote:
> On 11/2/07, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>> To which extent do you need IEEE 1394 drivers?
> 
> Using eth1394 as primary network connection on this computer.
> So switching to the new stack is currently not an option,

That's right.

> Looking that calltrace upwards, it seems replacing the
> memset(dma->sglist,...) with sg_init_table(...) would fix the BUG_ON()
> as that inits the SG_MAGIC.

Yes, this should be the first thing to be fixed.

> But I do not trust myself to fixing all
> the iterators correctly to convert this completely to the new API.

Since ieee1394 doesn't create chained s/g lists, we might even get away
with ieee1394's existing iterators.

(The other place where the 1394 stack deals with s/g lists is sbp2 where
we have to deal with what comes from the SCSI stack or the block layer.
But sbp2's s/g list handling is entirely unrelated to ieee1394's own
code for isochronous I/O and async streams, which eth1394 needs and
caused the bug.)
-- 
Stefan Richter
-=====-=-=== =-== ---=-
http://arcgraph.de/sr/
