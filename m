Return-Path: <linux-kernel-owner+w=401wt.eu-S1758717AbYGQJtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758717AbYGQJtF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 05:49:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757247AbYGQJsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 05:48:45 -0400
Received: from anchor-post-37.mail.demon.net ([194.217.242.87]:32849 "EHLO
	anchor-post-37.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756208AbYGQJso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 05:48:44 -0400
Subject: Re: [PATCH][RFC] slub: increasing order reduces memory usage of
	some key caches
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <cl@linux-foundation.org>, penberg@cs.helsinki.fi,
       mpm@selenic.com, linux-mm <linux-mm@kvack.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20080716195237.GA9127@csn.ul.ie>
References: <1216211371.3122.46.camel@castor.localdomain>
	 <487DF5D4.9070101@linux-foundation.org>  <20080716195237.GA9127@csn.ul.ie>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 10:48:33 +0100
Message-Id: <1216288113.3061.2.camel@castor.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-07-16 at 20:52 +0100, Mel Gorman wrote:
> On (16/07/08 08:21), Christoph Lameter didst pronounce:
> > Richard Kennedy wrote:
> > 
> > 
> > > on my amd64 3 gb ram desktop typical numbers :-
> > > 
> > > [kernel,objects,pages/slab,slabs,total pages,diff]
> > > radix_tree_node
> > > 2.6.26 33922,2,2423 	4846
> > > +patch 33541,4,1165	4660,-186
> > > dentry
> > > 2.6.26	82136,1,4323	4323
> > > +patch	79482,2,2038	4076,-247
> > > the extra dentries would use 136 pages but that still leaves a saving of
> > > 111 pages.
> > 
> > Good numbers....
> > 
> 
> Indeed. clearly internal fragmentation is a problem.
> 
> > > Can anyone suggest any other tests that would be useful to run?
> > > & Is there any way to measure what impact this is having on
> > > fragmentation?
> > 
> > Mel would be able to tell you that but I think we better figure out what went wrong first.
> > 
> 
> For internal fragmentation, there is this crappy script:
> http://www.csn.ul.ie/~mel/intfrag_stat
> 
> run it as intfrag_stat -a and it should tell you what precentage of
> memory is being wasted for dentries. The patch should show a difference
> for the dentries.
> 
> How it would affect external fragmentation is harder to guess. It will
> put more pressure for high-order allocations but at a glance, dentries
> are using GFP_KERNEL so it should not be a major problem.
> /proc/pagetypeinfo is the file to watch. If the count for "reclaimable"
> arenas is higher and climbing over time, it will indiate that external
> fragmentation would eventually become a problem.
> 
Mel,
Thanks for the info & the script. I'll give it a try & see what we get.
Richard


