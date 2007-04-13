Return-Path: <linux-kernel-owner+w=401wt.eu-S1754117AbXDMSHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbXDMSHy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 14:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754118AbXDMSHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 14:07:54 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:36960 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754117AbXDMSHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 14:07:53 -0400
Date: Fri, 13 Apr 2007 11:07:52 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Badari Pulavarty <pbadari@gmail.com>
cc: ak@suse.de, Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cache_k8_northbridges() overflows beyond allocation
 (Was: 2.6.21-rc5-mm4 (SLUB))
In-Reply-To: <1176477222.8559.4.camel@dyn9047017100.beaverton.ibm.com>
Message-ID: <Pine.LNX.4.64.0704131105570.20347@schroedinger.engr.sgi.com>
References: <20070402224745.71a25af7.akpm@linux-foundation.org> 
 <1175637332.6185.4.camel@dyn9047017100.beaverton.ibm.com> 
 <1175642398.6185.9.camel@dyn9047017100.beaverton.ibm.com> 
 <Pine.LNX.4.64.0704031626020.12109@schroedinger.engr.sgi.com> 
 <1175643507.6185.12.camel@dyn9047017100.beaverton.ibm.com> 
 <Pine.LNX.4.64.0704031638570.12109@schroedinger.engr.sgi.com> 
 <1175644314.6185.18.camel@dyn9047017100.beaverton.ibm.com> 
 <Pine.LNX.4.64.0704031653060.12109@schroedinger.engr.sgi.com> 
 <1175698437.6185.21.camel@dyn9047017100.beaverton.ibm.com> 
 <Pine.LNX.4.64.0704040946370.24640@schroedinger.engr.sgi.com> 
 <1175709755.6185.34.camel@dyn9047017100.beaverton.ibm.com> 
 <Pine.LNX.4.64.0704041103060.26866@schroedinger.engr.sgi.com>
 <1176477222.8559.4.camel@dyn9047017100.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2007, Badari Pulavarty wrote:

> On Wed, 2007-04-04 at 11:04 -0700, Christoph Lameter wrote:
> > On Wed, 4 Apr 2007, Badari Pulavarty wrote:
> ...
> > 
> > > *** SLUB: Freepointer corrupt in kmalloc-16@0xffff810173f172a0 Slab
> > > 0xffff81017f9f8b80
> > >     offset=672 flags=0x2000000000000c7 inuse=42
> > > freelist=0xffff810173f172a0
> > >   Bytes b4 0xffff810173f17290:  a0 72 f1 73 00 00 00 00 00 00 00 00 00
> > > 00 00 00 .r\uffffs............
> > >     Object 0xffff810173f172a0:  00 00 00 00 01 81 ff ff 00 00 00 00 00
> > > 00 00 00 ......\uffff\uffff........
> > > FreePointer 0xffff810173f172a0 -> 0xffff810100000000
> > 
> 
> Found it !! After a painful capture of all the kmalloc-16 slab
> allocations (400+) so far and auditing some of them, found the
> culprit - who writes beyond its allocation, causing the slab
> corruption.

Thanks. I am sorry that this was not easier for you. But as a result I 
thoroughly tested the slab corruption detection in SLUB yesterday found 
various issues and submitted  patches to Andrew that will make this 
really work well. Too late for you though.
