Return-Path: <linux-kernel-owner+w=401wt.eu-S1758200AbYFZWj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200AbYFZWj6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 18:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754505AbYFZWjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 18:39:43 -0400
Received: from mga12.intel.com ([143.182.124.36]:33883 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755362AbYFZWjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 18:39:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,710,1204531200"; 
   d="scan'208";a="3267967"
From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
To: linux-usb-devel@lists.sourceforge.net
Subject: Re: Scatter-gather list constraints
Date: Thu, 26 Jun 2008 15:39:25 -0700
User-Agent: KMail/1.9.9
Cc: Alan Stern <stern@rowland.harvard.edu>,
       David Vrabel <david.vrabel@csr.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       AntonioLin <antonio.lin@alcormicro.com>, linux-usb@vger.kernel.org
References: <Pine.LNX.4.44L0.0806261531440.3893-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0806261531440.3893-100000@iolanthe.rowland.org>
Organization: Intel Corporation
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806261539.27469.inaky@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 June 2008, Alan Stern wrote:
> On Thu, 26 Jun 2008, Perez-Gonzalez, Inaky wrote:
> 
> > For WA, when we get a buffer to be sent from a URB, it has to be split
> > in chunks, each chunk has a header added. So we end up with a list of
> > chunks, most of them quite small. Each requires a single URB to send.
> > resources galore.
> > 
> > If we could queue all those, the overhead would be reduced to allocating
> > the headers (possibly in a continuous array) and the sg "descriptors"
> > to describe the whole thing.
> > 
> > However, the alignment stuff somebody mentioned in another email in this
> > thread might cause problems.
> > 
> > At the end it might not be all that doable (I might be missing some
> > subtle isssues), but it is well worth a look.
> > 
> > >Note that usbcore already contains a scatter-gather library.
> > >(Unfortunately the library is limited in usefulness because it needs to
> > >run in process context.)
> > 
> > And the overhead of one URB per sg "node" kills it's usability for
> > WAs.
> 
> For this case (lots of small chunks making up a single URB), using a 
> bounce buffer might well be the easiest solution.  It depends on the 
> size of the URB and the number and sizes of the small chunks.  There 
> would be a lot less overhead -- only one URB -- and one large memory
> allocation instead of lots of small ones.

That's what we have right now (if I rememeber correctly); the issue
is that you end up copying A LOT. I don't know, maybe I am just being
overperfectionist. The data chunks (segments) can be up to (digs)
3584 [from 512, in 512 increments] if I am reading the spec right 
(WUSB1.0 4.5.1). Interleaving that with small chunks and change...
I don't know if that much copying will end up being that good, along
with the allocations it requires, etc.

-- 
Inaky
