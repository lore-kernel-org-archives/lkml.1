Return-Path: <linux-kernel-owner+w=401wt.eu-S1761236AbXKOHn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761236AbXKOHn5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 02:43:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755125AbXKOHns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 02:43:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48723 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586AbXKOHnr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 02:43:47 -0500
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Russell Leighton <russ@elegant-software.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: OT: Does Linux have any "Perfect Code"
From: Andi Kleen <andi@firstfloor.org>
References: <c9d133bdb3481fbc01a572d948049f5e@elegant-software.com>
	<473BE75B.9070701@cosmosbay.com>
Date: Thu, 15 Nov 2007 08:43:46 +0100
In-Reply-To: <473BE75B.9070701@cosmosbay.com> (Eric Dumazet's message of "Thu\, 15 Nov 2007 07\:29\:47 +0100")
Message-ID: <p73mytgc5sd.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet <dada1@cosmosbay.com> writes:
>
> http://cvs.opensolaris.org/source/xref/onnv/onnv-gate/usr/src/uts/common/os/timers.c#1106
>
> I would say this code was OK 10 years ago.

I would have expected 1997 compilers to already do these standard muliplication
optimizations. 

> Now that a processor (say an Opteron in 64 bits mode, used on SUN
> hardware), can perform a multiply in few cycles, ts2hrt() could use a
> normal multiply and an addition.

To be fair Linux runs on a lot of CPUs which are not quite as fast
at multiplying as an Opteron, especially not for 64bit multiplies.
So some optimizations might be still a good idea.  For divisions
at least Linux also actively does this.

On the other hand compilers also get worse. Modern gccs now turn

while (nsec >= NANOSEC) {
      nsec -= NANOSEC;
      sec++;
}

into a division which is actually much slower. Or insert unnecessary
cache misses randomly. See the recent gcc thread safety discussion
where it turned out that the thread breaking optimization is actually
more a general pessimization.

-Andi
