Return-Path: <linux-kernel-owner+w=401wt.eu-S1753886AbZJ1EIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbZJ1EIx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 00:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbZJ1EIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 00:08:52 -0400
Received: from smtp-out.google.com ([216.239.45.13]:29739 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbZJ1EIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 00:08:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=RupG/xeNMlpl2wBo//wnfWSo+nTNknF5t55BFcdh0cax0kqhDBlLY3+iDtkAQz3CL
	biBjZ2Pf5fyOTJ0awzJXA==
Date: Tue, 27 Oct 2009 21:08:46 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andi Kleen <andi@firstfloor.org>
cc: Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, Yinghai Lu <yinghai@kernel.org>,
       Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [patch] x86: reduce srat verbosity in the kernel log
In-Reply-To: <20091028033219.GE7744@basil.fritz.box>
Message-ID: <alpine.DEB.2.00.0910272041360.8988@chino.kir.corp.google.com>
References: <20091023233743.439628000@alcatraz.americas.sgi.com> <20091023233750.702443000@alcatraz.americas.sgi.com> <87pr8ay6tc.fsf@basil.nowhere.org> <4AE710C9.2070307@sgi.com> <alpine.DEB.2.00.0910271158490.24696@chino.kir.corp.google.com>
 <4AE75162.7080903@sgi.com> <alpine.DEB.2.00.0910271323410.32543@chino.kir.corp.google.com> <20091028033219.GE7744@basil.fritz.box>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Oct 2009, Andi Kleen wrote:

> > +static DECLARE_BITMAP(apicid_map, MAX_LOCAL_APIC) __initdata;
> > +static char apicid_list[MAX_LOCAL_APIC] __initdata;
> 
> Is MAX_LOCAL_APIC really big enough to print them all in ASCII?
> 
> It would be better to not use that large a buffer, but print
> in smaller pieces (I realize this would enlarge your patch,
> but then it would also save a lot of BSS)
> 

MAX_LOCAL_APIC was definitely an arbitrary choice here and has very little 
relevance.  scnlistprintf will protect against overflow, but we still need 
to decide upon a constant that will emit the most information possible 
while not overly polluting the printk and saving on bss, as you mentioned.  
I suspect we could agree on a value as little as 128 and it would work for 
the overwhelming majority (all?) of users.
