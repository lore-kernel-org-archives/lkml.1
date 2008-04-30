Return-Path: <linux-kernel-owner+w=401wt.eu-S1759535AbYD3JIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759535AbYD3JIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 05:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754953AbYD3JIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 05:08:38 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:48813 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755559AbYD3JIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 05:08:37 -0400
Subject: Re: [RFC][PATCH 2/5] Container Freezer: Make refrigerator always
	available
From: Matt Helsley <matthltc@us.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Cedric Le Goater <clg@fr.ibm.com>, Paul Menage <menage@google.com>,
       Oren Laadan <orenl@cs.columbia.edu>,
       linux-pm@lists.linux-foundation.org,
       Linux Containers <containers@lists.linux-foundation.org>
In-Reply-To: <20080425110456.GF14903@elf.ucw.cz>
References: <20080424064756.643890130@us.ibm.com>
	 <20080424064757.227289200@us.ibm.com>  <20080425110456.GF14903@elf.ucw.cz>
Content-Type: text/plain
Organization: IBM Linux Technology Center
Date: Wed, 30 Apr 2008 02:08:29 -0700
Message-Id: <1209546509.6095.133.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-04-25 at 13:04 +0200, Pavel Machek wrote:
> Hi!
> 
> > Now that the TIF_FREEZE flag is available in all architectures,
> > extract the refrigerator() and freeze_task() from kernel/power/process.c
> > and make it available to all.
> > 
> > The refrigerator() can now be used in a control group subsystem 
> > implementing a control group freezer.
> > 
> > Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
> > Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
> > Tested-by: Matt Helsley <matthltc@us.ibm.com>
> 
> There's no problem with doing this... but you should get some debate
> (with Linus?) whether using freezer for cgroups is sane. When that is

	OK, I've sent this reply directly to Linus. Hopefully this time he'll
let us know...

	One potential mitigating factor: I don't think we need the full freezer
for checkpoint/restart. Right now, because it shares code with "power
management" it's convenient to reuse the freezer. I'm hopeful that once
the freezer is no longer necessary for power management some code paths
can be simplified since I don't think checkpoint/restart requires
freezing kernel threads.

> done, there's no problem with this going in, probably through rafael's
> patch queue.

	OK, if all goes well then I'll send the next round to Rafael and Cc the
rest. If anyone currently on Cc doesn't care to see that feel free to
let me know.

> (The first patch -- add freezer for all archs -- is probably
> reasonably to go in ASAP, through akpm or something...)
> 								Pavel

	Well, that should only go in if the subsequent patches go in, correct?
Also, since to the best of my knowledge this flag hasn't been in every
arch, I'm wondering if I should Cc arch maintainers?

Cheers,
	-Matt Helsley

