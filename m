Return-Path: <linux-kernel-owner+w=401wt.eu-S1760044AbZEKVpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760044AbZEKVpm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 17:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759582AbZEKVpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 17:45:25 -0400
Received: from smtp-out.google.com ([216.239.45.13]:43218 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759821AbZEKVpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 17:45:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=HG1eSyan7UxuRTgatQZl5k8cDg7yFe6HIVmps+eDmVDizGaUe/5zgtMH45Vk6C13S
	0cDdGAiaX5wCB7H+n/T1g==
Date: Mon, 11 May 2009 14:45:18 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Greg Kroah-Hartman <gregkh@suse.de>, npiggin@suse.de, mel@csn.ul.ie,
       a.p.zijlstra@chello.nl, Christoph Lameter <cl@linux-foundation.org>,
       dave@linux.vnet.ibm.com, san@android.com, arve@android.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 08/11 -mmotm] oom: invoke oom killer for __GFP_NOFAIL
In-Reply-To: <20090511142936.dd68005b.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.0905111444070.466@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0905101458430.18804@chino.kir.corp.google.com> <alpine.DEB.2.00.0905101502050.18804@chino.kir.corp.google.com> <20090511142936.dd68005b.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009, Andrew Morton wrote:

> > The oom killer must be invoked regardless of the order if the allocation
> > is __GFP_NOFAIL, otherwise it will loop forever when reclaim fails to
> > free some memory.
> 
> We should discourage callers from using __GFP_NOFAIL at all.  We should
> electrocute callers for using __GFP_NOFAIL on large allocations.  How's about
> 
> 	WARN_ON_ONCE(order > PAGE_ALLOC_COSTLY_ORDER &&	
> 			(gfp_mask & __GFP_NOFAIL));
> or, preferably:
> 
> 	WARN_ON_ONCE(order > 0 && (gfp_mask & __GFP_NOFAIL));
> 

Not sure it would help since the oom killer will be now be called for such 
an allocation and that dumps the stack (and will actually show the order 
and gfp flags as well).
