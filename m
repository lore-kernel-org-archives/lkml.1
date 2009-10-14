Return-Path: <linux-kernel-owner+w=401wt.eu-S1751395AbZJNE3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395AbZJNE3t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 00:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750998AbZJNE3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 00:29:48 -0400
Received: from smtp-out.google.com ([216.239.33.17]:58947 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbZJNE3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 00:29:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=n4akyP3SQV0qfRLLCFM9YC+1kMqBC2rYP6gfRioFbR+6m1NVIChEQu0M9iV3TA+ES
	RNb8b6TXAI1oRK07xUCdw==
Date: Tue, 13 Oct 2009 21:28:31 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Joe Perches <joe@perches.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel.h: Add a never optimized away pr_dbg for
 printk(KERN_DEBUG pr_fmt(fmt)...)
In-Reply-To: <1255494109.1851.7.camel@Joe-Laptop.home>
Message-ID: <alpine.DEB.1.00.0910132124120.2044@chino.kir.corp.google.com>
References: <1255488982.1909.26.camel@Joe-Laptop.home> <alpine.DEB.1.00.0910132031040.1244@chino.kir.corp.google.com> <1255494109.1851.7.camel@Joe-Laptop.home>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Oct 2009, Joe Perches wrote:

> > pr_dbg() is horribly misnamed, it doesn't indicate why it exists vs. 
> > pr_debug() at all.
> 
> Partially true, it's reasonably named because it's very short.
> 

It doesn't really matter how long it is if it doesn't accurately describe 
what it does.

> > I'd suggest pr_debug_force(), even though it's much longer (although still 
> > shorter than printk(KERN_DEBUG)).
> 
> pr_dbg allows longer format strings without exceeding 80 chars.
> 
> printk(KERN_DEBUG
> pr_debug_force
> pr_dbg_always
> pr_dbg_noopt
> 
> Other suggestions?
> 

The pr_dbg_* variations seem reasonable if the current pr_debug() were 
changed to pr_dbg().

I suggest converting some mainline code to use whatever you end up calling 
the !DEBUG variant, though, because this discussion is irrelevant if there 
are no current use cases (in which case the patch is pointless).
