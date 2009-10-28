Return-Path: <linux-kernel-owner+w=401wt.eu-S1751857AbZJ1Vqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857AbZJ1Vqu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 17:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751329AbZJ1Vqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 17:46:49 -0400
Received: from smtp-out.google.com ([216.239.45.13]:62110 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbZJ1Vqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 17:46:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=RXIce0F2ldynTHpF5IGtg+0oeF2Tkgh/x4aPgh6o+IPvZ54Bt3Uvck5ag7rBaVFkm
	07mpBzOEHieVTTp2sFBag==
Date: Wed, 28 Oct 2009 14:46:44 -0700 (PDT)
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
In-Reply-To: <4AE8B933.5020103@sgi.com>
Message-ID: <alpine.DEB.2.00.0910281440580.32315@chino.kir.corp.google.com>
References: <20091023233743.439628000@alcatraz.americas.sgi.com> <20091023233750.702443000@alcatraz.americas.sgi.com> <87pr8ay6tc.fsf@basil.nowhere.org> <4AE710C9.2070307@sgi.com> <alpine.DEB.2.00.0910271158490.24696@chino.kir.corp.google.com>
 <4AE75162.7080903@sgi.com> <alpine.DEB.2.00.0910271323410.32543@chino.kir.corp.google.com> <20091028033219.GE7744@basil.fritz.box> <alpine.DEB.2.00.0910272041360.8988@chino.kir.corp.google.com> <20091028041159.GI7744@basil.fritz.box> <4AE8792F.8070200@sgi.com>
 <alpine.DEB.2.00.0910281348590.24785@chino.kir.corp.google.com> <4AE8B933.5020103@sgi.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Oct 2009, Mike Travis wrote:

> > Printing a list of apic ids longer than 128 characters would pollute the
> > kernel log and this upper bound will probably never be reached based on the
> > way apic ids are created for physical and logical processors: they are
> > normally reduced to ranges instead of comma seperated entities.
> 
> Ahh, ok, thanks.
> 
> Does that mean this 10,649 character line full of periods is illegal?
> 

I'm not saying it would be illegal, merely that it would be harm 
readability.  Based on how apic id's are formed from processor ids, 
though, I think we're really talking about an upper limit (128) that will 
never be reached.

> [  102.551570] Completing Region/Field/Buffer/Package initialization:
> ............... [long time later] .........
> <4>Clocksource tsc unstable (delta = 4396383657849 ns)
> 
> I'm having trouble finding it.  Does it look familiar to anyone?
> 

It's debugging output from acpi_ns_initialize_objects() and each period is 
from acpi_ns_init_one_device().  You can suppress it by disabing 
CONFIG_ACPI_DEBUG.
