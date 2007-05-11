Return-Path: <linux-kernel-owner+w=401wt.eu-S1758809AbXEKEyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758809AbXEKEyS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 00:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754059AbXEKEyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 00:54:09 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:37793 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995AbXEKEyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 00:54:08 -0400
Date: Fri, 11 May 2007 10:27:29 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <ak@muc.de>,
       systemtap@sources.redhat.com, prasanna@in.ibm.com,
       anil.s.keshavamurthy@intel.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, hch@infradead.org,
       richardj_moore@uk.ibm.com, suparna@in.ibm.com
Subject: Re: [patch 05/10] Linux Kernel Markers - i386 optimized version
Message-ID: <20070511045729.GA8143@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20070510015555.973107048@polymtl.ca> <20070510020916.508519573@polymtl.ca> <20070510090656.GA57297@muc.de> <20070510155501.GI22424@Krystal> <20070510172843.7aa72237@the-village.bc.nu> <20070510165918.GK22424@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070510165918.GK22424@Krystal>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 12:59:18PM -0400, Mathieu Desnoyers wrote:
> * Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:

...
> > > * Third issue : Scalability. Changing code will stop every CPU on the
> > >   system for a while. Compared to this, the int3-based approach will run
> > >   through the breakpoint handler "if" one of the CPU happens to execute
> > >   this code at the wrong time. The standard case is just an IPI (to
> > 
> > If I read the errata right then patching in an int3 will itself trigger
> > the errata so anything could happen.
> > 
> > I believe there are other safe sequences for doing code patching - perhaps
> > one of the Intel folk can advise ?

IIRC, when the first implementation of what exists now as kprobes was
done (as part of the dprobes framework), this question did come up. I
think the conclusion was that the errata applies only to multi-byte
modifications and single-byte changes are guaranteed to be atomic.
Given int3 on Intel is just 1-byte, we are safe.

> I'll let the Intel guys confirm this, I don't have the reference nearby
> (I got this information by talking with the kprobe team members, and
> they got this information directly from Intel developers) but the
> int3 is the one special case to which the errata does not apply.
> Otherwise, kprobes and gdb would have a big, big issue.

Perhaps Richard/Suparna can confirm.

Ananth
