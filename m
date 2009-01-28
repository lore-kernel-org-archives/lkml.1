Return-Path: <linux-kernel-owner+w=401wt.eu-S1755392AbZA1K7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbZA1K7m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 05:59:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754650AbZA1K71
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 05:59:27 -0500
Received: from ozlabs.org ([203.10.76.45]:52089 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296AbZA1K70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 05:59:26 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] virtio_net: use correct accessors for scatterlists
Date: Wed, 28 Jan 2009 21:29:18 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: iws@ovro.caltech.edu, linux-kernel@vger.kernel.org, markmc@redhat.com,
       netdev@vger.kernel.org
References: <20090124001053.GA20156@ovro.caltech.edu> <200901271521.19616.rusty@rustcorp.com.au> <20090126.210055.104964648.davem@davemloft.net>
In-Reply-To: <20090126.210055.104964648.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901282129.19364.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 January 2009 15:30:55 David Miller wrote:
> From: Rusty Russell <rusty@rustcorp.com.au>
> Date: Tue, 27 Jan 2009 15:21:19 +1030
> 
> > On Saturday 24 January 2009 10:40:53 Ira Snyder wrote:
> > > Without this fix, virtio_net makes incorrect usage of scatterlists. It sets
> > > the end of the scatterlist chain after the first element, despite the fact
> > > that more entries come after it.
> > > 
> > > If you try to run dma_map_sg() on one of the scatterlists given to you by
> > > add_buf(), you will get a null pointer oops.
> > > 
> > > Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
> > 
> > Thanks, this should go in 2.6.29.  Dave?
> 
> Applied, should I queue it up for -stable too Rusty?

I don't think so.  It really is defined as an sg array, not an sg chain.  I'm happy to apply a little patch to make Ira's ongoing development easier, but no reason to panic about it.

Thanks,
Rusty.
