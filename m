Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933886Ab0BEVkg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 16:40:36 -0500
Received: from smtp-out.google.com ([216.239.44.51]:7045 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933878Ab0BEVke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 16:40:34 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=Nx30PMbfbK5L3QY5j0mImMCZlK6WUdE0OW89ow2vtr92gHvuYX60ON1q/6lXHFvOS
	WcHJSs2hlHmV7Pf+eUn3A==
Date: Fri, 5 Feb 2010 13:40:21 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/7] Export unusable free space index via
 /proc/pagetypeinfo
In-Reply-To: <20100205102349.GB20412@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.1002051336360.12934@chino.kir.corp.google.com>
References: <1262795169-9095-1-git-send-email-mel@csn.ul.ie> <1262795169-9095-3-git-send-email-mel@csn.ul.ie> <alpine.DEB.2.00.1001281411290.30252@chino.kir.corp.google.com> <20100205102349.GB20412@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Feb 2010, Mel Gorman wrote:

> > > +	/*
> > > +	 * Index should be a value between 0 and 1. Return a value to 3
> > > +	 * decimal places.
> > > +	 *
> > > +	 * 0 => no fragmentation
> > > +	 * 1 => high fragmentation
> > > +	 */
> > > +	return ((info->free_pages - (info->free_blocks_suitable << order)) * 1000) / info->free_pages;
> > > +
> > 
> > This value is only for userspace consumption via /proc/pagetypeinfo, so 
> > I'm wondering why it needs to be exported as an index.  Other than a loss 
> > of precision, wouldn't this be easier to understand (especially when 
> > coupled with the free page counts already exported) if it were multipled 
> > by 100 rather than 1000 and shown as a percent of _usable_ free memory at 
> > each order? 
> 
> I find it easier to understand either way, but that's hardly a surprise.
> The 1000 is because of the loss of precision. I can make it a 100 but I
> don't think it makes much of a difference.
> 

This suggestion was coupled with the subsequent note that there is no 
documentation of what "unusuable free space index" is, except by the 
implementation itself.  Since the value isn't used by the kernel,  I think 
exporting the value as a percent would be easier understood by the user 
without looking up the semantics.  I don't have strong feelings either 
way, however.
