Return-Path: <linux-kernel-owner+w=401wt.eu-S1753700AbYGWP3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700AbYGWP3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 11:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751390AbYGWP3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 11:29:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:57311 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbYGWP3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 11:29:07 -0400
Date: Wed, 23 Jul 2008 08:28:56 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Rik van Riel <riel@redhat.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org
Subject: Re: systemtap & backward compatibility, was Re: [RFC] systemtap:
 begin the process of using proper kernel APIs
Message-ID: <20080723082856.334f9c17@infradead.org>
In-Reply-To: <20080723150434.GC11191@redhat.com>
References: <487E8CE4.70105@redhat.com>
	<1216259391.3358.85.camel@localhost.localdomain>
	<1216304290.5515.11.camel@localhost.localdomain>
	<1216313914.5515.25.camel__21144.9282979176$1216314027$gmane$org@localhost.localdomain>
	<y0m7ibkjrcj.fsf@ton.toronto.redhat.com>
	<1216325546.5515.63.camel@localhost.localdomain>
	<20080717202634.GI18295@redhat.com>
	<1216328769.5515.78.camel@localhost.localdomain>
	<20080717213355.GJ18295@redhat.com>
	<20080722140015.37628ea4@bree.surriel.com>
	<20080723150434.GC11191@redhat.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jul 2008 11:04:34 -0400
"Frank Ch. Eigler" <fche@redhat.com> wrote:

> Hi -
> 
> I wrote:
> 
> > > [...] One significant requirement for us is to keep working with
> > > older kernels.  [...]
> 
> Maybe it's worth elaborating on why the need for backward
> compatibility is different for systemtap than for typical kernel-side
> code.
> 
> The bulk of systemtap is a user-space program, and it does very
> user-spacey things like parsing dwarf and invoking compilers, running
> network servers.  Soon it will include user-space libraries.  It is so
> different from the stuff normally found there that no one has AFAIK
> seriously proposed that the entire software be made part of the kernel
> git tree.  So it is an ordinary separate user-space package, built by
> users and distributors.

so far so good...

> 
> It does happen to *generate* kernel modules.  The way that such a
> module must interface with any particular kernel is naturally subject
> to the whims & desires of the kernel du jour.  This is why we have a
> mass of mechanism to try to automatically speak to each kernel version
> as appropriate.

and this is where I strongly disagree.
THIS part *has* to be in the kernel source, so that we can change it
WITH the kernel as we change it. If this means that there's some
userland .so code in the kernel source, so be it. If it means we provide
some template files that your userland fills in the blanks for, even
better. (paint-by-number kernel modules!)

But to have any chance at all of systemtap being sustainable, this part
of the stack has to be together with where the changes happen.

> 
> It is desirable to minimize this mass for obvious reasons.  When a new
> upstream kernel comes out with a tasty new feature -- or a less tasty
> API rewrite -- we need to extend systemtap to support that too.

At that point you are already 3 months too late for me, and probably
for most of my fellow kernel hackers. THIS is exactly what makes
systemtap not usable for kernel hackers, and this is exactly why you
see very little contributions from kernel hackers.
(and when it's seen it gets a rather luke warm reception, but that's a
different story).

It also means that unless I want to package and build systemtap myself,
I have to wait for my OS vendor to think about moving to the kernel I'm
on before I can use systemtap. For me as kernel developer.. that's the
second show stopper already.


> To draw an analogy, systemtap is somewhat like low-level userspace
> code like glibc or syslogd or udevd.  I hope no one would seriously
> propose casually committing code to those packages that would make
> them unusable on prior kernel versions.  Accepting such a patch would
> require their maintainers to fork outright every time a kernel change
> occurs.

we've discussed pulling udev into the kernel source several times, and
the jury is still out on it.
But systemtap is NOT like udev or glibc or ..
it's a kernel component.. at least the part that generates the kernel
code is. it needs to breathe and move together with the kernel.
> 
> I hope this fills in some of the gaps in the background.

it explains where you're coming from, which is good. However I for one
really disagree with the assumption, and i just tried to point out that
the consequences of this are rather dreadful.

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
