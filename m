Return-Path: <linux-kernel-owner+w=401wt.eu-S1759398AbZGAC4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759398AbZGAC4I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 22:56:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755266AbZGACz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 22:55:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:16252 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754654AbZGACz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 22:55:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,320,1243839600"; 
   d="scan'208";a="471035095"
Date: Wed, 1 Jul 2009 10:55:58 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mel@csn.ul.ie" <mel@csn.ul.ie>, "Zhao, Yakui" <yakui.zhao@intel.com>
Subject: Re: +
	memory-hotplug-alloc-page-from-other-node-in-memory-online.patch
	added to -mm tree
Message-ID: <20090701025558.GA28524@sli10-desk.sh.intel.com>
References: <200906291949.n5TJnuov028806@imap1.linux-foundation.org> <alpine.DEB.1.10.0906291804340.21956@gentwo.org> <20090630004735.GA21254@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090630004735.GA21254@sli10-desk.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 08:47:35AM +0800, Shaohua Li wrote:
> On Tue, Jun 30, 2009 at 06:07:16AM +0800, Christoph Lameter wrote:
> > On Mon, 29 Jun 2009, akpm@linux-foundation.org wrote:
> > 
> > > To initialize hotadded node, some pages are allocated.  At that time, the
> > > node hasn't memory, this makes the allocation always fail.  In such case,
> > > let's allocate pages from other nodes.
> > 
> > Thats bad. Could you populate the buddy list with some large pages from
> > the  beginning of the node instead of doing this special casing? The
> > vmemmap and other stuff really should come from the node that is added.
> > Otherwise off node memory accesses will occur constantly for processors on
> > that node.
> Ok, this is preferred. But the node hasn't any memory present at that time,
> let me check how could we do it.
Hi Christoph,
Looks this is quite hard. Memory of the node isn't added into buddy. At that
time (sparse-vmmem init) buddy for the node isn't initialized and even page struct
for the hotadded memory isn't prepared too. We need something like bootmem
allocator to get memory ...
