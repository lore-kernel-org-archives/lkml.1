Return-Path: <linux-kernel-owner+w=401wt.eu-S1760654AbXGDKPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760654AbXGDKPU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 06:15:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757697AbXGDKPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 06:15:08 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44814 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757669AbXGDKPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 06:15:06 -0400
Subject: Re: [Intel IOMMU 01/10] DMAR detection and parsing logic
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       linux-kernel@vger.kernel.org, ak@suse.de, gregkh@suse.de,
       muli@il.ibm.com, suresh.b.siddha@intel.com, arjan@linux.intel.com,
       ashok.raj@intel.com, davem@davemloft.net, clameter@sgi.com
In-Reply-To: <20070704030440.3f863ecd.akpm@linux-foundation.org>
References: <20070619213701.219910000@askeshav-devel.jf.intel.com>
	 <20070619213808.398170000@askeshav-devel.jf.intel.com>
	 <1183540736.7054.7.camel@twins>
	 <20070704030440.3f863ecd.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 04 Jul 2007 12:14:58 +0200
Message-Id: <1183544098.7054.9.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-04 at 03:04 -0700, Andrew Morton wrote:
> On Wed, 04 Jul 2007 11:18:56 +0200 Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Tue, 2007-06-19 at 14:37 -0700, Keshavamurthy, Anil S wrote:
> > > plain text document attachment (dmar_detection.patch)
> > 
> > > +/**
> > > + * parse_dmar_table - parses the DMA reporting table
> > > + */
> > > +static int __init
> > > +parse_dmar_table(void)
> > > +{
> > > +	struct acpi_table_dmar *dmar;
> > > +	struct acpi_dmar_header *entry_header;
> > > +	int ret = 0;
> > > +
> > > +	dmar = (struct acpi_table_dmar *)dmar_tbl;
> > > +
> > > +	if (!dmar->width) {
> >           ^^^^^^^^^^^^^^^^^^^
> > 
> > That goes *splat* on my opteron box.
> 
> This?
> 
> From: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
> 
> Check for dmar_tbl pointer as this can be NULL on systems with no Intel
> VT-d support.
> 
> Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Ah, that does look sane, I'll test it whenever the next -mm comes
around.

