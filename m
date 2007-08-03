Return-Path: <linux-kernel-owner+w=401wt.eu-S1760764AbXHCHOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760764AbXHCHOq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 03:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756866AbXHCHOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 03:14:38 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:42425 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbXHCHOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 03:14:37 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Keith Owens <kaos@sgi.com>, vgoyal@in.ibm.com,
       Takenori Nagano <t-nagano@ah.jp.nec.com>, k-miyoshi@cb.jp.nec.com,
       Bernhard Walle <bwalle@suse.de>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] add kdump_after_notifier
References: <20070802112852.GA7054@in.ibm.com>
	<31687.1186113947@kao2.melbourne.sgi.com>
	<20070802232502.b93f4ea0.akpm@linux-foundation.org>
Date: Fri, 03 Aug 2007 01:10:44 -0600
In-Reply-To: <20070802232502.b93f4ea0.akpm@linux-foundation.org> (Andrew
	Morton's message of "Thu, 2 Aug 2007 23:25:02 -0700")
Message-ID: <m1hcnhm6tn.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:
>
> Much of the onus is upon the various RAS tool developers to demonstrate why it
> is unsuitable for their use and, hopefully, to explain how it can be fixed for
> them.

My current take on the situation.

There are 4 different cases we care about.
- Trivial in kernel message failure reports. (Oops, backtraces and the like)
- Crash dumps.
- Debuggers.
- kernel Probes.

The in kernel failure messages seem to be doing a good job and are
reasonably simple to maintain.

For crash dumping we have sufficient infrastructure in the kernel now in
the kexec on panic work, and it is simpler and more reliable then the
previous attempts.  Although those kernel code paths could be made
simpler yet and probably should be.

Only when it comes to debuggers does it seem we don't have something
we can generally settle on and agree on.

All I know is that any set of code that wants to be common
infrastructure that makes the assumption that the kernel is mostly
not broken is not interesting for use when things are fully automated.
Because it fails to work in real world failure cases.  Those things
only work in the artificial testing environments of developers.

Right now I have seen so little to seriously address these real
world concerns in suggests or patches for some kind of infrastructure
that I'm tired of discussing it.  I admit I haven't seen or heard of those
patches either but even their description sounds non-interesting.

Eric
