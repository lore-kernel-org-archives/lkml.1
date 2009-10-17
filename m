Return-Path: <linux-kernel-owner+w=401wt.eu-S1752522AbZJQIyl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbZJQIyl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 04:54:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbZJQIyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 04:54:40 -0400
Received: from smtp-out.google.com ([216.239.33.17]:42648 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbZJQIyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 04:54:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=WdPLMEyzSDB+3Ml6b/jziuvYuIDZJRPsi5DbeMhRKDrvvoXExBctzEb3OqtkSX5jI
	LkM2jWjf+llpBddCcKg6A==
Date: Sat, 17 Oct 2009 01:54:35 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] slub: allow stats to be cleared
In-Reply-To: <4AD97107.6040001@cs.helsinki.fi>
Message-ID: <alpine.DEB.1.00.0910170151570.31277@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0910150215320.1551@chino.kir.corp.google.com> <alpine.DEB.1.10.0910161249100.6120@gentwo.org> <alpine.DEB.1.00.0910161129320.21328@chino.kir.corp.google.com> <4AD97107.6040001@cs.helsinki.fi>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Oct 2009, Pekka Enberg wrote:

> > On a semi-related topic, it would have been nice to isolate all statistic
> > files to its own directory: /sys/kernel/slab/kmalloc-256/stats/..., for
> > example.  It would have made collecting (and now clearing) all statistics
> > much easier since userspace wouldn't need a predefined list of stat file
> > names to scan.  I wonder if Pekka would allow them to be moved...
> 
> It's a non-production configuration option and the only known user of the ABI
> is in slabinfo.c so maybe we can just go ahead and do that. Alternatively, I
> think we can preserve the current ABI with symbolic links in sysfs?
> 

I think it would be best to just move them to 
/sys/kernel/slab/cache/stats.  I'll propose a patch and we can see how it 
looks.

I remember trying to change `cpuslab_flush' to `cpu_slab_flush' before and 
you nack'd it, so I wasn't sure you'd accept this ABI change :)
