Return-Path: <linux-kernel-owner+w=401wt.eu-S1759157AbYDMQsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759157AbYDMQsM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 12:48:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755608AbYDMQsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 12:48:00 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:11235 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755767AbYDMQr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 12:47:59 -0400
To: Erik Bosman <ejbosman@cs.vu.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrea Arcangeli <andrea@cpushare.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Add prctl commands PR_GET_TSC and PR_SET_TSC
From: Andi Kleen <andi@firstfloor.org>
References: <Pine.GSO.4.56.0804111850060.16609@keg.few.vu.nl>
	<87r6daw2ay.fsf@basil.nowhere.org>
	<Pine.GSO.4.56.0804131126080.28138@keg.few.vu.nl>
Date: Sun, 13 Apr 2008 18:47:32 +0200
In-Reply-To: <Pine.GSO.4.56.0804131126080.28138@keg.few.vu.nl> (Erik Bosman's message of "Sun, 13 Apr 2008 11:44:46 +0200 (CEST)")
Message-ID: <87prstwvkr.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 13 Apr 2008 16:40:48.0127 (UTC) FILETIME=[207C08F0:01C89D85]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Erik Bosman <ejbosman@cs.vu.nl> writes:
>
> I'm using it for deterministic replay.

Ok that should be in the changelog.

BTW x86 CPUs are not fully deterministic. e.g. there are a few errata that
can lead to differing EFLAGS (generally for instructions with undefined flags 
output) based on random internal pipe line conditions.

In my experience even simulators claiming to be fully deterministic
are not always. e.g. I remember trying to use instruction counts
on Simics to reproduce an issue for a scripted boot setup (with no user input),
but it never quite hit the same code at the same instruction count.

> Without the timestamp counter, the only instruction leading
> to non-determinism (that I'm aware of) is the CPUID instruction
> that returns on which core it runs, but that doesn't seem to
> be used that much.

There's also RDPMC, but by default the kernel does not enable that
for ring 3. And if you go for oddities there are the random number
generator instructions on VIA CPUs which will obviously not 
be repeatable.

-Andi
