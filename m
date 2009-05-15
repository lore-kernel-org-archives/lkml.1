Return-Path: <linux-kernel-owner+w=401wt.eu-S1756219AbZEOThw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219AbZEOThw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 15:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbZEOThn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 15:37:43 -0400
Received: from smtp-out.google.com ([216.239.33.17]:39948 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258AbZEOThm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 15:37:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=U5We+ikzSz++Rv2zPabF8xC85dw/S5T90SUngBCA0TQmTL+hxakzL7R4W01mCKDPa
	wKZqL3WQ3d1g/b/wkmnDQ==
Date: Fri, 15 May 2009 12:37:03 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: Christoph Lameter <cl@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, San Mehat <san@android.com>,
       Arve Hj?nnev?g <arve@android.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: Misleading OOM messages
In-Reply-To: <1242411807.28257.44.camel@nimitz>
Message-ID: <alpine.DEB.2.00.0905151235220.925@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0905101458430.18804@chino.kir.corp.google.com> <alpine.DEB.2.00.0905101503070.18804@chino.kir.corp.google.com> <alpine.DEB.1.10.0905121708470.14226@qirst.com> <20090514092909.GG1365@ucw.cz> <alpine.DEB.1.10.0905141546040.1381@qirst.com>
 <1242333519.15391.210.camel@nimitz> <alpine.DEB.2.00.0905141346030.28074@chino.kir.corp.google.com> <1242335120.15391.242.camel@nimitz> <alpine.DEB.1.10.0905141729180.30187@qirst.com> <1242337042.28440.34.camel@nimitz> <alpine.DEB.2.00.0905141459370.624@chino.kir.corp.google.com>
 <alpine.DEB.1.10.0905151358070.26559@qirst.com> <1242411807.28257.44.camel@nimitz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 May 2009, Dave Hansen wrote:

> We get a wee bit of info out for the cgroups case at least:
> 
> void mem_cgroup_out_of_memory(struct mem_cgroup *mem, gfp_t gfp_mask)
> {
> ...
>         if (oom_kill_process(p, gfp_mask, 0, points, mem,
>                                 "Memory cgroup out of memory"))
>                 goto retry;
> 
> That can surely be improved, but it's a decent start.
> 

Cpusets are also cgroups and have their own oom handling logic 
(CONSTRAINT_CPUSET and the penalization of the badness score for not 
sharing memory with current's set of allowed nodes).  In this case, we're 
interested in only the nodes set in cpuset_current_mems_allowed, for 
instance, and not the entire state of the machine for exclusive cpusets.
