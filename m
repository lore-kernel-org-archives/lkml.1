Return-Path: <linux-kernel-owner+w=401wt.eu-S1756525AbZJ2TG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525AbZJ2TG2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 15:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755804AbZJ2TG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 15:06:27 -0400
Received: from smtp-out.google.com ([216.239.45.13]:40474 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513AbZJ2TG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 15:06:26 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=ljT6J4SOPhdr/VMB1dlfxdGfQ8BnEn0GY5qLyrp18QLgeB46ms8Omfk2NwexcFUGG
	YQTJ7tNJivdxTpMbn6H+w==
Date: Thu, 29 Oct 2009 12:06:21 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mike Travis <travis@sgi.com>
cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, Yinghai Lu <yinghai@kernel.org>,
       Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [patch] x86: reduce srat verbosity in the kernel log
In-Reply-To: <4AE9C3FA.4000305@sgi.com>
Message-ID: <alpine.DEB.2.00.0910291159030.27732@chino.kir.corp.google.com>
References: <20091023233743.439628000@alcatraz.americas.sgi.com> <20091023233750.702443000@alcatraz.americas.sgi.com> <87pr8ay6tc.fsf@basil.nowhere.org> <4AE710C9.2070307@sgi.com> <alpine.DEB.2.00.0910271158490.24696@chino.kir.corp.google.com>
 <4AE75162.7080903@sgi.com> <alpine.DEB.2.00.0910271323410.32543@chino.kir.corp.google.com> <20091028033219.GE7744@basil.fritz.box> <alpine.DEB.2.00.0910272041360.8988@chino.kir.corp.google.com> <20091028041159.GI7744@basil.fritz.box> <4AE8792F.8070200@sgi.com>
 <alpine.DEB.2.00.0910281348590.24785@chino.kir.corp.google.com> <4AE8B933.5020103@sgi.com> <alpine.DEB.2.00.0910281440580.32315@chino.kir.corp.google.com> <4AE8C764.90705@sgi.com> <alpine.DEB.2.00.0910290117020.11476@chino.kir.corp.google.com>
 <4AE9C3FA.4000305@sgi.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Oct 2009, Mike Travis wrote:

> I believe the disjointed ranges came from the hyperthread cpus..?  Which if
> true means there'll probably be as many distinct ranges as there are threads
> per core?
> 

Not necessarily, look at the first few lines of your new output:

	[    0.000000] SRAT: PXM 0 -> APIC {0-7,16-23} -> Node 0
	[    0.000000] SRAT: PXM 1 -> APIC {32-39,48-55} -> Node 1
	[    0.000000] SRAT: PXM 2 -> APIC {64-71,80-87} -> Node 2
	...

If those values are in hex, you have these apic id ranges:

	0x00-0x07, 0x10-0x17
	0x20-0x27, 0x30-0x37
	0x40-0x47, 0x50-0x57
	...

So it's most likely that each of the physical processors has eight logical 
processors (represented by the least significant three bits) and there are 
two physical processors (the more significant four bits) per node.
