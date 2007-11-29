Return-Path: <linux-kernel-owner+w=401wt.eu-S934165AbXK2U0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934165AbXK2U0B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 15:26:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934001AbXK2UZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 15:25:38 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39123 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933993AbXK2UZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 15:25:36 -0500
Date: Thu, 29 Nov 2007 12:23:59 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
cc: "H. Peter Anvin" <hpa@zytor.com>, Chuck Ebbert <cebbert@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy@goop.org>, zach@vmware.com
Subject: Re: [PATCH x86/mm 6/6] x86-64 ia32 ptrace get/putreg32 current
 task
In-Reply-To: <200711292111.26661.ak@suse.de>
Message-ID: <alpine.LFD.0.9999.0711291219230.8458@woody.linux-foundation.org>
References: <20071129003849.428E026F8E7@magilla.localdomain> <20071129192721.GP24223@one.firstfloor.org> <alpine.LFD.0.9999.0711291139290.8458@woody.linux-foundation.org> <200711292111.26661.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 29 Nov 2007, Andi Kleen wrote:
> 
> How would you catch (common) the case of them having different bases in the 
> GDT TLS entries? At some point the selector has to be reloaded, otherwise 
> it won't be picked up by the CPU.

You're right. I somehow thought we were using the LDT for TLS entries, 
which I guess we did back before kernel support, but yeah, we're using 
per-CPU GDT entries, and would need to check that those match too.

So yeah, the only safe ones are the ones we don't ever change, and that is 
basically just the kernel entries (that users cannot load anyway).

So scratch that. You're right - the NUL selector is the only special one 
for the context switcher. 

		Linus
