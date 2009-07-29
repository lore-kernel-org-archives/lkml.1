Return-Path: <linux-kernel-owner+w=401wt.eu-S1754631AbZG2WVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631AbZG2WVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 18:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754192AbZG2WVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 18:21:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:59133 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753989AbZG2WVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 18:21:15 -0400
Date: Thu, 30 Jul 2009 00:17:03 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: eranian@gmail.com, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>,
       Michael Kerrisk <mtk.manpages@googlemail.com>
Subject: Re: perf_counters issue with self-sampling threads
Message-ID: <20090729221703.GA25368@redhat.com>
References: <7c86c4470907270951i48886d56g90bc198f26bb0716@mail.gmail.com> <1248869948.6987.3083.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1248869948.6987.3083.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(add Roland)

On 07/29, Peter Zijlstra wrote:
>
> On Mon, 2009-07-27 at 18:51 +0200, stephane eranian wrote:
> >
> > POSIX does not mandate that asynchronous signals be delivered
> > to the thread in which they originated. Any thread in the process
> > may process the signal, assuming it does not have the signal
> > blocked.

Yes. I now nothing about POSIX, but this is what Linux does at least.
I don't think we can/should change this behaviour.

> fcntl(2) for F_SETOWN says:
>
> If a non-zero value is given to F_SETSIG  in  a  multi‐ threaded
> process running with a threading library that supports thread groups
> (e.g., NPTL),  then  a  positive value  given  to  F_SETOWN  has  a
> different  meaning: instead of being a process ID identifying a whole
> pro‐ cess,  it  is a thread ID identifying a specific thread within a
> process.

Heh. Definitely this is not what Linux does ;)

> Which seems to imply that when we feed fcntl(F_SETOWN) a TID instead of
> a PID it should deliver SIGIO to the thread instead of the whole process
> -- which, to me, seems a sane semantic.

I am not sure I understand the man above... But to me it looks like we
should always send a private signal when fown->signum != 0 ?

The change should be simple, but as you pointed out we can break things.

Oleg.

