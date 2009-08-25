Return-Path: <linux-kernel-owner+w=401wt.eu-S1754776AbZHYLDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbZHYLDW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 07:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750904AbZHYLDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 07:03:21 -0400
Received: from gate.crashing.org ([63.228.1.57]:55052 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811AbZHYLDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 07:03:20 -0400
Subject: Re: [PATCH 0/3]HTLB mapping for drivers (take 2)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Alexey Korolev <akorolex@gmail.com>, Eric Munson <linux-mm@mgebm.net>,
       Alexey Korolev <akorolev@infradead.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090825104731.GA21335@csn.ul.ie>
References: <alpine.LFD.2.00.0908172317470.32114@casper.infradead.org>
	 <56e00de0908180329p2a37da3fp43ddcb8c2d63336a@mail.gmail.com>
	 <202cde0e0908182248we01324em2d24b9e741727a7b@mail.gmail.com>
	 <20090819100553.GE24809@csn.ul.ie>
	 <202cde0e0908200003w43b91ac3v8a149ec1ace45d6d@mail.gmail.com>
	 <20090825104731.GA21335@csn.ul.ie>
Content-Type: text/plain
Date: Tue, 25 Aug 2009 21:00:54 +1000
Message-Id: <1251198054.15197.40.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-25 at 11:47 +0100, Mel Gorman wrote:

> Why? One hugepage of default size will be one TLB entry. Each hugepage
> after that will be additional TLB entries so there is no savings on
> translation overhead.
> 
> Getting contiguous pages beyond the hugepage boundary is not a matter
> for GFP flags.

Note: This patch reminds me of something else I had on the backburner
for a while and never got a chance to actually implement...

There's various cases of drivers that could have good uses of hugetlb
mappings of device memory. For example, framebuffers.

I looked at it a while back and it occured to me (and Nick) that
ideally, we should split hugetlb and hugetlbfs.

Basically, on one side, we have the (mostly arch specific) populating
and walking of page tables with hugetlb translations, associated huge
VMAs, etc... 

On the other side, hugetlbfs is backing that with memory.

Ideally, the former would have some kind of "standard" ops that
hugetlbfs can hook into for the existing case (moving some stuff out of
the common data structure and splitting it in two), allowing the driver
to instanciate hugetlb VMAs that are backed up by something else,
typically a simple mapping of IOs.

Anybody wants to do that or I keep it on my back burner until the time I
finally get to do it ? :-)

Cheers,
Ben.

