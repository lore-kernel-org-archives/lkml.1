Return-Path: <linux-kernel-owner+w=401wt.eu-S1758030AbXIMNYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030AbXIMNYw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 09:24:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753401AbXIMNYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 09:24:45 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:36588 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042AbXIMNYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 09:24:43 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: pete@bluelane.com
Cc: Jason Wessel <jason.wessel@windriver.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, Matt Mackall <mpm@selenic.com>,
       Amit Kale <amitkale@linsyssoft.com>,
       Dave Anderson <anderson@redhat.com>, kdb@oss.sgi.com, jlan@sgi.com,
       Vivek Goyal <vgoyal@in.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kexec Mailing List <kexec@lists.infradead.org>,
       <linux-kernel@vger.kernel.org>
Subject: My position on general ``RAS'' tool support infrastructure
References: <46E8B06D.9080006@bluelane.com>
Date: Thu, 13 Sep 2007 07:21:10 -0600
In-Reply-To: <46E8B06D.9080006@bluelane.com> (pete@bluelane.com's message of
	"Wed, 12 Sep 2007 20:37:17 -0700")
Message-ID: <m1abrq7lbt.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pete/Piet Delaney <pete@bluelane.com> writes:

> Jason, Eric:
>
> Did you read Keith Owens suggestion on RAS tools from:

Yes.

There is a tension here between generality of support infrastructure,
maintainability of the infrastructure, simplicity of the
infrastructure and reliability of the infrastructure.

The historical linux perspective is that anything that compromises
the maintainability or the reliability of the kernel without the
tools is unacceptable.

There is also a historical perspective that using the single stepping
mode of a debugger to diagnose problems frequently leads to symptoms
being fixed and not the actual problems being fixed.

My initial proposal in this thread was that if kdb wanted to have
a hook point someplace where were not comfortable adding a hook
point it could use a break point or some of the tracing
infrastructure.  Somehow that suggestion seems to have gotten lost.

On the kexec on panic path the philosophy is that the kernel is
broken and as little as possible should be relied upon.  So in general
I am opposed to extra code on that path.  General hooks like notifiers
in particular, because they make adding non-paranoid code much easier
and review of the code on a particular call path much harder.

>From what I can tell the philosophy of the kdb code is that the kernel
is mostly ok except for one or two little bugs so it is reasonable to
rely on lots of kernel infrastructure.

As I understand the problem the difference in philosophy and
maintenance overhead is why kexec on panic has been merged and why
it has a much larger success rate the previous crash dump
implementation like lkcd.  I will not that in some sense it is a
harder approach to implement as it emphasizes the challenge of
drivers that work starting from a random hardware state, and because
it draws a clear line between the broken kernel and the recover
kernel.  But those things are exactly what encourage things to work
well.

I don't mind playing well with others as long as that doesn't
compromise the implementation reliability, and maintainability.

So far it is my opinion that the current kexec on panic implementation
is insufficiently paranoid and touches the hardware and the rest of
the kernel too much.   Which explains my rather strong reactions when
people suggest that we trust the broken kernel more.

I don't think this is an insolvable problem but I do think it is hard
problem that must be solved with delicacy.

I also get irritable that the last time something like this came up
I had to have a several day long conversation with someone about why
they need a patch that has already been rejected because it
compromised the reliability of the implementation only to discover
they were trying to make kdb and kexec on panic play nice together.

So if someone who is suggesting an implementation can absorb 
and understand the requirements of the different groups and come
up with solutions that meet the requirements of the different projects
I think progress can be made.  That as far as I know takes talent.

If we wind up with a situation where we have to continually review
unacceptable solutions the choices are either get negative about it
and reject everything, or give up and let something through.  Since
I think giving up in this situation is irresponsible and likely to
make a worse kernel I am leaning very strongly towards NAK'ing
everything because I have seen so many problematic proposals that did
not look like they were on the path to something reasonable.

Eric
