Return-Path: <linux-kernel-owner+w=401wt.eu-S1754879AbZCLFw7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879AbZCLFw7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 01:52:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751238AbZCLFwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 01:52:51 -0400
Received: from smtp-out.google.com ([216.239.33.17]:11674 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbZCLFwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 01:52:50 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=xhDVZCXd86LvMpagF/Pv6BIm7tRW9p7MiSIfv7Mii9Ae9bUXiu/RrSQ+g3VAk7Gj+
	rHWNv5pvSOXlFvbuejzew==
Date: Wed, 11 Mar 2009 22:51:12 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Paul Menage <menage@google.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch -mm] cpusets: add memory_slab_hardwall flag
In-Reply-To: <20090312010330.GK7086@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.00.0903112248360.26210@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0903080917460.25207@chino.kir.corp.google.com> <alpine.DEB.1.10.0903091448110.20314@qirst.com> <20090312010330.GK7086@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Mar 2009, Paul E. McKenney wrote:

> Adding synchronize_rcu() into a fast path would certainly be a problem,
> but call_rcu() should be OK.  If the data structure is updated often
> (old elements removed and new elements added), then the cache misses
> from elements that were removed, went cache-cold, and then were added
> again could potentially cause trouble, but read-mostly data structures
> should be OK.
> 
> Or were you worried about some other aspect of RCU overhead?
> 

Thanks for looking at this, Paul.  My latest proposal actually replaces 
the need for the rcu with a per-task flag called PF_SLAB_HARDWALL (see 
http://marc.info/?l=linux-kernel&m=123665181400366).
