Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965819Ab0BZTPG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 14:15:06 -0500
Received: from mail.digidescorp.com ([66.244.163.200]:47100 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965809Ab0BZTPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 14:15:04 -0500
X-Spam-Processed: digidescorp.com, Fri, 26 Feb 2010 13:15:03 -0600
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=16730ac33d=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Subject: Re: Buggy variable-length array code...or compiler?
From: "Steven J. Magnani" <steve@digidescorp.com>
Reply-To: steve@digidescorp.com
To: Dan Carpenter <error27@gmail.com>
Cc: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
       microblaze-uclinux@itee.uq.edu.au, dan.j.williams@intel.com,
       Dave Hansen <dave@linux.vnet.ibm.com>
In-Reply-To: <20100226102745.GC8417@bicker>
References: <1267139849.3079.68.camel@iscandar.digidescorp.com>
	 <alpine.DEB.2.00.1002251544120.25189@chino.kir.corp.google.com>
	 <20100226102745.GC8417@bicker>
Content-Type: text/plain
Organization: Digital Design Corporation
Date: Fri, 26 Feb 2010 13:15:01 -0600
Message-Id: <1267211701.3124.204.camel@iscandar.digidescorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Feb 2010, Steven J. Magnani wrote:
> > 
> > > When I run a memcpy dmatest with a Microblaze 2.6.33 noMMU kernel, the
> > > system crashes after about 400 iterations. After much head scratching, I
> > > believe I've narrowed the problem to this fragment of code in
> > > drivers/dma/dmatest.c:
> > > 
> > > static int dmatest_func(void *data)
> > > {
> > > ...
> > >     int                     src_cnt;
> > >     int                     dst_cnt;
> > > ...
> > >     if (thread->type == DMA_MEMCPY)
> > >             src_cnt = dst_cnt = 1;
> > > ...
> > >     while (!kthread_should_stop()
> > >            && !(iterations && total_tests >= iterations)) {
> > > ...
> > >             dma_addr_t dma_srcs[src_cnt];
> > >             dma_addr_t dma_dsts[dst_cnt];
> > > ...

On Thu, Feb 25, 2010 at 03:46:48PM -0800, David Rientjes wrote:
> > This could probably become the first kernel user of the flexible array 
> > library (see Documentation/flexible-arrays.txt).  Dan?
> > --

On Fri, 2010-02-26 at 13:27 +0300, Dan Carpenter wrote:
> I think the max that src_cnt can be is 3 and the most dst_cnt can be is 2.  
> We could just put that there.

src_cnt is dependent on module parameters.

The bug goes away if dma_srcs and dma_dsts are declared outside the
loop, but that requires knocking the loop in another tabstop. At that
point dmatest_func() would be begging for refactoring.

Regards,
------------------------------------------------------------------------
 Steven J. Magnani               "I claim this network for MARS!
 www.digidescorp.com              Earthling, return my space modulator!"

 #include <standard.disclaimer>



