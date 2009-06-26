Return-Path: <linux-kernel-owner+w=401wt.eu-S1754378AbZFZHl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378AbZFZHl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 03:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752955AbZFZHlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 03:41:19 -0400
Received: from gir.skynet.ie ([193.1.99.77]:45321 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408AbZFZHie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 03:38:34 -0400
Date: Fri, 26 Jun 2009 08:38:36 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Jerome Glisse <glisse@freedesktop.org>
cc: Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: TTM page pool allocator
In-Reply-To: <1246001515.2312.3.camel@localhost>
Message-ID: <alpine.DEB.2.00.0906260836280.26643@skynet.skynet.ie>
References: <1245931298.13359.8.camel@localhost.localdomain> <21d7e9970906251700n5f5fbd07ke24022b576b1770b@mail.gmail.com> <1246001515.2312.3.camel@localhost>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> I think it's better to fix userspace to not allocate as much buffer per
> frame as it does now rather than having a pool of wb pages, i removed
> it because on my 64M box memory is getting tight, we need to compute
> the number of page we still based on memory. Also i think it's ok
> to assume that page allocation is fast enough.

Yup we could try decreasing the DMA buffer size, I think the DMA buffer 
would be a lot better suited to suballocation, doing individual bo allocs 
like the code used to was a major hit, assuming page alloc is fast enough 
isn't valid since I've already proved it was a major CPU user when I fixed 
it the first time :)

The problem with making the dma buffer smaller is the having a buffer 
mapped and sent to the kernel for relocs.

Dave.
