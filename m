Return-Path: <linux-kernel-owner+w=401wt.eu-S1756246AbZKKD1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246AbZKKD1q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 22:27:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754058AbZKKD1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 22:27:45 -0500
Received: from smtp-out.google.com ([216.239.45.13]:21826 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036AbZKKD1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 22:27:45 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=ZvF3qZQmhC9+B2uWzKZFfoNO1QhUvcWDOwD9/52Ww9HWersbZJt+UouVEOBIj4/wM
	MUST2CQH1yAP7urfJXfRA==
Date: Tue, 10 Nov 2009 19:27:40 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [BUGFIX][PATCH] oom-kill: fix NUMA consraint check with nodemask
 v3
In-Reply-To: <20091111121958.FD59.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0911101926080.16932@chino.kir.corp.google.com>
References: <20091111115217.FD56.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.0911101908180.14549@chino.kir.corp.google.com> <20091111121958.FD59.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Nov 2009, KOSAKI Motohiro wrote:

> Linux doesn't support 1K nodes. (and only SGI huge machine use 512 nodes)
> 

I know for a fact that it does on x86 if you adjust CONFIG_NODES_SHIFT, 
I've booted kernels all the way back to 2.6.18 with 1K nodes.

> At least, NODEMASK_ALLOC should make more cleaner interface. current one
> and struct nodemask_scratch are pretty ugly.
> 

I agree, I haven't been a fan of nodemask_scratch because I think its use 
case is pretty limited, but I do advocate using NODEMASK_ALLOC() when deep 
in the stack.  We've made sure that most of the mempolicy code does that 
where manipulating nodemasks is common in -mm.
