Return-Path: <linux-kernel-owner+w=401wt.eu-S1754890AbZCHVxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890AbZCHVxf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 17:53:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754092AbZCHVx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 17:53:26 -0400
Received: from smtp-out.google.com ([216.239.33.17]:3271 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbZCHVxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 17:53:25 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=HeA5oxLuI6l93k81P7Rca3HG0fj6OjC2oxxwNATU0w7DKuWANu3XuZOLl09Qecp9+
	I7P5G9eYZ93U+7j1c6wrg==
Date: Sun, 8 Mar 2009 14:51:58 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Matt Mackall <mpm@selenic.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Paul Menage <menage@google.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch -mm] cpusets: add memory_slab_hardwall flag
In-Reply-To: <1236531664.4192.389.camel@calx>
Message-ID: <alpine.DEB.2.00.0903081438550.30551@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0903080917460.25207@chino.kir.corp.google.com> <1236531664.4192.389.camel@calx>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Mar 2009, Matt Mackall wrote:

> > For slob, if the page from the slob list is not from an allowable node,
> > we continue to scan for an appropriate slab.  If none can be used, a new
> > slab is allocated.
> 
> Looks fine to me, if a little expensive.

Is that your acked-by? :)

It's not expensive for cpusets that do not set memory_slab_hardwall, which 
is disabled by default, other than some cacheline polluting.  If the 
option is set, then the performance penalty is described in the 
documentation and should be assumed by the user.

We currently have a couple different ways to check for a task's cpuset 
options:

 - per-task flags such as PF_SPREAD_PAGE and PF_SPREAD_SLAB used in the
   hotpath, and

 - rcu dereferencing current's cpuset and atomically checking a cpuset
   flag bit.

It would be nice to unify these to free up some task flag bits.

> We'll be needing SLQB support
> though.
> 

Yeah, I'd like to add the necessary slqb support from Pekka's git tree but 
this patch depends on 
cpusets-replace-zone-allowed-functions-with-node-allowed.patch in -mm, so 
we'll need to know the route by which this should be pushed.
