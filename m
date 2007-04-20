Return-Path: <linux-kernel-owner+w=401wt.eu-S2992669AbXDTMmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992669AbXDTMmK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 08:42:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992690AbXDTMmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 08:42:10 -0400
Received: from kanga.kvack.org ([66.96.29.28]:48175 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992669AbXDTMmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 08:42:10 -0400
Date: Fri, 20 Apr 2007 08:41:57 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Andrew Morton <akpm@osdl.org>, Christoph Lameter <clameter@sgi.com>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>,
       Larry Woodman <lwoodman@redhat.com>
Subject: Re: [PATCH] Make new setting of panic_on_oom
Message-ID: <20070420124157.GA21709@kvack.org>
References: <20070420202752.0E69.Y-GOTO@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070420202752.0E69.Y-GOTO@jp.fujitsu.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2007 at 08:43:56PM +0900, Yasunori Goto wrote:
> 
> The current panic_on_oom may not work if there is a process using 
> cpusets/mempolicy, because other nodes' memory may still free.
> But some people want failover by panic ASAP even if they are used.
> This patch makes new setting for its request.
> 
> This is not tested yet. But it would work.

>  	read_lock(&tasklist_lock);
>  
> +	if (sysctl_panic_on_oom == 2)
> +		panic("out of memory. Compulsory panic_on_oom is selected.\n");
> +

Wouldn't it be safer to put the panic before the read_lock()?

		-ben
-- 
"Time is of no importance, Mr. President, only life is important."
Don't Email: <zyntrop@kvack.org>.
