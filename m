Return-Path: <linux-kernel-owner+w=401wt.eu-S1757395AbZJ1FYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395AbZJ1FYo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 01:24:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757355AbZJ1FYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 01:24:43 -0400
Received: from smtp-out.google.com ([216.239.45.13]:38343 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757297AbZJ1FYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 01:24:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=uyVgMm+N0y+Pcb92hhyQthZmoXIC+EkxHrncOD+Jaa7r/XlZWGSI2ZhilZP8o4cek
	KLV111Hj+Bn9PyB8RF7Tg==
Date: Tue, 27 Oct 2009 22:24:39 -0700 (PDT)
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
Subject: Re: [patch v2] x86: reduce srat verbosity in the kernel log
In-Reply-To: <20091028051925.GL7744@basil.fritz.box>
Message-ID: <alpine.DEB.2.00.0910272220560.9448@chino.kir.corp.google.com>
References: <20091023233750.702443000@alcatraz.americas.sgi.com> <87pr8ay6tc.fsf@basil.nowhere.org> <4AE710C9.2070307@sgi.com> <alpine.DEB.2.00.0910271158490.24696@chino.kir.corp.google.com> <4AE75162.7080903@sgi.com> <alpine.DEB.2.00.0910271323410.32543@chino.kir.corp.google.com>
 <20091028033219.GE7744@basil.fritz.box> <alpine.DEB.2.00.0910272041360.8988@chino.kir.corp.google.com> <20091028041159.GI7744@basil.fritz.box> <alpine.DEB.2.00.0910272129250.17260@chino.kir.corp.google.com> <20091028051925.GL7744@basil.fritz.box>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Oct 2009, Andi Kleen wrote:

> > +		/*
> > +		 * If the bitmap cannot be listed in a buffer of length
> > +		 * APICID_LIST_LEN, then it is suffixed with "...".
> > +		 */
> > +		len = bitmap_scnlistprintf(apicid_list, APICID_LIST_LEN,
> > +					   apicid_map, MAX_LOCAL_APIC);
> > +		pr_info("SRAT: PXM %u -> APIC {%s%s} -> Node %u\n",
> > +			i, apicid_list,
> > +			(len == APICID_LIST_LEN - 1) ? "..." : "",
> 
> Is the - 1 really correct? If scnlistprintf follows snprintf semantics then it would not
> be and my understanding is it is supposed to.
> 

It is, bitmap_scnlistprintf() returns the number of characters printed to 
the buffer minus the trailing '\0', which is different from snprintf().  
APICID_LIST_LEN-1 then identifies when the buffer was max'd out.  It still 
adds a trailing "..." if the list is exactly 128 characters long, but this 
isn't addressed to avoid added complexity.
