Return-Path: <linux-kernel-owner+w=401wt.eu-S1762818AbXLOXxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762818AbXLOXxe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 18:53:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755764AbXLOXx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 18:53:27 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:45909 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbXLOXx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 18:53:26 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <476468EF.8020201@s5r6.in-berlin.de>
Date: Sun, 16 Dec 2007 00:53:19 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.9) Gecko/20071122 SeaMonkey/1.1.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: memory barriers and MMIO, once again...
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

in a single thread of execution, writel() and friends are ordered WRT
each other.  But I keep forgetting one thing:

Is writel() ordered WRT regular memory accesses?  That is, if I prepare
data in a coherent DMA buffer and then tell the device by writel() that
it's good to go, do I need a wmb() before the writel()?

*If* the answer to this is yes, then I also seem to need a wmb() between
dma_sync_single_for_device() and writel() if that writel tells the
device to use data from that synced DMA area, because the sync expands
to empty inline functions on simple architectures.  Or are there further
ordering guarantees on these architectures which eliminate the need for
a wmb() in this case?  If so, would I still need a barrier()?

Thanks,
-- 
Stefan Richter
-=====-=-=== ==-- =----
http://arcgraph.de/sr/
