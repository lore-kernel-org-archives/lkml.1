Return-Path: <linux-kernel-owner+w=401wt.eu-S1759001AbXFUHNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759001AbXFUHNZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 03:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755641AbXFUHNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 03:13:16 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50302 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156AbXFUHNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 03:13:15 -0400
Subject: Re: [Intel IOMMU 06/10] Avoid memory allocation
	failures	in	dma	map api calls
From: Peter Zijlstra <peterz@infradead.org>
To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org, ak@suse.de,
       gregkh@suse.de, muli@il.ibm.com, ashok.raj@intel.com,
       davem@davemloft.net, clameter@sgi.com
In-Reply-To: <20070621063730.GC6771@linux-os.sc.intel.com>
References: <1182326799.21117.19.camel@twins>
	 <46792586.20706@linux.intel.com>
	 <20070620173038.GA25516@linux-os.sc.intel.com>
	 <1182362703.21117.79.camel@twins> <46797CB1.8070008@linux.intel.com>
	 <1182370132.21117.84.camel@twins>
	 <20070620230337.GA6771@linux-os.sc.intel.com>
	 <1182406212.21117.94.camel@twins> <467A1679.8090202@linux.intel.com>
	 <1182407374.21117.106.camel@twins>
	 <20070621063730.GC6771@linux-os.sc.intel.com>
Content-Type: text/plain
Date: Thu, 21 Jun 2007 09:13:11 +0200
Message-Id: <1182409991.21117.112.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-20 at 23:37 -0700, Keshavamurthy, Anil S wrote:
> On Thu, Jun 21, 2007 at 08:29:34AM +0200, Peter Zijlstra wrote:
> > On Wed, 2007-06-20 at 23:11 -0700, Arjan van de Ven wrote:
> > > Peter Zijlstra wrote:
> > Also, the other iommu code you pointed me to, was happy to fail, it did
> > not attempt to use the emergency reserves.
> 
> Is the same behavior acceptable here?

I would say it is. Failure is a part of life.

If you have a (small) mempool with 16 pages or so, that should give you
plenty megabytes of io-space to get out of a tight spot. That is, you
can queue many pages with that. If it is depleted you know you have at
least that many pages outstanding. So failing will just delay the next
pages.

Throughput is not a key issue when that low on memory, a guarantee of
progress is.


