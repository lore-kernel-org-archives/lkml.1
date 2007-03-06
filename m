Return-Path: <linux-kernel-owner+w=401wt.eu-S1030193AbXCFV3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030193AbXCFV3q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 16:29:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030182AbXCFV3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 16:29:45 -0500
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:49268 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965217AbXCFV3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 16:29:43 -0500
Date: Tue, 6 Mar 2007 13:28:55 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Chris Wright <chrisw@sous-sol.org>, Gerd Hoffmann <kraxel@suse.de>,
       virtualization <virtualization@lists.osdl.org>,
       Jan Beulich <jbeulich@novell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>
Subject: Re: Xen & VMI?
Message-ID: <20070306212855.GB10574@sequoia.sous-sol.org>
References: <45ECC076.9050209@goop.org> <45ECC91D.1020809@vmware.com> <45ECC9B6.1060209@goop.org> <20070306081909.GA9331@elte.hu> <45ED2837.3020108@suse.de> <20070306085222.GA17002@elte.hu> <20070306194612.GG19575@sequoia.sous-sol.org> <20070306203018.GA21736@elte.hu> <20070306205351.GA10574@sequoia.sous-sol.org> <20070306210334.GC26348@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070306210334.GC26348@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> with the big freaking difference that the 5 parallel implementations of 
> inode->i_op are:
> 
> 	_internal to Linux_

Granted.  Until it's modprobe xen.ko, vmware.ko, viridian.ko...that's
not going to go away, even with the VMI.

> Doh. There's only a data ABI underneath them.

Perhaps from the syscall perspective.  But there's also things like
internal interactions with the page cache, VMA and pt updates, etc
which are much more functional/behavioural than purely moving data.
And when we're talking about page tables or simlar for hv, I think the
data vs. functional is an oversimplification.

> every time someone tried to impose a functional/behavioral ABI on core 
> bits of Linux we said: 'no way dude!'. Remember STREAMS? Remember the 
> module KABI? Remember ACPI? [doh, i guess we messed up on the latter 
> one. We regret that day ever since.]

Heheh, OK, now I know I'm lost when we've both used ACPI as a negative
example to argue our point.  Honestly, all of the above suggest no VMI
to me (in fact, I used those type of arguments against VMI about 1 year
ago ;-).

> (network file systems are a bit of an exception to the rule, but those 
> are pretty isolated themselves and in no way as wide and central as the 
> direction paravirt_ops appears to grow.)
> 
> > > having data ABI coupling is one thing (filesystems, network formats, 
> > > etc.). But having a 5-way function ABI coupling between system 
> > > software running on the /same piece of hardware/, doing the same 
> > > thing in essence is just madness in my book.
> > 
> > This is where I'm not understanding your argument.  The hardware is 
> > somewhat irrelevant since the OS is running on a platform presented by 
> > the hypervisor.  And the point is to allow multiple implementations of 
> > the OS opertations that interact with the platform.  And in essence 
> > all network stacks and file systems are doing the same thing with the 
> > same hardware. [...]
> 
> again, those are /DATA/ ABIs. Not function ABIs. Not behavioral ABIs. 
> The coupling is /FAR/ saner and far more plannable and far more 
> isolated. And even data ABIs are very non-trivial ...

I agree that changing the interface to the low-level platform is tricky
and less isolated.  But how does the VMI protect you from those changes?
It simply doesn't, the changes are still necessary.  And the inflexibility
means the tough corner cases swept under the VMI rug are more difficult
to debug, get right, etc...

thanks,
-chris
