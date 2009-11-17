Return-Path: <linux-kernel-owner+w=401wt.eu-S1754877AbZKQIgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbZKQIgo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 03:36:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754591AbZKQIgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 03:36:43 -0500
Received: from smtp-out.google.com ([216.239.45.13]:23736 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666AbZKQIgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 03:36:42 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=ojLMoEHp5jBVN9ODo8VfrN2zXLZk0cDj2sC/pFtKfYz7ihBAqauA+CLskQEdlavU8
	dFObOsrp8GT9U4A6W0H+w==
Date: Tue, 17 Nov 2009 00:36:38 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/7] Kill PF_MEMALLOC abuse
In-Reply-To: <20091117172802.3DF4.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0911170034500.22639@chino.kir.corp.google.com>
References: <20091117161551.3DD4.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.0911170004380.1564@chino.kir.corp.google.com> <20091117172802.3DF4.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Nov 2009, KOSAKI Motohiro wrote:

> > I agree in principle with removing non-VM users of PF_MEMALLOC, but I 
> > think it should be left to the individual subsystem maintainers to apply 
> > or ack since the allocations may depend on the __GFP_NORETRY | ~__GFP_WAIT 
> > behavior of PF_MEMALLOC.  This could be potentially dangerous for a 
> > PF_MEMALLOC user if allocations made by the kthread, for example, should 
> > never retry for orders smaller than PAGE_ALLOC_COSTLY_ORDER or block on 
> > direct reclaim.
> 
> if there is so such reason. we might need to implement another MM trick.
> but keeping this strage usage is not a option. All memory freeing activity
> (e.g. page out, task killing) need some memory. we need to protect its
> emergency memory. otherwise linux reliability decrease dramatically when
> the system face to memory stress.
> 

Right, that's why I agree with trying to remove non-VM use of PF_MEMALLOC, 
but I think this patchset needs to go through the individual subsystem 
maintainers so they can ensure the conversion doesn't cause undesirable 
results if their kthreads' memory allocations depend on the __GFP_NORETRY 
behavior that PF_MEMALLOC ensures.  Otherwise it looks good.
