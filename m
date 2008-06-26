Return-Path: <linux-kernel-owner+w=401wt.eu-S1763351AbYFZTnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763351AbYFZTnX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 15:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760540AbYFZTeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 15:34:20 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34800 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761724AbYFZTeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 15:34:18 -0400
Date: Thu, 26 Jun 2008 15:34:17 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>
cc: David Vrabel <david.vrabel@csr.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       AntonioLin <antonio.lin@alcormicro.com>, <linux-usb@vger.kernel.org>,
       <inaky@linux.intel.com>
Subject: RE: Scatter-gather list constraints
In-Reply-To: <C72DEB015BA7724783363DE1AF6B0F980510C8BB@orsmsx417.amr.corp.intel.com>
Message-ID: <Pine.LNX.4.44L0.0806261531440.3893-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2008, Perez-Gonzalez, Inaky wrote:

> For WA, when we get a buffer to be sent from a URB, it has to be split
> in chunks, each chunk has a header added. So we end up with a list of
> chunks, most of them quite small. Each requires a single URB to send.
> resources galore.
> 
> If we could queue all those, the overhead would be reduced to allocating
> the headers (possibly in a continuous array) and the sg "descriptors"
> to describe the whole thing.
> 
> However, the alignment stuff somebody mentioned in another email in this
> thread might cause problems.
> 
> At the end it might not be all that doable (I might be missing some
> subtle isssues), but it is well worth a look.
> 
> >Note that usbcore already contains a scatter-gather library.
> >(Unfortunately the library is limited in usefulness because it needs to
> >run in process context.)
> 
> And the overhead of one URB per sg "node" kills it's usability for
> WAs.

For this case (lots of small chunks making up a single URB), using a 
bounce buffer might well be the easiest solution.  It depends on the 
size of the URB and the number and sizes of the small chunks.  There 
would be a lot less overhead -- only one URB -- and one large memory
allocation instead of lots of small ones.

Alan Stern

