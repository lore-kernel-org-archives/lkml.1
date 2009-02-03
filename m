Return-Path: <linux-kernel-owner+w=401wt.eu-S1757455AbZBCBef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455AbZBCBef (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 20:34:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753300AbZBCBeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 20:34:15 -0500
Received: from mga10.intel.com ([192.55.52.92]:7941 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753152AbZBCBeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 20:34:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,368,1231142400"; 
   d="scan'208";a="662184132"
Subject: Re: [patch] SLQB slab allocator
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Hugh Dickins <hugh@veritas.com>,
       Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lin Ming <ming.m.lin@intel.com>
In-Reply-To: <alpine.DEB.1.10.0902020955490.1549@qirst.com>
References: <20090121143008.GV24891@wotan.suse.de>
	 <Pine.LNX.4.64.0901211705570.7020@blonde.anvils>
	 <84144f020901220201g6bdc2d5maf3395fc8b21fe67@mail.gmail.com>
	 <Pine.LNX.4.64.0901221239260.21677@blonde.anvils>
	 <Pine.LNX.4.64.0901231357250.9011@blonde.anvils>
	 <1233545923.2604.60.camel@ymzhang>
	 <1233565214.17835.13.camel@penberg-laptop>
	 <alpine.DEB.1.10.0902020955490.1549@qirst.com>
Content-Type: text/plain
Date: Tue, 03 Feb 2009 09:34:04 +0800
Message-Id: <1233624844.2604.106.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-02 at 10:00 -0500, Christoph Lameter wrote:
> On Mon, 2 Feb 2009, Pekka Enberg wrote:
> 
> > Hi Yanmin,
> >
> > On Mon, 2009-02-02 at 11:38 +0800, Zhang, Yanmin wrote:
> > > Can we add a checking about free memory page number/percentage in function
> > > allocate_slab that we can bypass the first try of alloc_pages when memory
> > > is hungry?
> >
> > If the check isn't too expensive, I don't any reason not to. How would
> > you go about checking how much free pages there are, though? Is there
> > something in the page allocator that we can use for this?
> 
> If the free memory is low then reclaim needs to be run to increase the
> free memory.
I think reclaim did start often with Hugh's case. There would be no swap if not.

>  Falling back immediately incurs the overhead of going through
> the order 0 queues.
The falling back is temporal. Later on when there is enough free pages available,
new slab allocations go back to higher order automatically. This is to save the first
high-order allocation try because it often fails if memory is hungry.


