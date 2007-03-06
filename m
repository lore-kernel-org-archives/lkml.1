Return-Path: <linux-kernel-owner+w=401wt.eu-S932167AbXCFVEF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167AbXCFVEF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 16:04:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932212AbXCFVEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 16:04:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37876 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932167AbXCFVED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 16:04:03 -0500
Date: Tue, 6 Mar 2007 22:03:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Gerd Hoffmann <kraxel@suse.de>,
       virtualization <virtualization@lists.osdl.org>,
       Jan Beulich <jbeulich@novell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>
Subject: Re: Xen & VMI?
Message-ID: <20070306210334.GC26348@elte.hu>
References: <45ECBDDC.8080708@vmware.com> <45ECC076.9050209@goop.org> <45ECC91D.1020809@vmware.com> <45ECC9B6.1060209@goop.org> <20070306081909.GA9331@elte.hu> <45ED2837.3020108@suse.de> <20070306085222.GA17002@elte.hu> <20070306194612.GG19575@sequoia.sous-sol.org> <20070306203018.GA21736@elte.hu> <20070306205351.GA10574@sequoia.sous-sol.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070306205351.GA10574@sequoia.sous-sol.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Chris Wright <chrisw@sous-sol.org> wrote:

> > i'm still arguing the same: that doing the same thing via 
> > overlapping, conflicting, redundant ABIs is crazy and contrary to 
> > the basic interests of Linux. It's like having 5 different, parallel 
> > variants of sys_open(), interfaced via a convoluted open_ops.
> 
> I would've said 5 parallel implementations of inode->i_op simply given 
> the nature of the operations, which is entirely sane.

with the big freaking difference that the 5 parallel implementations of 
inode->i_op are:

	_internal to Linux_

Doh. There's only a data ABI underneath them.

every time someone tried to impose a functional/behavioral ABI on core 
bits of Linux we said: 'no way dude!'. Remember STREAMS? Remember the 
module KABI? Remember ACPI? [doh, i guess we messed up on the latter 
one. We regret that day ever since.]

(network file systems are a bit of an exception to the rule, but those 
are pretty isolated themselves and in no way as wide and central as the 
direction paravirt_ops appears to grow.)

> > having data ABI coupling is one thing (filesystems, network formats, 
> > etc.). But having a 5-way function ABI coupling between system 
> > software running on the /same piece of hardware/, doing the same 
> > thing in essence is just madness in my book.
> 
> This is where I'm not understanding your argument.  The hardware is 
> somewhat irrelevant since the OS is running on a platform presented by 
> the hypervisor.  And the point is to allow multiple implementations of 
> the OS opertations that interact with the platform.  And in essence 
> all network stacks and file systems are doing the same thing with the 
> same hardware. [...]

again, those are /DATA/ ABIs. Not function ABIs. Not behavioral ABIs. 
The coupling is /FAR/ saner and far more plannable and far more 
isolated. And even data ABIs are very non-trivial ...

	Ingo
