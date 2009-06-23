Return-Path: <linux-kernel-owner+w=401wt.eu-S1755491AbZFWMJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491AbZFWMJc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 08:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752946AbZFWMJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 08:09:24 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35400 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbZFWMJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 08:09:24 -0400
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Anders Kaseorg <andersk@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [RFC][ PATCH -tip v2 0/7] kprobes: Kprobes jump optimization support
From: Andi Kleen <andi@firstfloor.org>
References: <20090622212255.5384.53732.stgit@localhost.localdomain>
Date: Tue, 23 Jun 2009 14:09:24 +0200
In-Reply-To: <20090622212255.5384.53732.stgit@localhost.localdomain> (Masami Hiramatsu's message of "Mon, 22 Jun 2009 17:22:55 -0400")
Message-ID: <87vdmn179n.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu <mhiramat@redhat.com> writes:
>
> The gcc's crossjumping unifies equivalent code by inserting indirect
> jumps which jump into other function body. It is hard to know to where
> these jumps jump, so I decided to disable it when setting
> CONFIG_OPTPROBES=y.

That sounds quite bad. Tail call optimization is an important optimization
that especially on kernel style code (lots of indirect pointers
and sometimes deep call chains) is very useful.  It would be quite
sad if production kernels would lose that optimization.

Also tail calls in C should always jump directly to another function,
so they shouldn't be particularly complex to manage.

> I also decided not to optimize probes when it is in functions which
> will cause exceptions, because the exception in the kernel will jump
> to a fixup code and the fixup code jumps back to the middle of the
> same function body.

Note that not only exceptions do that, there are a few other cases
where jumps in and out of out of line sections happen. You might
need a more general mechanism to detect this.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
