Return-Path: <linux-kernel-owner+w=401wt.eu-S1759747AbYE3F2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759747AbYE3F2P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 01:28:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753933AbYE3F17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 01:27:59 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42252 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753271AbYE3F16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 01:27:58 -0400
Date: Thu, 29 May 2008 22:27:53 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>
Subject: Re: [patch 00/41] cpu alloc / cpu ops v3: Optimize per cpu access
In-Reply-To: <20080529222143.5d7aa1e5.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0805292224540.12329@schroedinger.engr.sgi.com>
References: <20080530035620.587204923@sgi.com> <20080529215827.b659d032.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0805292159360.12107@schroedinger.engr.sgi.com>
 <20080529222143.5d7aa1e5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008, Andrew Morton wrote:

> > The per cpu memory use by subsystems is typically quite small. We already 
> > have an 8k limitation for percpu space for modules. And that does not seem 
> > to be a problem.
> 
> eh?  That's DEFINE_PERCPU memory, not alloc_pecpu() memory?

No. The module subsystem has its own alloc_percpu subsystem that the 
cpu_alloc replaces.

> > We could do that yes.
> 
> Phew.

But its going to be even more complicated and I have a hard time managing 
the complexity here. Could someone take pieces off my hand?

> > But then per cpu data is not frequently allocated and freed.
> 
> I think it is, in the TCP case.  And that's the only one I looked at.

Which tcp case?

> Plus who knows what lies ahead of us?

Well invariably we will end up with cpu area defragmentation.... Sigh.

> I don't think there is presently any upper limit on alloc_percpu()?  It
> uses kmalloc() and kmalloc_node()?
> 
> Even if there is some limit, is it an unfixable one?

No there is no limit. It just wastes lots of space (pointer arrays, 
alignment etc) that we could use to configure sufficiently large per cpu 
areas.

