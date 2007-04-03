Return-Path: <linux-kernel-owner+w=401wt.eu-S2992474AbXDCW7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992474AbXDCW7f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 18:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992481AbXDCW7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 18:59:34 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:59535 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992474AbXDCW7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 18:59:34 -0400
Date: Tue, 3 Apr 2007 15:59:33 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Badari Pulavarty <pbadari@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc5-mm4
In-Reply-To: <1175640812.6185.6.camel@dyn9047017100.beaverton.ibm.com>
Message-ID: <Pine.LNX.4.64.0704031556310.12071@schroedinger.engr.sgi.com>
References: <20070402224745.71a25af7.akpm@linux-foundation.org> 
 <1175632311.6185.1.camel@dyn9047017100.beaverton.ibm.com> 
 <Pine.LNX.4.64.0704031339080.11001@schroedinger.engr.sgi.com>
 <1175640812.6185.6.camel@dyn9047017100.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2007, Badari Pulavarty wrote:

> > > SLUB code hangs my ppc64 machine on boot.
> > 
> > Could you enable NMI or something and get me a stackdump? PPC is notorious 
> > for having strange NUMA issues. Any fallbacks from node 0 on bootstrap? Is 
> > there memory on node 0?
> 
> 
> Seems to be an issue with calibrate_delay() spinning in a tight
> loop :(
> 
> BTW, machine boots fine with SLAB code - not sure why ?

SLUB does not guarantee the special casing that SLAB provides for 
page sized allocations via kmalloc. SLAB aligns page sized allocations on 
page boundaries and does not allow full debugging of page sized 
allocations in order to keep these slabs on page sized boundaries.

I suspect this is related. I could add the same special casing to SLUB. 
But I really wish we would get rid of special slab behavior depending on 
the size of the slab. Maybe there is no way around it. Sigh.

What is the data that calibrate delay is looking at?
