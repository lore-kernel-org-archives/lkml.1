Return-Path: <linux-kernel-owner+w=401wt.eu-S1760543AbZJNDfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760543AbZJNDfZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 23:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754841AbZJNDfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 23:35:25 -0400
Received: from smtp-out.google.com ([216.239.33.17]:45696 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636AbZJNDfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 23:35:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=BI8k/722jOaA8HvRPCFjYm8N0XTCcNeduCGi+c7Cl0wjsCgZlgxFNSttAKWFMxjIh
	8b6Tujb7MltjwT7an4mGw==
Date: Tue, 13 Oct 2009 20:34:11 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Joe Perches <joe@perches.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel.h: Add a never optimized away pr_dbg for
 printk(KERN_DEBUG pr_fmt(fmt)...)
In-Reply-To: <1255488982.1909.26.camel@Joe-Laptop.home>
Message-ID: <alpine.DEB.1.00.0910132031040.1244@chino.kir.corp.google.com>
References: <1255488982.1909.26.camel@Joe-Laptop.home>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Oct 2009, Joe Perches wrote:

> Many developers use a logging message that
> is printed at KERN_DEBUG level that is always
> printed regardless of #define DEBUG levels.
> 
> pr_debug can be optimized away to a null statement.
> 
> Add a pr_dbg message that prints at KERN_DEBUG
> level that uses pr_fmt() that can not be optimized
> to nothing.
> 

pr_dbg() is horribly misnamed, it doesn't indicate why it exists vs. 
pr_debug() at all.  Future users will undoubtedly use it by mistake when 
they only really mean for the message to be emitted on DEBUG because 
they've seen it in other places and haven't checked the implementation.

I'd suggest pr_debug_force(), even though it's much longer (although still 
shorter than printk(KERN_DEBUG)).
