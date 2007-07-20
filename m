Return-Path: <linux-kernel-owner+w=401wt.eu-S932087AbXGTIYH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087AbXGTIYH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 04:24:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755129AbXGTIXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 04:23:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56280 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878AbXGTIXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 04:23:48 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Zachary Amsden <zach@vmware.com>
Subject: Re: new text patching for review
Date: Fri, 20 Jul 2007 10:23:40 +0200
User-Agent: KMail/1.9.6
Cc: mathieu.desnoyers@polymtl.ca, jbeulich@novell.com,
       "S. P. Prasanna" <prasanna@in.ibm.com>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
References: <200707191105.44056.ak@suse.de> <46A003C0.5040909@vmware.com>
In-Reply-To: <46A003C0.5040909@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707201023.40842.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 July 2007 02:37:20 Zachary Amsden wrote:
> Andi Kleen wrote:
> > +	*addr = opcode;
> > +	/* Not strictly needed, but can speed CPU recovery up */
> > +	if (cpu_has_clflush)
> > +		asm("clflush (%0) " :: "r" (addr) : "memory");
> > +	if (addr != oaddr)
> > +		vunmap(addr);
> >   
> 
> clflush should take oaddr.

Thanks

> If you had to remap, note that the processor does not know the linear 
> address you wrote to could be matched by another mapping in icache.  In 
> that case, you'll need a serializing instruction (cpuid) to 
> resynchronize caches.

We already got one in alternative patching, but you're right it's 
safer to do it in text_poke

-Andi
