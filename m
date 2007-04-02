Return-Path: <linux-kernel-owner+w=401wt.eu-S932500AbXDBGJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500AbXDBGJ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 02:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933740AbXDBGJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 02:09:57 -0400
Received: from mx1.suse.de ([195.135.220.2]:60347 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932500AbXDBGJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 02:09:55 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [patch 17/17] Add a sched_clock paravirt_op
Date: Mon, 2 Apr 2007 08:09:42 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Zachary Amsden <zach@vmware.com>,
       Dan Hecht <dhecht@vmware.com>, john stultz <johnstul@us.ibm.com>
References: <20070402055652.610711908@goop.org> <20070402055705.606126251@goop.org>
In-Reply-To: <20070402055705.606126251@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704020809.42373.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 April 2007 07:57, Jeremy Fitzhardinge wrote:
> The tsc-based get_scheduled_cycles interface is not a good match for
> Xen's runstate accounting, which reports everything in nanoseconds.
> 
> This patch replaces this interface with a sched_clock interface, which
> matches both Xen and VMI's requirements.
> 
> In order to do this, we:
>    1. replace get_scheduled_cycles with sched_clock
>    2. hoist cycles_2_ns into a common header
>    3. update vmi accordingly
> 
> One thing to note: because sched_clock is implemented as a weak
> function in kernel/sched.c, we must define a real function in order to
> override this weak binding.  This means the usual paravirt_ops
> technique of using an inline function won't work in this case.

I think it would be much cleaner if you didn't implement your own sched_clock,
but you adjust ns_base/last_tsc to account for your lost cycles.
This could be done cleanly by adding a new function to sched-clock.c
Possibly such a function could be used by other parts of the kernel
in the future too.

-Andi
