Return-Path: <linux-kernel-owner+w=401wt.eu-S1754484AbZKLU5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbZKLU5F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 15:57:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754433AbZKLU5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 15:57:00 -0500
Received: from smtp-out.google.com ([216.239.45.13]:55623 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361AbZKLU46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 15:56:58 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=wZqZmNSUddMIlBbc8x8rPlI1GTfJ1MJDlyqulK3whlwuvM2zKONDuveDyTfQST1cW
	DzaT3jJ2spgtACCvuATWg==
Date: Thu, 12 Nov 2009 12:56:55 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@elte.hu>
cc: Mike Travis <travis@sgi.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, Yinghai Lu <yinghai@kernel.org>,
       Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: [patch v2] x86: reduce srat verbosity in the kernel log
In-Reply-To: <20091110213312.GE23196@elte.hu>
Message-ID: <alpine.DEB.2.00.0911121250140.9544@chino.kir.corp.google.com>
References: <87pr8ay6tc.fsf@basil.nowhere.org> <4AE710C9.2070307@sgi.com> <alpine.DEB.2.00.0910271158490.24696@chino.kir.corp.google.com> <4AE75162.7080903@sgi.com> <alpine.DEB.2.00.0910271323410.32543@chino.kir.corp.google.com> <20091028033219.GE7744@basil.fritz.box>
 <alpine.DEB.2.00.0910272041360.8988@chino.kir.corp.google.com> <20091028041159.GI7744@basil.fritz.box> <alpine.DEB.2.00.0910272129250.17260@chino.kir.corp.google.com> <alpine.DEB.2.00.0911101307440.28728@chino.kir.corp.google.com>
 <20091110213312.GE23196@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Nov 2009, Ingo Molnar wrote:

> I'm waiting for Mike to test them (and other patches) and send a new 
> series out with bits to pick up.
> 

Mike posted his series today without including my patch, so I've replied 
to it.

> But i really dont like such type of buffering - in the past they tended 
> to be problematic.

I'm not sure that I'd call it buffering when iterating through all apic 
id's and setting appropriate bits in a bitmap when they map to a node id.  
It's apparently not been problematic either on my machines, Mike's 
machines, or his merge with ACPI 4.0 code.  I think the code is pretty 
straight forward.

> Why print this info at all in the default bootup?  
> It's not needed on a correctly functioning system.
> 

We have no other export of the apic id to to node mappings in the kernel.  
We already show each pxm's address range, each node's address range, and 
the pxm to node map.  The only other way to map apic ids to nodes is by 
looking for the lines "CPU 0/0 -> Node 0," which I believe are being 
removed.
