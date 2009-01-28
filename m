Return-Path: <linux-kernel-owner+w=401wt.eu-S1752621AbZA1SIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621AbZA1SIf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 13:08:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751404AbZA1SI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 13:08:26 -0500
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:37101 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbZA1SIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 13:08:25 -0500
Date: Wed, 28 Jan 2009 23:38:15 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, stern@rowland.harvard.edu, roland@redhat.com,
       mingo@elte.hu, richardj_moore@uk.ibm.com, naren@linux.vnet.ibm.com
Subject: Re: [RFC Patch 0/9] Hardware Breakpoint interfaces - v4
Message-ID: <20090128180815.GA4563@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090122135640.GA11161@in.ibm.com> <20090127161518.88ac3f1c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090127161518.88ac3f1c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 04:15:18PM -0800, Andrew Morton wrote:
> On Thu, 22 Jan 2009 19:26:40 +0530
> "K.Prasad" <prasad@linux.vnet.ibm.com> wrote:
> 
> > Hi All,
> > 	Please find the new set of patches that introduce kernel
> > interfaces to use Hardware Breakpoint registers and an implementation
> > for x86 (and x86_64) architecture, now labelled as Version IV.
> 
> What a lot of code.  It looks very readable, although I haven't read it
> yet.

Thanks for responding to the patches.

> 
> What I'm missing is a general overview: what does the feature do?  Why
> do we need it in the kernel?  What is the value?

The patchset brings in a feature to track all read or write operations
on any given kernel data location. This will be useful in narrowing down
problems such as memory corruption wherein all 'write operations' on a
given kernel variable can be easily tracked or to know the value of an
interesting variable/counter when a 'condition' (denoted again by a
variable has changed).

The framework proposed for using Hardware breakpoint registers through
this patch will eventually be extended to exploit other arch-specific
features that allow I/O breakpoints (to intercept erroneous I/O
transactions).

> 
> I see mention of converting kgdb.  OK.  But are there plans to convert
> anything else in-kernel to use this?
> 

ptrace which uses HW Breakpoint registers based on requests from
applications in user-space (typically GDB-like debuggers) have been
using the HW Breakpoint registers directly. This is now converted to use
the proposed APIs - register_user_hw_breakpoint().

> I see some exported-to-modules API for kernel developers to use (I
> assume).  It would be appropriate to add an overview of that capability
> in the [0/n] patch description.

Sure. I will provide a description of the capabilities. I eventually
plan an addition to the Documentation/ directory with detailed
explanation.

> 
> Similarly I see something about "user breakpoints" but I'm not seeing
> any description of what they are, nor how they are used, nor what value
> they bring, etc.

The reason being that the register_user_hw_breakpoint() interface hasn't
been exported currently, atleast not in the first iteration of
submission. The only in-kernel user would be ptrace which will invoke
the worker routine __register_user_hw_breakpoint() directly.

When exported, they will also help avoid some of the problems arising
 due to the fine-granular approach taken by ptrace towards HW registers
(which needs a new syscall for every register-write. For e.g., two
syscalls will be required to set a breakpoint in x86, one to write the
address and the other to enable control register dr7).

> 
> 
> IOW, we need the glossy sales brochure, please.a

Certainly. My next set of patches, which should fix the issue in
creating user-space breakpoints will contain a descriptive [Patch 0/n]
and will eventually contain a Documentation/hw_breakpoint.txt.

Thanks,
K.Prasad
 
