Return-Path: <linux-kernel-owner+w=401wt.eu-S1757181AbZGCJBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181AbZGCJBW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 05:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757043AbZGCJBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 05:01:07 -0400
Received: from smtp-out.google.com ([216.239.33.17]:40853 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756980AbZGCJBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 05:01:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=BbKPh7N67GlfXck5d33xCZ1CF+IXeT6eQ1+/+CiAYhUGA3xt7q3m6gQt+VA3BfZsR
	ZXrpzlPv/Ml3IiUdT7iCQ==
Date: Fri, 3 Jul 2009 02:01:00 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mitchell Erblich <erblichs@earthlink.net>
cc: linux-kernel@vger.kernel.org
Subject: Re: Re : .... get_page_from_freelist : MInority Suggestion to accept
 GFP_NOFAIL accept during boot
In-Reply-To: <61448F53-1F7A-47EF-AAF3-CB2A46AB8009@earthlink.net>
Message-ID: <alpine.DEB.2.00.0907030155250.13657@chino.kir.corp.google.com>
References: <61448F53-1F7A-47EF-AAF3-CB2A46AB8009@earthlink.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Jul 2009, Mitchell Erblich wrote:

> Group,
> 
> 
> 	If I may suggest a minority opinion about the depreciating of the
> GFP_NOFAIL flag..
> 
> 	I saw no discussion on the acceptance of using this flag during boot
> and shortly
> 	after boot.
> 
> 	Many kernel structures require memory and thus should guarantee memory
> 	before they continue.
> 	
> 	As Linux is moved within embedded environments with smaller amounts of
> 	physical memory, the chance that earlier mem failures becomes higher.
> 
> 	For this logic alone, my minority opinion is to not depreciate the
> GFP_NOFAIL flag.
> 

I'm confused by your request because all allocations with orders under 
PAGE_ALLOC_COSTLY_ORDER are inherently __GFP_NOFAIL and those that are not 
can easily implement the same behavior in the caller:

	struct page *page;
	do {
		page = alloc_pages(...);
	} while (!page);

Hopefully something could be done to ensure the next call to alloc_pages() 
would be more likely to succeed, but __GFP_NOFAIL doesn't provide that 
anyway.
