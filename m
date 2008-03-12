Return-Path: <linux-kernel-owner+w=401wt.eu-S1752276AbYCLGxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276AbYCLGxR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 02:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751012AbYCLGxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 02:53:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:17287 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875AbYCLGxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 02:53:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,484,1199692800"; 
   d="scan'208";a="262059317"
Subject: Re: [PATCH -mm] kexec jump -v9
From: "Huang, Ying" <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <m1abl4znw6.fsf@ebiederm.dsl.xmission.com>
References: <1204773188.4707.109.camel@caritas-dev.intel.com>
	 <20080311211004.GA30164@redhat.com>
	 <1205286326.29069.16.camel@caritas-dev.intel.com>
	 <m1abl4znw6.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 12 Mar 2008 14:54:48 +0800
Message-Id: <1205304888.10239.0.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-OriginalArrivalTime: 12 Mar 2008 06:53:00.0627 (UTC) FILETIME=[B6329A30:01C8840D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-03-11 at 20:17 -0600, Eric W. Biederman wrote:
> "Huang, Ying" <ying.huang@intel.com> writes:
> 
> > Yes. The entry point should be saved in dump.elf itself, this can be
> > done via a user-space tool such as "makedumpfile". Because
> > "makedumpfile" is also used to exclude free pages from disk image, it
> > needs a communication method between two kernels (to get backup pages
> > map or something like that from kernel A). We have talked about this
> > before.
> >
> > - Your opinion is to communicate via the purgatory. (But I don't know
> > how to communicate between kernel A and purgatory).
> 
> How about the return address on the stack?
> 
> > - Eric's opinion is to communicate between the user space in kernel A
> > and user space in kernel B.
> 
> Purgatory is for all intents and purposes user space.  Because the
> return address falls on the trampoline page we won't know it's
> address before we call kexec.  But a return address and a stack
> on that page should be a perfectly good way to communicate.
> 
> > - My opinion is to communicate between two kernel directly.
> >
> > I think as a minimal infrastructure patch, we can communicate minimal
> > information between user space of two kernels. When we have consensus on
> > this topic, we can use makedumpfile for both excluding free pages and
> > saving the entry point. Now, we can save the entry point in a separate
> > file or I can write a simple tool to do this.
> 
> We need a fixed protocol so we do not make assumptions about how things
> will be implemented, allowing kernels to diverge and kinds of other
> good things.
> 
> For communicating extra information from the kernel being shut down
> we have elf notes.
> 
> Direct kernel to kernel communication is forbidden.  We must have
> a well defined protocol.  Allowing the implementations to change
> at their different speeds, and still work together.

This sounds reasonable. But after some initial trying I found it is
fairly difficult for me to define a communication protocol to be back
compatible with original kexec/kdump, doing work in user space as far as
possible, dealing with some special scenario (such as: A kexec B, then B
kexec C). So I will try my best to work on this, and propose a
communication protocol combining the proposals from you and Vivek in
several days.

> >> May be we can have a separate load flag (--load-resume-image) to mark
> >> that we are resuming an hibernated image and kexec does not have to
> >> prepare commandline, does not have to prepare zero page/setup page etc.
> >
> > There is already similar flag in original kexec-tools implementation:
> > "--args-none". If it is specified, kexec-tools does not prepare command
> > line and zero page/setup page etc. I think we can just re-use this flag.
> > And If it is desired an alias is good for me too.
> 
> My gut feel is we look at the image and detect what kind it is, and simply
> not enable image processing after we have read the note that says it
> is a resumable core or whatever.

Yes. This sounds good.

Best Regards,
Huang Ying

