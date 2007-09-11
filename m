Return-Path: <linux-kernel-owner+w=401wt.eu-S1763283AbXIKLRF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763283AbXIKLRF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 07:17:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761006AbXIKLQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 07:16:55 -0400
Received: from brick.kernel.dk ([87.55.233.238]:27272 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754481AbXIKLQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 07:16:54 -0400
Date: Tue, 11 Sep 2007 13:25:27 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: David Howells <dhowells@redhat.com>
Cc: Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Ungerer <gerg@snapgear.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] splice: Disable vmsplice on nommu.
Message-ID: <20070911112526.GK15405@kernel.dk>
References: <20070911093510.GA15405@kernel.dk> <20070911082307.GB19495@linux-sh.org> <9949.1189505419@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9949.1189505419@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11 2007, David Howells wrote:
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > It's a bit of a sledge hammer... Since get_user_pages() appears to work
> > on nummu, we can just disable the vmsplice-to-userspace bits and leave
> > the (working) vmsplice-from-userspace in place.
> 
> That sounds about right.  I don't think you can do the latter without
> an MMU, but I may be wrong about what it does.

You mean the former? The latter is vmsplice() filling a pipe with user
pages, using get_user_pages() to set them up. And that looks like it
should work on nommu.

The former is vmsplice() using mmap like functionality to map pages into
a user vma.

Just making sure we agree :-)

-- 
Jens Axboe

