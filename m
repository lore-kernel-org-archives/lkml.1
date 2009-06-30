Return-Path: <linux-kernel-owner+w=401wt.eu-S1756369AbZF3OWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369AbZF3OWj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 10:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbZF3OWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 10:22:31 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:34012 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752840AbZF3OWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 10:22:31 -0400
Date: Tue, 30 Jun 2009 10:21:34 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Shaohua Li <shaohua.li@intel.com>
cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       "mel@csn.ul.ie" <mel@csn.ul.ie>, "Zhao, Yakui" <yakui.zhao@intel.com>
Subject: Re: + memory-hotplug-update-zone-pcp-at-memory-online.patch added
 to -mm tree
In-Reply-To: <20090630005828.GC21254@sli10-desk.sh.intel.com>
Message-ID: <alpine.DEB.1.10.0906301020420.6124@gentwo.org>
References: <200906291949.n5TJno8X028680@imap1.linux-foundation.org> <alpine.DEB.1.10.0906291814150.21956@gentwo.org> <20090630005828.GC21254@sli10-desk.sh.intel.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jun 2009, Shaohua Li wrote:

> > foreach possible cpu?
> Just follows zone_pcp_init(), do you think we should change that too?

I plan to change that but for now this would be okay.

> > > +		struct per_cpu_pageset *pset;
> > > +		struct per_cpu_pages *pcp;
> > > +
> > > +		pset = zone_pcp(zone, cpu);
> > > +		pcp = &pset->pcp;
> > > +
> > > +		local_irq_save(flags);
> > > +		free_pages_bulk(zone, pcp->count, &pcp->list, 0);
> >
> > There are no pages in the pageset since the pcp batch is zero right?
> It might not be zero for a populated zone, see above comments.

But you are populating an unpopulated zone?

