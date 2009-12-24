Return-Path: <linux-kernel-owner+w=401wt.eu-S1756035AbZLXReZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035AbZLXReZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 12:34:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755693AbZLXReY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 12:34:24 -0500
Received: from xenotime.net ([72.52.64.118]:58932 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752771AbZLXReX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 12:34:23 -0500
Date: Thu, 24 Dec 2009 09:34:16 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: BuraphaLinux Server <buraphalinuxserver@gmail.com>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: strange stuff in dmesg
Message-Id: <20091224093416.019a350f.rdunlap@xenotime.net>
In-Reply-To: <5d75f4610912240722i7b282289id013b85f3d4927cd@mail.gmail.com>
References: <5d75f4610912240203x61a45505s213f29809824a854@mail.gmail.com>
	<4B333EAD.1000202@gmail.com>
	<5d75f4610912240722i7b282289id013b85f3d4927cd@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Dec 2009 22:22:41 +0700 BuraphaLinux Server wrote:

> On 12/24/09, Justin P. Mattock <justinmattock@gmail.com> wrote:
> > On 12/24/09 02:03, BuraphaLinux Server wrote:
> >> On my Dell OptiPlex 330 machines with kernel 2.6.32.2 I get a strange
> >> WARNING.  Do I need to worry?  Here is the warning:
> >>
> >> [    0.000000] ------------[ cut here ]------------
> >> [    0.000000] WARNING: at mm/page_alloc.c:1805
> >> __alloc_pages_nodemask+0x1b6/0x730()
> >> [    0.000000] Hardware name: OptiPlex 330
> >> [    0.000000] Modules linked in:
> >> [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.32.2 #1
> >> [    0.000000] Call Trace:
> >> [    0.000000]  [<ffffffff8108e806>] ? __alloc_pages_nodemask+0x1b6/0x730
> >> [    0.000000]  [<ffffffff81043f68>] warn_slowpath_common+0x78/0xd0
> >> [    0.000000]  [<ffffffff81043fcf>] warn_slowpath_null+0xf/0x20
> >> [    0.000000]  [<ffffffff8108e806>] __alloc_pages_nodemask+0x1b6/0x730
> >> [    0.000000]  [<ffffffff810b4e28>] alloc_pages_current+0x78/0xf0
> >> [    0.000000]  [<ffffffff8108da69>] __get_free_pages+0x9/0x50
> >> [    0.000000]  [<ffffffff810bb912>] __kmalloc+0x112/0x120
> >> [    0.000000]  [<ffffffff8146e773>] vgacon_scrollback_startup+0x13/0x70
> >> [    0.000000]  [<ffffffff811d29b3>] vgacon_startup+0x2a3/0x420
> >> [    0.000000]  [<ffffffff816fc556>] con_init+0x1b/0x230
> >> [    0.000000]  [<ffffffff816fba00>] console_init+0x22/0x42
> >> [    0.000000]  [<ffffffff816d4b8f>] start_kernel+0x240/0x3be
> >> [    0.000000]  [<ffffffff816d4289>] x86_64_start_reservations+0x99/0xb9
> >> [    0.000000]  [<ffffffff816d4389>] x86_64_start_kernel+0xe0/0xf2
> >> [    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---
> >>
> >> I also got it on 2.6.31.9, but had waited to ask hoping 2.6.32.2 would fix
> >> it.
> >>
> >> Attached is my config
> >>
> > was there a kernel that did not do this?
> > if so can you try a bisect on this?
> >
> > Justin P. Mattock
> >
> 
> It took a while, but I have verified that 2.6.30.10 works without any
> message, and 2.6.31 has the error message (but otherwise seems to run
> ok).  The hex codes are different, but the function names match and
> are in the same places.
> 
> Does it have to be git bisect, or will trying the 2.6.31rc[1-9] be
> enough instead?  The Documentation/BUG-HUNTING does not give detailed
> enough instructions for me to do the bisect thing.

"git bisect" can point directly at the kernel patch that causes the
problem (well, most of the time it can do that), whereas just saying
2.6.31-rc[1-9] will just tell us that it was one of a few thousand
patches.  Not nearly as helpful.

Maybe this can help you:
http://www.kernel.org/pub/software/scm/git-core/docs/git-bisect-lk2009.html


---
~Randy
