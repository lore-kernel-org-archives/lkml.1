Return-Path: <linux-kernel-owner+w=401wt.eu-S1760312AbZDWWwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760312AbZDWWwy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 18:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753581AbZDWWwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 18:52:45 -0400
Received: from smtp-out.google.com ([216.239.45.13]:44715 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484AbZDWWwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 18:52:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=SmAzL+58Lyo0zi7abL6JGdpFIkfWH+Yy7+W/YE8gIJ95oeKQ6cHis+dWosJ4npzUP
	6wtfE/2NGGigCypw7Q7Cg==
Date: Thu, 23 Apr 2009 15:52:36 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Randy Dunlap <randy.dunlap@oracle.com>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] slub: add
 Documentation/ABI/testing/sysfs-kernel-slab
In-Reply-To: <alpine.DEB.1.10.0904231829550.26300@qirst.com>
Message-ID: <alpine.DEB.2.00.0904231549130.32736@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0904231136390.20852@chino.kir.corp.google.com> <alpine.DEB.2.00.0904231137440.20852@chino.kir.corp.google.com> <alpine.DEB.2.00.0904231510020.30545@chino.kir.corp.google.com> <alpine.DEB.1.10.0904231829550.26300@qirst.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Apr 2009, Christoph Lameter wrote:

> >  - slqb uses /sys/kernel/slab as well and we simply add its files in
> >    sysfs-kernel-slab and leave it to userspace to test for which allocator
> >    is actually being used.  Both allocators share many of the same
> >    fundamental attributes but some are only applicable to one,
> >
> >  - slqb moves to /sys/kernel/slqb since slub is already resident in
> >    /sys/kernel/slab and the mm/slab.c allocator actually has no sysfs
> >    interface, or
> 
> slqb cannot be concurrently used with slub. So slqb can use
> /sys/kernel/slab as well. So could the original slab allocator.
> Dont change this.
> 

I'm more concerned with the userspace API.  You're comfortable with 
letting userspace determine what allocator the kernel is using either by 
testing for the presence of certain slub or slqb-specific files or 
checking the config?

That should be fine since there's parity among the files that both 
allocators share, but seems fragile if an allocator adds a file that was 
previously only applicable to the other or the API happens to change.

My thinking was that /sys/kernel/slqb would be a permanent reference point 
that userspace could easily test to determine what API is available.
