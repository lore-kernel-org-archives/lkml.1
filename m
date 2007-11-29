Return-Path: <linux-kernel-owner+w=401wt.eu-S933685AbXK2ULn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933685AbXK2ULn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 15:11:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762379AbXK2ULe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 15:11:34 -0500
Received: from mail.suse.de ([195.135.220.2]:50421 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761832AbXK2ULd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 15:11:33 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH x86/mm 6/6] x86-64 ia32 ptrace get/putreg32 current task
Date: Thu, 29 Nov 2007 21:11:26 +0100
User-Agent: KMail/1.9.6
Cc: "H. Peter Anvin" <hpa@zytor.com>, Chuck Ebbert <cebbert@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy@goop.org>, zach@vmware.com
References: <20071129003849.428E026F8E7@magilla.localdomain> <20071129192721.GP24223@one.firstfloor.org> <alpine.LFD.0.9999.0711291139290.8458@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.9999.0711291139290.8458@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711292111.26661.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> HOWEVER. That is actually not the right (well, "complete") conditional, 
> since it's only one sub-case of the thing that matters. The right 
> conditional is probably
> 
> 	/*
> 	 * Restore %gs if needed (which is common).
> 	 * We can avoid it if they are identical, and
> 	 * point to the GDT.

How would you catch (common) the case of them having different bases in the 
GDT TLS entries? At some point the selector has to be reloaded, otherwise 
it won't be picked up by the CPU.

I think the original condition is correct. You could maybe merge it with the 
TLS entry rewrite and only do it if something changes there. Not
sure it is worth it though.

-Andi
> 	 */
> 	if ((prev->gs ^ next->gs) | (next->gs & 4))
> 		loadsegment(gs, next->gs);
> 
> At that point, we would only have to reload stuff if the user actually 
> uses a local descriptor table entry (which does happen for threaded apps, 
> I guess, but at least we avoid it for all the common traditional UNIX 
> processes).
> 
> 			Linus
> 


