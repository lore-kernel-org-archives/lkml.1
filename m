Return-Path: <linux-kernel-owner+w=401wt.eu-S1030503AbXDTQQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030503AbXDTQQk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 12:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030851AbXDTQQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 12:16:40 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58067 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030503AbXDTQQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 12:16:39 -0400
Date: Fri, 20 Apr 2007 09:16:37 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Benjamin LaHaise <bcrl@kvack.org>
cc: Yasunori Goto <y-goto@jp.fujitsu.com>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>,
       Larry Woodman <lwoodman@redhat.com>
Subject: Re: [PATCH] Make new setting of panic_on_oom
In-Reply-To: <20070420124157.GA21709@kvack.org>
Message-ID: <Pine.LNX.4.64.0704200916250.20232@schroedinger.engr.sgi.com>
References: <20070420202752.0E69.Y-GOTO@jp.fujitsu.com> <20070420124157.GA21709@kvack.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007, Benjamin LaHaise wrote:

> On Fri, Apr 20, 2007 at 08:43:56PM +0900, Yasunori Goto wrote:
> > 
> > The current panic_on_oom may not work if there is a process using 
> > cpusets/mempolicy, because other nodes' memory may still free.
> > But some people want failover by panic ASAP even if they are used.
> > This patch makes new setting for its request.
> > 
> > This is not tested yet. But it would work.
> 
> >  	read_lock(&tasklist_lock);
> >  
> > +	if (sysctl_panic_on_oom == 2)
> > +		panic("out of memory. Compulsory panic_on_oom is selected.\n");
> > +
> 
> Wouldn't it be safer to put the panic before the read_lock()?

I agree. Otherwise the patch seem to be okay.

