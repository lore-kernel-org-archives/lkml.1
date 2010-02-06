Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab0BFJz1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 04:55:27 -0500
Received: from smtp-out.google.com ([216.239.44.51]:22931 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895Ab0BFJzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 04:55:24 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=wzhAFgt5IQtUAzVrXnuc2WAJJ18Ea9rN0V6ts0zMGGz3lJ+C1FZ9UtTu1rqfnonpp
	1ktDjZJKq0MV8fKnCEr+g==
Date: Sat, 6 Feb 2010 01:55:19 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andi Kleen <andi@firstfloor.org>
cc: submit@firstfloor.org, linux-kernel@vger.kernel.org, haicheng.li@intel.com,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org
Subject: Re: [PATCH] [3/4] SLAB: Separate node initialization into separate
 function
In-Reply-To: <20100206072746.GP29555@one.firstfloor.org>
Message-ID: <alpine.DEB.2.00.1002060153250.17897@chino.kir.corp.google.com>
References: <201002031039.710275915@firstfloor.org> <20100203213914.D8654B1620@basil.firstfloor.org> <alpine.DEB.2.00.1002051324370.2376@chino.kir.corp.google.com> <20100206072746.GP29555@one.firstfloor.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Feb 2010, Andi Kleen wrote:

> > in the series; slab_node_prepare() is called in that previous patch by a 
> > memory hotplug callback without holding cache_chain_mutex (it's taken by 
> > the cpu hotplug callback prior to calling cpuup_prepare() currently).  So 
> > slab_node_prepare() should note that we require the mutex and the memory 
> > hotplug callback should take it in the previous patch.
> 
> AFAIK the code is correct. If you feel the need for additional
> documentation feel free to send patches yourself.
> 

Documentation?  You're required to take cache_chain_mutex before calling 
slab_node_prepare() in your memory hotplug notifier, it iterates 
cache_chain.  Please look again.
