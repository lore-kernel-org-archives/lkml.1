Return-Path: <linux-kernel-owner+w=401wt.eu-S937454AbXHIA3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937454AbXHIA3e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 20:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932792AbXHIA3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 20:29:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:62240 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932075AbXHIA27 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 20:28:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,237,1183359600"; 
   d="scan'208";a="276441795"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Introducing paravirt_ops for x86_64
Date: Wed, 8 Aug 2007 17:28:57 -0700
Message-ID: <97D612E30E1F88419025B06CB4CF1BE10326E924@scsmsx412.amr.corp.intel.com>
In-Reply-To: <5d6222a80708080758t1b937d0ej14c5e60ac23a20c5@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Introducing paravirt_ops for x86_64
thread-index: AcfZzI4SjKcz6XZHRsGPDKfz8b/HyAAAV/rw
From: "Nakajima, Jun" <jun.nakajima@intel.com>
To: "Glauber de Oliveira Costa" <glommer@gmail.com>
Cc: "Glauber de Oliveira Costa" <gcosta@redhat.com>,
       <linux-kernel@vger.kernel.org>, <lguest@ozlabs.org>,
       <virtualization@lists.linux-foundation.org>, <chrisw@sous-sol.org>,
       <anthony@codemonkey.ws>, <akpm@linux-foundation.org>, <mingo@elte.hu>
X-OriginalArrivalTime: 09 Aug 2007 00:28:58.0256 (UTC) FILETIME=[46A5D100:01C7DA1C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber de Oliveira Costa wrote:
> On 8/8/07, Nakajima, Jun <jun.nakajima@intel.com> wrote:
> > Glauber de Oliveira Costa wrote:
> > > Hi folks,
> > > 
> > > After some time away from it, and a big rebase as a consequence,
here is
> > > the updated version of paravirt_ops for x86_64, heading to
inclusion.
> > > 
> > > Your criticism is of course, very welcome.
> > > 
> > > Have fun
> > 
> > Do you assume that the kernel ougtht to use 2MB pages for its
mappings
> > (e.g. initilal text/data,  direct mapping of physical memory) under
your
> > paravirt_ops?  As far as I look at the patches, I don't find one.
> 
> I don't think how it could be relevant here. lguest kernel does use
> 2MB pages, and it goes smootly. For 2MB pages, we will update the page
> tables in the very same way, and in the very places we did before.
> Just that the operations can now be overwritten.
> 
> So, unless I'm very wrong,  it only makes sense to talk about not
> supporting large pages in the guest level. But it is not a
> paravirt_ops problem.

Some MMU-related PV techiniques (including Xen, and direct paging mode
for Xen/KVM) need to write-protect page tables, avoiding to use 2MB
pages when mapping page tables. Looks like you did not, and that
exaplains why the patches are missing the relevant (many) paravirt_ops
in include/asm-x86_64/pgalloc.h, for example, compared with the i386
tree. 

Jun
---
Intel Open Source Technology Center
