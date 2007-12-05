Return-Path: <linux-kernel-owner+w=401wt.eu-S1754514AbXLEXyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754514AbXLEXyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 18:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbXLEXyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 18:54:05 -0500
Received: from ns2.suse.de ([195.135.220.15]:53733 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876AbXLEXyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 18:54:04 -0500
Date: Thu, 6 Dec 2007 00:54:01 +0100
From: Nick Piggin <npiggin@suse.de>
To: Pete Zaitcev <zaitcev@redhat.com>
Cc: akpm@linux-foundation.org, paolo.abeni@email.it,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 12/18] usb: mon nopage
Message-ID: <20071205235401.GF5617@wotan.suse.de>
References: <20071205071547.701344000@nick.local0.net> <20071205071628.007537000@nick.local0.net> <20071205083925.c4a8ca64.zaitcev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071205083925.c4a8ca64.zaitcev@redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2007 at 08:39:25AM -0800, Pete Zaitcev wrote:
> On Wed, 05 Dec 2007 18:15:59 +1100, npiggin@suse.de wrote:
> 
> > Convert USB mon driver from nopage to fault.
> 
> >  	if (offset >= rp->b_size)
> > -		return NOPAGE_SIGBUS;
> > +		return VM_FAULT_SIGBUS;
> >  	chunk_idx = offset / CHUNK_SIZE;
> >  	pageptr = rp->b_vec[chunk_idx].pg;
> >  	get_page(pageptr);
> > -	if (type)
> > -		*type = VM_FAULT_MINOR;
> > -	return pageptr;
> > +	vmf->page = pageptr;
> > +	return 0;
> 
> Looks like a trivial change, I ack this. It's a rarely used API, I have
> to run tests to see how it works. I'll collect any failing pieces later
> if any.

That would be great, thanks.


> Signed-off-by: Pete Zaitcev <zaitcev@redhat.com>
> 
> -- Pete
