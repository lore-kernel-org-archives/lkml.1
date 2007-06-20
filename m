Return-Path: <linux-kernel-owner+w=401wt.eu-S1762180AbXFTEpF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762180AbXFTEpF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 00:45:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756869AbXFTEoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 00:44:55 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38897 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753864AbXFTEoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 00:44:54 -0400
Date: Tue, 19 Jun 2007 21:44:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Jones <davej@redhat.com>
Cc: tim.c.chen@linux.intel.com, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Change in default vm_dirty_ratio
Message-Id: <20070619214407.dfff0ca6.akpm@linux-foundation.org>
In-Reply-To: <20070620042434.GC12096@redhat.com>
References: <1182201271.4883.22.camel@localhost.localdomain>
	<20070618164711.9de1c38e.akpm@linux-foundation.org>
	<20070620042434.GC12096@redhat.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2007 00:24:34 -0400 Dave Jones <davej@redhat.com> wrote:

> On Mon, Jun 18, 2007 at 04:47:11PM -0700, Andrew Morton wrote:
> 
>  > Frankly, I find it very depressing that the kernel defaults matter.  These
>  > things are trivially tunable and you'd think that after all these years,
>  > distro initscripts would be establishing the settings, based upon expected
>  > workload, amount of memory, number and bandwidth of attached devices, etc.
> 
> "This is hard, lets make it someone else's problem" shouldn't ever be the
> answer,

Bovine droppings.  Nobody has even tried.

> especially if the end result is that we become even more
> dependant on bits of userspace running before the system becomes useful.

Cattle excreta.  The kernel remains as it presently is.  No less useful that it is
now.

>  > Heck, there should even be userspace daemons which observe ongoing system
>  > behaviour and which adaptively tune these things to the most appropriate
>  > level.
>  > 
>  > But nope, nothing.
> 
> See the 'libtune' crack that people have been trying to get distros to
> adopt for a long time.
> If we need some form of adaptive behaviour, the kernel needs to be
> doing this monitoring/adapting, not some userspace daemon that may
> not get scheduled before its too late.

Userspace has just as much info as the kernel has and there is no latency
concern here.

> If the kernel can't get the defaults right, what makes you think
> userspace can do better ?

Because userspace can implement more sophisticated algorithms and is more
easily configured.

For example, userspace can take a hotplug event for the just-added
usb-storage device then go look up its IO characteristics in a database
and then apply that to the confgured policy.  If the device was not found,
userspace can perform a test run to empirically measure that device's IO
characteristics and then record them in the database.  I don't think we'll
be doing this in-kernel any time soon.

(And to preempt lkml-games: this is just an _example_.  There are
others)

>    Just as the kernel can't get
> "one size fits all" right, there's no silver bullet just by clicking
> "this is a database server" button to have it configure random
> sysctls etc.  These things require thought and planning that
> daemons will never get right in every case.  And when they get
> it wrong, the results can be worse than the stock defaults.
> 
> libtune is the latest in a series of attempts to do this dynamic
> runtime adjustment (hell, I even started such a project myself
> back circa 2000 which thankfully never really took off).
> It's a bad idea that just won't die.
> 

So libtune is the only possible way of implementing any of this?


If choosing the optimum settings cannot be done in userspace then it sure
as heck cannot be done in-kernel.


Anyway, this is all arse-about.  What is the design?  What algorithms
do we need to implement to do this successfully?  Answer me that, then
we can decide upon these implementation details.
