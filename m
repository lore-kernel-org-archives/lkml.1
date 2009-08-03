Return-Path: <linux-kernel-owner+w=401wt.eu-S1754587AbZHCJM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587AbZHCJM1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 05:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754494AbZHCJM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 05:12:26 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56148 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178AbZHCJMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 05:12:25 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 3 Aug 2009 18:10:40 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Cc: Mike Smith <scgtrp@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
       bugzilla-daemon@bugzilla.kernel.org, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [BUGFIX][PATCH 1/3] fix vread/vwrite to be aware of memory hole
Message-Id: <20090803181040.7c7cffbe.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090803091019.GC6016@cr0.nay.redhat.com>
References: <bug-13850-10286@http.bugzilla.kernel.org/>
	<20090728160527.1da52682.akpm@linux-foundation.org>
	<20090729084825.1363c880.kamezawa.hiroyu@jp.fujitsu.com>
	<525c5a6c0907281946t249ef288v77ee94edd16f054@mail.gmail.com>
	<20090729123209.690baa48.kamezawa.hiroyu@jp.fujitsu.com>
	<20090731160748.279845da.kamezawa.hiroyu@jp.fujitsu.com>
	<20090731161128.347216e6.kamezawa.hiroyu@jp.fujitsu.com>
	<20090731095705.GD5048@cr0.nay.redhat.com>
	<65d1a0e3dc0e5fa357f392f0552b4519.squirrel@webmail-b.css.fujitsu.com>
	<20090803091019.GC6016@cr0.nay.redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Aug 2009 17:10:19 +0800
Amerigo Wang <xiyou.wangcong@gmail.com> wrote:

> On Fri, Jul 31, 2009 at 07:32:15PM +0900, KAMEZAWA Hiroyuki wrote:
> >Amerigo Wang さんは書きました：
> >> On Fri, Jul 31, 2009 at 04:11:28PM +0900, KAMEZAWA Hiroyuki wrote:
> >>>From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> >>>
> >>>vread/vwrite access vmalloc area without checking there is a page or not.
> >>>
> >>>In old ages, the caller of get_vm_ara() is only IOREMAP and there is no
> >>>memory hole within vm_struct's [addr...addr + size - PAGE_SIZE]
> >>>( -PAGE_SIZE is for a guard page.)
> >>>
> >>>After per-cpu-alloc patch, it uses get_vm_area() for reserve continuous
> >>>virtual address but remap _later_. There tend to be a hole in valid
> >>> vmalloc
> >>>area in vm_struct lists.
> >>>Then, skip the hole (not mapped page) is necessary.
> >>>This patch updates vread/vwrite() for avoiding memory hole.
> >>>
> >>>Routines which access vmalloc area without knowing for which addr is used
> >>>are
> >>>  - /proc/kcore
> >>>  - /dev/kmem
> >>>
> >>>kcore checks IOREMAP, /dev/kmem doesn't. After this patch, IOREMAP is
> >>>checked and /dev/kmem will avoid to read/write it.
> >>>Fixes to /proc/kcore will be in the next patch in series.
> >>>
> >>>And, this itself fixes the bug as
> >>># dd if=/dev/kmem of=/dev/null bs=1024 count=1048576 skip=3145728
> >>>can cause panic.
> >>
> >>
> >> What panic? :-) Would you mind to put it here?
> >>
> >It directly reboot ;( and no log.
> >plz try.
> 
> 
> I tried it on an x86_64 machine, no panic, just:
> 
>  dd: reading `/dev/kmem': Bad address
> 
> Only appears on i386? :)
> 
I tested on i386/2cpu server.

Thanks,
-Kame

