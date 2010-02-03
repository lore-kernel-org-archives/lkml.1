Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab0BCSUj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 13:20:39 -0500
Received: from smtp-out.google.com ([216.239.33.17]:28023 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491Ab0BCSUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 13:20:37 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=mGiSyvKROi7SY1Nl1yA6PcLWGVXWlGdVyG13JVn2s+PzSKQlw240HRGv0jni8xfGC
	kV/TtAVUrKd3LL6lFnXvw==
Date: Wed, 3 Feb 2010 10:20:29 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Minchan Kim <minchan.kim@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       linux-mm <linux-mm@kvack.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][mmotm-2010-02-01-16-25] Fix wrong accouting of anon and
 file
In-Reply-To: <1265210739.1052.36.camel@barrios-desktop>
Message-ID: <alpine.DEB.2.00.1002031007150.14088@chino.kir.corp.google.com>
References: <1265210739.1052.36.camel@barrios-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Feb 2010, Minchan Kim wrote:

> Unfortunately, Kame said he doesn't support this series.
> I am not sure we need this patch or revert patch.
> 

Nobody is currently using it and it adds an overhead just by doing the 
extra branches, so I'd be inclined to drop mm-count-lowmem-rss.patch from 
-mm and then reintroduce it later if something needs it down the line.

> Who need this?
> 
> David. Do you want to remain this patch in mmotm for your OOM patch 
> in future?
> 

We'll need to do something for lowmem ooms so that we aren't needlessly 
killing taks that don't consume it.  At this point, I think it's better to 
just fail GFP_DMA allocations where direct reclaim (and, later, memory 
compaction) has failed unless it is __GFP_NOFAIL, which none of them are.  
So this would be a change to the page allocator to defer the oom killer 
and return NULL on GFP_DMA instead of needlessly killing tasks.

> If anyone doesn't reply my question, Do we have to make revert patch?
> 

We won't need a revert patch, Andrew will be able to simply drop 
mm-count-lowmem-rss.patch from -mm.
