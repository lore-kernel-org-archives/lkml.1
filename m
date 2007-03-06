Return-Path: <linux-kernel-owner+w=401wt.eu-S1750907AbXCFUx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750907AbXCFUx6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 15:53:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751023AbXCFUx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 15:53:58 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:51016 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbXCFUx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 15:53:57 -0500
Date: Tue, 6 Mar 2007 12:53:51 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Chris Wright <chrisw@sous-sol.org>, Gerd Hoffmann <kraxel@suse.de>,
       virtualization <virtualization@lists.osdl.org>,
       Jan Beulich <jbeulich@novell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>
Subject: Re: Xen & VMI?
Message-ID: <20070306205351.GA10574@sequoia.sous-sol.org>
References: <1173142644.4644.6.camel@localhost.localdomain> <45ECBDDC.8080708@vmware.com> <45ECC076.9050209@goop.org> <45ECC91D.1020809@vmware.com> <45ECC9B6.1060209@goop.org> <20070306081909.GA9331@elte.hu> <45ED2837.3020108@suse.de> <20070306085222.GA17002@elte.hu> <20070306194612.GG19575@sequoia.sous-sol.org> <20070306203018.GA21736@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070306203018.GA21736@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Chris Wright <chrisw@sous-sol.org> wrote:
> 
> > What are you driving at?  You seem to be arguing that abstractions are 
> > bad unless done via ABI's. [...]
> 
> i'm still arguing the same: that doing the same thing via overlapping, 
> conflicting, redundant ABIs is crazy and contrary to the basic interests 
> of Linux. It's like having 5 different, parallel variants of sys_open(), 
> interfaced via a convoluted open_ops.

I would've said 5 parallel implementations of inode->i_op simply given
the nature of the operations, which is entirely sane.

> having data ABI coupling is one thing (filesystems, network formats, 
> etc.). But having a 5-way function ABI coupling between system software 
> running on the /same piece of hardware/, doing the same thing in essence 
> is just madness in my book.

This is where I'm not understanding your argument.  The hardware is
somewhat irrelevant since the OS is running on a platform presented by the
hypervisor.  And the point is to allow multiple implementations of the OS
opertations that interact with the platform.  And in essence all network
stacks and file systems are doing the same thing with the same hardware.
Here's the reality.  None of these hypervisors will be ABI compliant in
the way syscalls are (namely trap insn and hypercall number).  So there's
a bunch of glue wherever you design the system.  Your arguement is that in
some (arguably random) instances it makes sense to push the glue into
the ROM.  This idea that lguest and KVM come from the same source tree
is irrelevant when the issues you site are about support matrices (which
means that guest and host may not have come from the same source afterall).
I still don't understand your issue.

thanks,
-chris
