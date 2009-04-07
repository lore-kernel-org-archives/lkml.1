Return-Path: <linux-kernel-owner+w=401wt.eu-S1761975AbZDGWEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761975AbZDGWEl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 18:04:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbZDGWEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 18:04:32 -0400
Received: from smtp-out.google.com ([216.239.33.17]:16479 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758098AbZDGWEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 18:04:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=PFsgizLreMpLXgr3i75zdJEplIy4OO89pIe44UYfTYQywaGAAJfITD0ZvcIRrZheL
	8ax99xBXh8/xZDd+fB6WQ==
Date: Tue, 7 Apr 2009 15:03:48 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [patch] slub: default min_partial to at least highest cpus per
  node
In-Reply-To: <alpine.DEB.1.10.0904071747400.12192@qirst.com>
Message-ID: <alpine.DEB.2.00.0904071501570.32000@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0904051653420.25339@chino.kir.corp.google.com>  <49DBA23A.3000106@cs.helsinki.fi> <84144f020904071209j638aae9bv406661ec401af7af@mail.gmail.com> <alpine.DEB.2.00.0904071231500.21113@chino.kir.corp.google.com> <49DBAF7E.30704@cs.helsinki.fi>
 <alpine.DEB.2.00.0904071302430.32321@chino.kir.corp.google.com> <49DBB373.5050800@cs.helsinki.fi> <alpine.DEB.2.00.0904071316460.21748@chino.kir.corp.google.com> <49DBB929.4080205@cs.helsinki.fi> <alpine.DEB.1.10.0904071641390.12192@qirst.com>
 <49DBBC1F.6000407@cs.helsinki.fi> <alpine.DEB.1.10.0904071728240.12192@qirst.com> <alpine.DEB.2.00.0904071445200.27115@chino.kir.corp.google.com> <alpine.DEB.1.10.0904071747400.12192@qirst.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Apr 2009, Christoph Lameter wrote:

> > Right, but right now allocating new slabs is extremely slow compared to
> > using a partial slab.
> 
> Work on the page allocator is in progress. So this is band aid until the
> work on the page allocator is complete. Maybe better focus on helping Mel?
> 

The page allocator may be getting significantly faster, but that is _not_ 
the only reason why we use partial slabs.  Higher order slabs, such as the 
default for kmalloc-2048, kmalloc-4096, etc., increase the liklihood of 
having cpu slabs at that order as opposed to order fallback with a 
sufficiently long uptime.
