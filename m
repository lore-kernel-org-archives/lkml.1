Return-Path: <linux-kernel-owner+w=401wt.eu-S1755672AbZCDBOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672AbZCDBOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 20:14:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752071AbZCDBOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 20:14:23 -0500
Received: from smtp-out.google.com ([216.239.45.13]:29674 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbZCDBOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 20:14:22 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=x7gQ5qSRIGKUhTyvOk2t7A/eCZ/zSnWJirIecJtwl8xU4xqpea2Jak23B0fxkK5sp
	d0Mw/83LassnkQhLTJOZw==
Date: Tue, 3 Mar 2009 17:14:06 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Menage <menage@google.com>
cc: Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] slub: enforce cpuset restrictions for cpu slabs
In-Reply-To: <6599ad830903031653t231eb921md60a1aa21effa87b@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0903031713200.4767@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0903022009490.17284@chino.kir.corp.google.com>  <alpine.DEB.2.00.0903022011430.17284@chino.kir.corp.google.com>  <alpine.DEB.1.10.0903031136380.26454@qirst.com>  <alpine.DEB.2.00.0903030900580.6643@chino.kir.corp.google.com> 
 <alpine.DEB.1.10.0903031345150.9466@qirst.com>  <alpine.DEB.2.00.0903031057110.15900@chino.kir.corp.google.com>  <alpine.DEB.1.10.0903031509380.25612@qirst.com>  <alpine.DEB.2.00.0903031330090.23523@chino.kir.corp.google.com> 
 <6599ad830903031355y3e12dec6n4b7b675d354f8e72@mail.gmail.com>  <alpine.DEB.2.00.0903031401260.29042@chino.kir.corp.google.com> <6599ad830903031653t231eb921md60a1aa21effa87b@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Mar 2009, Paul Menage wrote:

> > That would help for cpusets that are looking for NUMA optimizations (i.e.
> > probably long-lived objects with local affinity) but would not ensure
> > memory isolation from tasks in other exclusive cpusets from allocating on
> > my slab.
> 
> That would be the sysadmin's choice, if they set these other cpusets
> with slab_hardwall=false.
> 
> Presumably in most cases all cpusets would have slab_hardwall set to
> the same value.
> 

True, and this would have to be clearly documented in 
Documentation/cgroups/cpusets.txt.

Christoph, would a `slab_hardwall' cpuset setting address your concerns?
