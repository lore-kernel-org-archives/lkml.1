Return-Path: <linux-kernel-owner+w=401wt.eu-S1759367AbZFWNtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759367AbZFWNtz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 09:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756435AbZFWNtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 09:49:47 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36614 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755620AbZFWNtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 09:49:46 -0400
Message-ID: <4A40DDAD.6020202@redhat.com>
Date: Tue, 23 Jun 2009 09:50:37 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>,
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
Subject: Re: [RFC][ PATCH -tip v2 0/7] kprobes: Kprobes jump optimization
 support
References: <20090622212255.5384.53732.stgit@localhost.localdomain> <87vdmn179n.fsf@basil.nowhere.org>
In-Reply-To: <87vdmn179n.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

Andi Kleen wrote:
> Masami Hiramatsu <mhiramat@redhat.com> writes:
>> The gcc's crossjumping unifies equivalent code by inserting indirect
>> jumps which jump into other function body. It is hard to know to where
>> these jumps jump, so I decided to disable it when setting
>> CONFIG_OPTPROBES=y.
> 
> That sounds quite bad. Tail call optimization is an important optimization
> that especially on kernel style code (lots of indirect pointers
> and sometimes deep call chains) is very useful.  It would be quite
> sad if production kernels would lose that optimization.

I think the crossjumping is not the tail call optimization,
http://gcc.gnu.org/onlinedocs/gcc-3.4.6/gccint/Passes.html

> 
> Also tail calls in C should always jump directly to another function,
> so they shouldn't be particularly complex to manage.

Tail call jumps directly into the head of another function,
not the middle. Thus it is safe.

>> I also decided not to optimize probes when it is in functions which
>> will cause exceptions, because the exception in the kernel will jump
>> to a fixup code and the fixup code jumps back to the middle of the
>> same function body.
> 
> Note that not only exceptions do that, there are a few other cases
> where jumps in and out of out of line sections happen. You might
> need a more general mechanism to detect this.

As far as I can see (under arch/x86), Almost all fixup entries are
defined with ex_table entries, and others jump to the head of
symbols(or functions). The jumps which jump into the middle of
some functions are what I need to find, and, as far as I know,
those fixup jumps are used with exception tables. Of course,
I might miss some fixup codes, in that case, please let me know:-)

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

