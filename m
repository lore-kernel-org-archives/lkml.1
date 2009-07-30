Return-Path: <linux-kernel-owner+w=401wt.eu-S1751431AbZG3OK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431AbZG3OK2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 10:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbZG3OK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 10:10:28 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:7088 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbZG3OK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 10:10:27 -0400
X-SourceIP: 213.93.53.227
Subject: Re: I.1 - System calls - ioctl
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: eranian@gmail.com
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
In-Reply-To: <7c86c4470907300658j62410f05k1ac66eefe866780d@mail.gmail.com>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
	 <20090622114931.GB24366@elte.hu> <20090622125837.GA9429@infradead.org>
	 <1247482393.7529.74.camel@twins>
	 <7c86c4470907300658j62410f05k1ac66eefe866780d@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 30 Jul 2009 16:13:31 +0200
Message-Id: <1248963211.6391.45.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-30 at 15:58 +0200, stephane eranian wrote:
> On Mon, Jul 13, 2009 at 12:53 PM, Peter Zijlstra<a.p.zijlstra@chello.nl> wrote:
> > On Mon, 2009-06-22 at 08:58 -0400, Christoph Hellwig wrote:
> >> But talking about syscalls the sys_perf_counter_open prototype is
> >> really ugly - it uses either the pid or cpu argument which is a pretty
> >> clear indicator it should actually be two sys calls.
> >
> > Would something like the below be any better?
> >
> > It would allow us to later add something like PERF_TARGET_SOCKET and
> > things like that.
> 
> One thing for sure, you need to provision for future targets, SOCKET
> is an obvious
> one. But given that your goal is to have a generic API, not just for
> CPU PMU, then you
> need to be able to add new targets, e.g., socket, chipset, GPU. The
> current model with
> pid and cpu is too limited, relying on flags to add more parameters
> for a target is not pretty.
> 
> Given that an event can only be attached to a single target at a time, it seems
> you could either do:
>    - encapsulate target type + target into a struct and pass that.
> This is your proposal here.

*nod*

>    - add a generic int target parameter and pass the target type in flags

This would mean reserving a number of bits in the flags field for this
target id. We can do that, I figure 8 should do.. (640kb should be
enough comes to mind though :-).

>    - provide one syscall per target type (seems to be Hellwig's)
> 
> Your scheme makes it possible to pass 64-bit target id. Not clear if
> this is really needed.

Yeah, not sure either, pids, fds and similar are all 32bit iirc. We do
have 64bit resource ids but that's for things like inodes, and I'm not
sure it'd make sense to attach a counter to an inode :-)


