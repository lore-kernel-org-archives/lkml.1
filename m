Return-Path: <linux-kernel-owner+w=401wt.eu-S1753577AbXCZKCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbXCZKCp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 06:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753576AbXCZKCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 06:02:45 -0400
Received: from www.osadl.org ([213.239.205.134]:49996 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753575AbXCZKCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 06:02:43 -0400
Subject: Re: [PATCH 00/22 take 3] UBI: Unsorted Block Images
From: Thomas Gleixner <tglx@linutronix.de>
To: David Woodhouse <dwmw2@infradead.org>
Cc: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
       David Lang <david.lang@digitalinsight.com>,
       Matt Mackall <mpm@selenic.com>, Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Artem Bityutskiy <dedekind@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>
In-Reply-To: <1174902357.20505.292.camel@pmac.infradead.org>
References: <20070319223205.GZ4892@waste.org>
	 <1174351366.13341.739.camel@localhost.localdomain>
	 <20070321110528.GC3785@lazybastard.org>
	 <1174476334.10840.49.camel@localhost.localdomain>
	 <20070325200826.GA19691@lazybastard.org>
	 <Pine.LNX.4.63.0703251338580.13765@qynat.qvtvafvgr.pbz>
	 <20070325225528.GD19691@lazybastard.org>
	 <1174866394.2866.2.camel@shinybook.infradead.org>
	 <20070326000149.GE19691@lazybastard.org>
	 <1174868485.20505.284.camel@pmac.infradead.org>
	 <20070326010443.GF19691@lazybastard.org>
	 <1174902357.20505.292.camel@pmac.infradead.org>
Content-Type: text/plain; charset=utf-8
Date: Mon, 26 Mar 2007 12:02:40 +0200
Message-Id: <1174903360.4182.25.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-26 at 10:45 +0100, David Woodhouse wrote:
> On Mon, 2007-03-26 at 03:04 +0200, Jörn Engel wrote:
> > That limitation stems from ECC and ECC is done in software.  Currently
> > everyone and his dog is doing ECC in chunks of 256 bytes on NAND.  So
> > your minimum write size is 256 bytes _if you care about ECC_.  If you
> > don't care, you can write single bits on NAND, just as you can on NOR.
> 
> No, on NAND flash it's a limitation of the hardware. The number of write
> cycles you can perform to a given page is limited. Exceed it and the
> contents of that page become undefined due to leakage, until you next
> erase it. 

Right and you cannot write to random locations in a page. The write
chunks have to be in consecutive order. If you write 0xAA to offset 0,
you cannot rewrite it to 0x00 later without risking corruption.

	tglx


