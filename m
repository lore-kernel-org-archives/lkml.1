Return-Path: <linux-kernel-owner+w=401wt.eu-S1757591AbZCDSHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591AbZCDSHc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 13:07:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbZCDSHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 13:07:24 -0500
Received: from smtp-out.google.com ([216.239.33.17]:13063 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbZCDSHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 13:07:23 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=og2ZhDppqobSPJSe8hKcTjsD0VDSH/4I4OMXH8pAJc4lZ/Uo7u2c5REf2sOfP+V2g
	sqHJf+3X06wwNSJ/vg0ug==
Date: Wed, 4 Mar 2009 10:06:49 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux-foundation.org>
cc: Paul Menage <menage@google.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] slub: enforce cpuset restrictions for cpu slabs
In-Reply-To: <alpine.DEB.1.10.0903041011520.3850@qirst.com>
Message-ID: <alpine.DEB.2.00.0903040959530.17033@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0903022009490.17284@chino.kir.corp.google.com>  <alpine.DEB.2.00.0903022011430.17284@chino.kir.corp.google.com>  <alpine.DEB.1.10.0903031136380.26454@qirst.com>  <alpine.DEB.2.00.0903030900580.6643@chino.kir.corp.google.com> 
 <alpine.DEB.1.10.0903031345150.9466@qirst.com>  <alpine.DEB.2.00.0903031057110.15900@chino.kir.corp.google.com>  <alpine.DEB.1.10.0903031509380.25612@qirst.com>  <alpine.DEB.2.00.0903031330090.23523@chino.kir.corp.google.com> 
 <6599ad830903031355y3e12dec6n4b7b675d354f8e72@mail.gmail.com>  <alpine.DEB.2.00.0903031401260.29042@chino.kir.corp.google.com> <6599ad830903031653t231eb921md60a1aa21effa87b@mail.gmail.com> <alpine.DEB.2.00.0903031713200.4767@chino.kir.corp.google.com>
 <alpine.DEB.1.10.0903041011520.3850@qirst.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Mar 2009, Christoph Lameter wrote:

> That would make the per object memory policies in SLUB configurable? If
> you can do that without regression and its clean then it would be
> acceptable.
> 

Yes, if `slab_hardwall' is enabled for a cpuset it will attempt to replace 
the cpu slab with a partial slab on an allowed node.

> Again if you want per object memory policies in SLUB then it needs to be
> added consistently. You would also f.e. have to check for an MPOL_BIND
> condition where you check for cpuset nodes and make sure that __slab_alloc
> goes round robin on MPOL_INTERLEAVE etc etc. You end up with a similar
> nightmare implementation of that stuff as in SLAB.

I agree that we should avoid adding mempolicy support, especially 
MPOL_INTERLEAVE at the object level since that would totally avoid the 
fastpath for any task using it.
