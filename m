Return-Path: <linux-kernel-owner+w=401wt.eu-S1757430AbXISJU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430AbXISJU0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 05:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754973AbXISJUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 05:20:14 -0400
Received: from smtp-out.google.com ([216.239.45.13]:4881 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202AbXISJUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 05:20:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=e5RVk79XUtitBxv0ghR3pTZPoBJFOEqbQb0e6/Hp7Rq5iczkMIijX2yqy0cA3lvEe
	VyYjfqFdda/zNQHI7Noag==
Date: Wed, 19 Sep 2007 02:19:45 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Anton Altaparmakov <aia21@cam.ac.uk>
cc: Christoph Lameter <clameter@sgi.com>, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [03/17] is_vmalloc_addr(): Check if an address is within the
 vmalloc boundaries
In-Reply-To: <167F960F-0A93-4263-8AE6-1B0CEBB2C9D1@cam.ac.uk>
Message-ID: <alpine.DEB.0.9999.0709190217530.17127@chino.kir.corp.google.com>
References: <20070919033605.785839297@sgi.com> <20070919033641.009931707@sgi.com> <alpine.DEB.0.9999.0709182329110.6251@chino.kir.corp.google.com> <E1A595D3-FD5B-44EA-A99D-BB581642F0E8@cam.ac.uk> <alpine.DEB.0.9999.0709190103560.12827@chino.kir.corp.google.com>
 <167F960F-0A93-4263-8AE6-1B0CEBB2C9D1@cam.ac.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007, Anton Altaparmakov wrote:

> Although it may cause a problem as highmem.h also includes mm.h so a bit of
> trickery may be needed to get it to compile...
> 
> I suspect that is_vmalloc_addr() should not be in linux/mm.h at all and should
> be in linux/vmalloc.h instead and vmalloc.h should include linux/highmem.h.
> That would be more sensible than sticking a vmalloc related function into
> linux/mm.h where it does not belong...
> 

That is why I suggested include/linux/vmalloc.h as its home in the first 
place.  And no, adding an include for linux/highmem.h (and asm/pgtable.h) 
to linux/vmalloc.h does not work.
