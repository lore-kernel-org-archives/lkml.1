Return-Path: <linux-kernel-owner+w=401wt.eu-S1030298AbXAYQjD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030298AbXAYQjD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 11:39:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030304AbXAYQjC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 11:39:02 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:26981 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030298AbXAYQjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 11:39:01 -0500
Date: Thu, 25 Jan 2007 08:34:24 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/6] Tunable structure and registration routines
Message-Id: <20070125083424.7c455d94.randy.dunlap@oracle.com>
In-Reply-To: <45B8DA37.5050502@bull.net>
References: <20070116061516.899460000@bull.net>
	<20070116063028.375290000@bull.net>
	<20070124163218.ec54891d.randy.dunlap@oracle.com>
	<45B8DA37.5050502@bull.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Jan 2007 17:26:31 +0100 Nadia Derbey wrote:

> Randy,
> 
> Thanks for reviewing the code!
> My comments embedded.
> I'll re-send the patches as soon as possible.

OK, thanks.


> Randy Dunlap wrote:
> > On Tue, 16 Jan 2007 07:15:17 +0100 Nadia.Derbey@bull.net wrote:
> > 
> > 
> >>[PATCH 01/06]
> >>
> <snip>
> > 
> > 
> >>+Any kernel subsystem that has registered a tunable should call
> >>+auto_tune_func() as follows:
> >>+
> >>++-------------------------+--------------------------------------------+
> >>+| Step                    | Routine to call                            |
> >>++-------------------------+--------------------------------------------+
> >>+| Declaration phase       | DEFINE_TUNABLE(name, values...);           |
> >>++-------------------------+--------------------------------------------+
> >>+| Initialization routine  | set_tunable_min_max(name, min, max);       |
> >>+|                         | set_autotuning_routine(name, routine);     |
> >>+|                         | register_tunable(&name);                   |
> >>+| Note: the 1st 2 calls   |                                            |
> >>+|       are optional      |                                            |
> >>++-------------------------+--------------------------------------------+
> >>+| Alloc                   | activate_auto_tuning(AKT_UP, &name);       |
> >>++-------------------------+--------------------------------------------+
> >>+| Free                    | activate_auto_tuning(AKT_DOWN, &name);     |
> > 
> > 
> > So does Free always use AKT_DOWN?  why does it matter?
> > Seems unneeded and inconsistent.
> 
> Tuning down is recommended in order to come back to the default tunable 
> value.

Let me try to be clearer.  What is Alloc?  and why is AKT_UP
associated with Alloc and AFK_DOWN associated with Free (whatever
that means)?


> I agree with you: today it has quite no effect, except on the tunable 
> value. If we take the ipc's example, grow_ary() just returns if the new 
> tunable value happens to be lower than the previous one.
> But we can imagine, in the future, that grow_ary could deallocate the 
> unused memory.
> + in that particular case, lowering the tunable value makes the 1st loop 
> in ipc_addid() shorter.
> 
> > How does one activate a tunable for downward adjustment?
> 
> Actually a tunable is activated to be dynamically adjusted (whatever the 
> direction).
> But you are giving me an idea for a future enhancement: we can imagine a 
> tunable that could be allowed to increase only (or decrease only). In 
> that case, we should move the autotune sysfs attribute into an 'up' and 
> a 'down' attribute?

Couldn't the tunable owner just adjust the min value to a new
(larger) min value, e.g.?


> >>+extern void fork_late_init(void);
> > 
> > 
> > Looks like the wrong header file for that extern.
> > 
> > 
> 
> Actually, I wanted the changes to the existing kernel files to be as 
> small as possible. That's why everything is concentrated, whenever 
> possible, in the added files.

I suppose that's OK for review, but it shouldn't be merged that way.

---
~Randy
