Return-Path: <linux-kernel-owner+w=401wt.eu-S1756022AbXLDVQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022AbXLDVQn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 16:16:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755373AbXLDVKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 16:10:05 -0500
Received: from cantor.suse.de ([195.135.220.2]:44149 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755813AbXLDVKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 16:10:00 -0500
From: Andi Kleen <ak@suse.de>
To: Bernhard Kaindl <bkaindl@ffii.org>
Subject: Re: remote debugging via FireWire * __fast__ firedump!
Date: Tue, 4 Dec 2007 08:39:38 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Bernhard Kaindl <bk@suse.de>, linux-kernel@vger.kernel.org
References: <200702101242.48467.ak@suse.de> <45CDCDCD.5000609@s5r6.in-berlin.de> <alpine.DEB.0.9999.0712040426100.3769@vic.ffii.org>
In-Reply-To: <alpine.DEB.0.9999.0712040426100.3769@vic.ffii.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712040839.39984.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 December 2007 04:45:22 am Bernhard Kaindl wrote:
>     I just wanted to let you know that I'll have picked up the early
> firewire patch again and cleaned it up very much so that it should
> be ready to submit it and but it on the patch-submission road.

Nice.

> I have just had the guts to explore __fast__ memory dumping over
> firewire for full-system dumps (reading quadlets is __painfully__
> show if you want to read 2GB of memory over the bus, you only get
> about some some kilobytes each second) using raw1394_start_read()
> to allow also block reads instead of just quatlet reads.

Unfortunately it won't work for >3GB or so AFAIK.

> The biggest block size that worked here was 2048 bytes, which was
> enough to get nearly 10MB/s of data transfer rate from the remote
> memory to disk. Dumping 2GB of remote memory was just a matter of
> about 3 few short minutes which quickly ran by.
>
> Afterwards, the victim was dead (I excluded the low MB of memory,
> so something else must have caused this), at least the start of

Did you run into the PCI memory hole below 4GB? 

I suppose the best way would be to require a System.map and
then read e820.nr_map/e820.map[] and only dump real memory.

-Andi
