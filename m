Return-Path: <linux-kernel-owner+w=401wt.eu-S1758534AbYDMJp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758534AbYDMJp3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 05:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755540AbYDMJpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 05:45:21 -0400
Received: from keg.few.vu.nl ([130.37.24.4]:32769 "EHLO keg.few.vu.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754543AbYDMJpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 05:45:21 -0400
Date: Sun, 13 Apr 2008 11:44:46 +0200 (CEST)
From: Erik Bosman <ejbosman@cs.vu.nl>
X-X-Sender: ebn310@keg.few.vu.nl
To: Andi Kleen <andi@firstfloor.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrea Arcangeli <andrea@cpushare.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Add prctl commands PR_GET_TSC and PR_SET_TSC
In-Reply-To: <87r6daw2ay.fsf@basil.nowhere.org>
Message-ID: <Pine.GSO.4.56.0804131126080.28138@keg.few.vu.nl>
References: <Pine.GSO.4.56.0804111850060.16609@keg.few.vu.nl>
 <87r6daw2ay.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 13 Apr 2008, Andi Kleen wrote:

> Erik Bosman <ebn310@few.vu.nl> writes:
>
> >     This patch adds prctl commands that make it possible
> >     to deny the execution of timestamp counters in userspace.
> >     If this is not implemented on a specific architecture,
> >     prctl will return -EINVAL.
>
> You forgot to state why you need that?
>
> -Andi
>

I'm using it for deterministic replay. With this trap it is
possible to emulate the instruction using ptrace and knowing
the outcome. Deterministic replay can be useful, amongst other
things, for debugging and security (instructing your debugger
to undo instructions for example, to see what happened before
a fault.)

Not having this trap means emulation should be used to catch
the instruction, leading to bad performance.

Without the timestamp counter, the only instruction leading
to non-determinism (that I'm aware of) is the CPUID instruction
that returns on which core it runs, but that doesn't seem to
be used that much.

Erik Bosman
