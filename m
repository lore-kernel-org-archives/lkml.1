Return-Path: <linux-kernel-owner+w=401wt.eu-S1763780AbXJEUbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763780AbXJEUbV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 16:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760057AbXJEUbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 16:31:12 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:59507 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760238AbXJEUbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 16:31:11 -0400
Subject: Re: 2.6.23-rc9: Oops in cache_alloc_refill()  mm/slab.c
From: Mingming Cao <cmm@us.ibm.com>
Reply-To: cmm@us.ibm.com
To: Badari Pulavarty <pbadari@gmail.com>
Cc: Valerie Clement <valerie.clement@bull.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ext4 development <linux-ext4@vger.kernel.org>
In-Reply-To: <1191596057.6106.106.camel@dyn9047017100.beaverton.ibm.com>
References: <4705113A.7030908@bull.net>
	 <1191534231.6106.99.camel@dyn9047017100.beaverton.ibm.com>
	 <47063EF3.4050302@bull.net>
	 <1191596057.6106.106.camel@dyn9047017100.beaverton.ibm.com>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Fri, 05 Oct 2007 13:30:52 -0700
Message-Id: <1191616252.3861.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-33.el5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-10-05 at 07:54 -0700, Badari Pulavarty wrote:
> On Fri, 2007-10-05 at 15:41 +0200, Valerie Clement wrote:
> > Badari Pulavarty wrote:
> > > On Thu, 2007-10-04 at 18:13 +0200, Valerie Clement wrote:
> > >> While running ffsb tests on my ext4 filesystem, I got an Oops in 
> > >> cache_alloc_refill().
> > >> I turned on SLAB debugging and here is the message I got:
> > >>
> > >> slab: Internal list corruption detected in cache 'buffer_head'(30), 
> > >> slabp ffff81007e100100(1515870810). Hexdump:
> > > 
> > > slabp->inuse = 1515870810 looks bogus. Is this easily reproducible ?
> > 
> > Hi Badari,
> > Thanks for your answer.
> > I didn't reproduce it without the latest ext4 patches. So I suspect a 
> > bug in one of them.
> > But how debugging this?
> > Which other debug traces can I turn on?
> 
> Let me understand. You applied latest ext4 patchsets ? If so, Mingming
> has some slab-cleanup changes in the patchset. You can try backing them
> out and see. 
> 

It's unlikely to be the jbd_slab_cleanup.patch, which actually get rid
of slab allocation for buffers passing down to disk IO, and replace with
get_free_page directly.

Could you send me the profile used for ffsb test?

Thanks,
Mingming

