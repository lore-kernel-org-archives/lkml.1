Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbYJ3IiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbYJ3IiS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 04:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752460AbYJ3IiB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 04:38:01 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58507 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbYJ3IiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 04:38:00 -0400
Subject: Re: [patch 1/7] cpusets: add dirty map to struct address_space
From: Peter Zijlstra <peterz@infradead.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Paul Menage <menage@google.com>,
       Derek Fults <dfults@sgi.com>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.0810281722290.23743@chino.kir.corp.google.com>
References: <alpine.DEB.1.10.0810280259500.15270@chino.kir.corp.google.com>
	 <1225215459.15763.33.camel@lappy.programming.kicks-ass.net>
	 <alpine.DEB.1.10.0810281337530.6470@chino.kir.corp.google.com>
	 <alpine.DEB.1.10.0810281722290.23743@chino.kir.corp.google.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 30 Oct 2008 09:38:17 +0100
Message-Id: <1225355897.7803.1.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-28 at 18:13 -0700, David Rientjes wrote:
> On Tue, 28 Oct 2008, David Rientjes wrote:
> 
> > Yeah, if we don't serialize with tree_lock then we'll need to protect the 
> > attachment of mapping->dirty_nodes with a new spinlock in struct 
> > address_space (and only for configs where MAX_NUMNODES > BITS_PER_LONG). 
> > That locking overhead is negligible when mapping->dirty_nodes is non-NULL 
> > since there's no requirement to protect the setting of the node in the 
> > nodemask.
> > 
> > Are your concurrent pagecache patches in the latest mmotm?  If so, I can 
> > rebase this entire patchset off that.
> 
> We're still taking mapping->tree_lock in both __set_page_dirty() and 
> __set_page_dirty_nobuffers() in today's mmotm.
> 
> When tree_lock is removed with your patchset, we can add a spinlock to 
> protect mapping->dirty_nodes when MAX_NUMNODES > BITS_PER_LONG.
> 
> Would you like to fold this patch into your series (which assumes we're 
> not taking mapping->tree_lock in either of the two callers above)?

Thanks!, I was working on cleaning up the patches to submit again
soonish. 


