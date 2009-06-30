Return-Path: <linux-kernel-owner+w=401wt.eu-S1756122AbZF3FrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbZF3FrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 01:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbZF3FrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 01:47:12 -0400
Received: from smtp-out.google.com ([216.239.45.13]:49150 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbZF3FrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 01:47:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=bHjovFeYttKf3FCSizfmW+GzRy9+s4lMobbMPBxnxx6LEqppuP5Z0REDNV6N2+1Za
	jkConmdUJm9LuKYA6PbWQ==
Date: Mon, 29 Jun 2009 22:47:03 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Larry Finger <Larry.Finger@lwfinger.net>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
In-Reply-To: <4A49733D.9030602@lwfinger.net>
Message-ID: <alpine.DEB.2.00.0906292238560.7434@chino.kir.corp.google.com>
References: <etTXaRqGgAC.A.SaE.6iASKB@chimera> <5Hhc7UkUKEO.A.fNH.4kASKB@chimera> <4A48F114.1010702@lwfinger.net> <alpine.DEB.2.00.0906291642520.17663@chino.kir.corp.google.com> <4A49733D.9030602@lwfinger.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jun 2009, Larry Finger wrote:

> > I'd disagree with disabling slub debugging by default for caches where 
> > oo_order(s->min) increases as the result of using it.  This particular 
> > page allocation failure is happening for, presumably, kmalloc-4096, and 
> > the system has 4K pages.  Disabling debugging for that cache (and any of 
> > its aliases) implicitly will lead to errors going undiagnosed as a result.
> 
> If the current behavior is not changed, I will be forced to disable
> SLUB debugging, which will explicitly lead to errors that are
> undiagnosed.

You're buying debugging support at the cost of increased memory 
consumption when you enable CONFIG_SLUB_DEBUG_ON and that's causing the 
page allocation failures because of fragmentation.  To reduce the minimum 
order required for caches such as kmalloc-4096, you'd have to disable 
debugging for that particular cache.  It's my opinion that such a 
configuration should not be the default, however.

You could argue adding `slub_debug=-,kmalloc-4096' support from the 
command line, but CONFIG_SLUB_DEBUG_ON should not change its well-defined 
purpose of enabling debugging on all slab caches.  Otherwise the rest of 
us would be forced to add `slub_debug=,kmalloc-4096' for consistent 
behavior with older kernels.
