Return-Path: <linux-kernel-owner+w=401wt.eu-S1756877AbYHVSKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877AbYHVSKn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 14:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755307AbYHVSKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 14:10:34 -0400
Received: from mail2.shareable.org ([80.68.89.115]:37530 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760AbYHVSKd (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 14:10:33 -0400
Date: Fri, 22 Aug 2008 19:10:29 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Greg Ungerer <gerg@snapgear.com>
Cc: Jared Hulbert <jaredeh@gmail.com>, Linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>, tim.bird@AM.SONY.COM,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
Subject: Re: [PATCH 00/10] AXFS: Advanced XIP filesystem
Message-ID: <20080822181029.GA24179@shareable.org>
References: <48AD00C4.6060302@gmail.com> <20080821110749.GA1926@shareable.org> <48ADFE65.1050007@snapgear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48ADFE65.1050007@snapgear.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Ungerer wrote:
> 
> Jamie Lokier wrote:
> >Jared Hulbert wrote:
> >>The biggest improvement is in the way AXFS allows for each page to be XIP 
> >>or
> >>not.  First, a user collects information about which pages are accessed 
> >>on a
> >>compressed image for each mmap()ed region from /proc/axfs/volume0.  That
> >>'profile' is used as an input to the image builder.  The resulting image 
> >>has
> >>only the relevant pages uncompressed and XIP.  The result is smaller 
> >>memory
> >>sizes and faster launches.
> >
> >Sounds great, really nice idea.
> >
> >How does it fare with no MMU?  Can the profiler and image builder lay
> >out the XIP pages in such a way that no-MMU mmaps can map those regions?
> 
> The key for XIP on noMMU would be the ability to store a
> file as one complete contiguous chunk. Can AXFS do this?

Or more generally, the mmap'd parts of a file.

XIP doesn't mmap the whole file, it just maps the code and rodata.
The data segment is copied.

AXFS's magic for keeping parts of the file uncompressed, but parts
compressed, would be good for this - both for space saving, and also
because decompressing compressed data from NOR is faster than reading
uncompressed data.

-- Jamie
