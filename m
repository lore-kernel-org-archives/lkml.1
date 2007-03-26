Return-Path: <linux-kernel-owner+w=401wt.eu-S933458AbXCZBJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933458AbXCZBJt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 21:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933473AbXCZBJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 21:09:49 -0400
Received: from lazybastard.de ([212.112.238.170]:39621 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933458AbXCZBJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 21:09:45 -0400
Date: Mon, 26 Mar 2007 03:04:45 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: David Lang <david.lang@digitalinsight.com>,
       Thomas Gleixner <tglx@linutronix.de>, Matt Mackall <mpm@selenic.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 00/22 take 3] UBI: Unsorted Block Images
Message-ID: <20070326010443.GF19691@lazybastard.org>
References: <20070319223205.GZ4892@waste.org> <1174351366.13341.739.camel@localhost.localdomain> <20070321110528.GC3785@lazybastard.org> <1174476334.10840.49.camel@localhost.localdomain> <20070325200826.GA19691@lazybastard.org> <Pine.LNX.4.63.0703251338580.13765@qynat.qvtvafvgr.pbz> <20070325225528.GD19691@lazybastard.org> <1174866394.2866.2.camel@shinybook.infradead.org> <20070326000149.GE19691@lazybastard.org> <1174868485.20505.284.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1174868485.20505.284.camel@pmac.infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 March 2007 01:21:25 +0100, David Woodhouse wrote:
> On Mon, 2007-03-26 at 02:01 +0200, Jörn Engel wrote:
> > You can on NAND.  ECC is done in software.  And for a data structure as
> > simple as the 'tally', foregoing ECC is not a huge problem - most
> > bitflips are easily detected and the remaining only cause off-by-a-few
> > on the erase count. 
> 
> You're only allowed a limited number of write cycles to each page
> though. So you can't just clear the bits in a 2112-byte page one at a
> time; typically when you clear the fifth bit, the contents of the whole
> page become undefined until the next erase cycle.

That limitation stems from ECC and ECC is done in software.  Currently
everyone and his dog is doing ECC in chunks of 256 bytes on NAND.  So
your minimum write size is 256 bytes _if you care about ECC_.  If you
don't care, you can write single bits on NAND, just as you can on NOR.

Controlling ECC in software means we are quite flexible.  Given
sufficient incentive, we can change the rules quite significantly.

Jörn

-- 
You can't tell where a program is going to spend its time. Bottlenecks
occur in surprising places, so don't try to second guess and put in a
speed hack until you've proven that's where the bottleneck is.
-- Rob Pike
