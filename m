Return-Path: <linux-kernel-owner+w=401wt.eu-S1760200AbZEKWbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760200AbZEKWbU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 18:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757364AbZEKWbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 18:31:10 -0400
Received: from smtp-out.google.com ([216.239.33.17]:9920 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757208AbZEKWbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 18:31:09 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=clurTXfQzGrhOrx28z1ZY612uQvSKICDVAXFR0gNDF6XDzsAj+dK12OUcLJNqSf7X
	QjV93+/XQWrN19BUrKmhQ==
Date: Mon, 11 May 2009 15:31:04 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: gregkh@suse.de, npiggin@suse.de, mel@csn.ul.ie, a.p.zijlstra@chello.nl,
       cl@linux-foundation.org, dave@linux.vnet.ibm.com, san@android.com,
       arve@android.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 08/11 -mmotm] oom: invoke oom killer for __GFP_NOFAIL
In-Reply-To: <20090511151130.9a949cb7.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.0905111529090.2234@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0905101458430.18804@chino.kir.corp.google.com> <alpine.DEB.2.00.0905101502050.18804@chino.kir.corp.google.com> <20090511142936.dd68005b.akpm@linux-foundation.org> <alpine.DEB.2.00.0905111444070.466@chino.kir.corp.google.com>
 <20090511151130.9a949cb7.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009, Andrew Morton wrote:

> __GFP_NOFAIL is a bad fiction.  Allocations _can_ fail, and callers should
> detect and suitably handle this (and not by lamely moving the infinite
> loop up to the caller level either).
> 
> Attempting to use __GFP_NOFAIL for a higher-order allocation is even
> worse, so add a once-off runtime check for this to slap people around for
> even thinking about trying it.
> 
> Cc: David Rientjes <rientjes@google.com>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

This only emits a warning when you have CONFIG_DEBUG_KERNEL, 
CONFIG_FAULT_INJECTION, and CONFIG_FAIL_PAGE_ALLOC, which is all related 
to fault injection (since we never want to inject a fault into anything 
using __GFP_NOFAIL).  So it may be helpful in tracking down such callers, 
but is unrelated to the config options that enable it and it may not get 
the best coverage.
