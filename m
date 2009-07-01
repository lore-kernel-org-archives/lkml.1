Return-Path: <linux-kernel-owner+w=401wt.eu-S1760236AbZGADiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760236AbZGADiS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 23:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754777AbZGADiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 23:38:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:33911 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915AbZGADiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 23:38:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,320,1243839600"; 
   d="scan'208";a="426723333"
Subject: Re: +
	memory-hotplug-alloc-page-from-other-node-in-memory-online.patch	added to
	-mm tree
From: yakui <yakui.zhao@intel.com>
To: "Li, Shaohua" <shaohua.li@intel.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mel@csn.ul.ie" <mel@csn.ul.ie>
In-Reply-To: <20090701025558.GA28524@sli10-desk.sh.intel.com>
References: <200906291949.n5TJnuov028806@imap1.linux-foundation.org>
	 <alpine.DEB.1.10.0906291804340.21956@gentwo.org>
	 <20090630004735.GA21254@sli10-desk.sh.intel.com>
	 <20090701025558.GA28524@sli10-desk.sh.intel.com>
Content-Type: text/plain
Date: Wed, 01 Jul 2009 11:39:03 +0800
Message-Id: <1246419543.18688.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-01 at 10:55 +0800, Li, Shaohua wrote:
> On Tue, Jun 30, 2009 at 08:47:35AM +0800, Shaohua Li wrote:
> > On Tue, Jun 30, 2009 at 06:07:16AM +0800, Christoph Lameter wrote:
> > > On Mon, 29 Jun 2009, akpm@linux-foundation.org wrote:
> > > 
> > > > To initialize hotadded node, some pages are allocated.  At that time, the
> > > > node hasn't memory, this makes the allocation always fail.  In such case,
> > > > let's allocate pages from other nodes.
> > > 
> > > Thats bad. Could you populate the buddy list with some large pages from
> > > the  beginning of the node instead of doing this special casing? The
> > > vmemmap and other stuff really should come from the node that is added.
> > > Otherwise off node memory accesses will occur constantly for processors on
> > > that node.
> > Ok, this is preferred. But the node hasn't any memory present at that time,
> > let me check how could we do it.
> Hi Christoph,
> Looks this is quite hard. Memory of the node isn't added into buddy. At that
> time (sparse-vmmem init) buddy for the node isn't initialized and even page struct
> for the hotadded memory isn't prepared too. We need something like bootmem
> allocator to get memory ...
Agree with what Shaohua said.
If we can't allocate memory from other node when there is no memory on
this node, we will have to do something like the bootmem allocator.
After the memory page is added to the system memory, we will have to
free the memory space used by the memory allocator. At the same time we
will have to assure that the hot-plugged memory exists physically. 

thanks.
   Yakui

