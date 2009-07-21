Return-Path: <linux-kernel-owner+w=401wt.eu-S1754410AbZGUCLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410AbZGUCLb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 22:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752937AbZGUCL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 22:11:29 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:57325 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795AbZGUCL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 22:11:29 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 21 Jul 2009 11:09:24 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: ebiederm@xmission.com, xiyou.wangcong@gmail.com, tao.ma@oracle.com,
       linux-kernel@vger.kernel.org, adobriyan@gmail.com,
       mtk.manpages@gmail.com, y-goto@jp.fujitsu.com
Subject: Re: [RESEND Patch] kcore: remove its pointless size
Message-Id: <20090721110924.39a93078.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090717152955.6585cbf9.akpm@linux-foundation.org>
References: <m11vpqvozl.fsf@fess.ebiederm.org>
	<20090613040958.GA2959@cr0>
	<m17hzdhkr8.fsf@fess.ebiederm.org>
	<2375c9f90906160829g3d605836yb4c5b9beeac50c5f@mail.gmail.com>
	<m1my88568n.fsf@fess.ebiederm.org>
	<20090618030051.GA6133@cr0.nay.redhat.com>
	<m1tz2ei54r.fsf@fess.ebiederm.org>
	<20090618044055.GB6133@cr0.nay.redhat.com>
	<m1prd2rtdf.fsf@fess.ebiederm.org>
	<20090622085405.GA6499@cr0.nay.redhat.com>
	<20090630100850.GD5873@cr0.nay.redhat.com>
	<20090701144742.6ce3535b.akpm@linux-foundation.org>
	<m14otwq94e.fsf@fess.ebiederm.org>
	<20090701171249.004968e8.akpm@linux-foundation.org>
	<20090702094138.f86ead92.kamezawa.hiroyu@jp.fujitsu.com>
	<20090717152955.6585cbf9.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jul 2009 15:29:55 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 2 Jul 2009 09:41:38 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> I think I'm about to forget about the above issues.  If everyone else
> does the same, they won't get addressed.  Oh well.
> 
> And I still need to decide whether
> kcore-fix-proc-kcores-statst_size.patch fixes things up sufficiently
> well to justify merging it.
>

Hmm, I read fs/proc/kcore.c and feel followng, now.

- kclist doesn't handle memory hole, then, it will never be "correct" size.
  For example, arch/x86/mm/init.c calls kclist_add() as following

  715         kclist_add(&kcore_vmalloc, (void *)VMALLOC_START,
  716                    VMALLOC_END-VMALLOC_START);

  Wow, extremely big anyway.

- Then, yes. Size of /proc/kcode is pointless. Anyway, what's important is
  not "size", but ELF phder of kcore.

To this patch,
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

BTW, I'd like to look into handling physical memory range for /proc/kcore.
IMHO, kclist for physical memory is not necessary...it's handled by /proc/iomem.
"kdump" uses this information and it's properly maintained by memory hotplug.
I'd like to try some pathces and make kclist_add() for physical memory cleaner,
later.

Thanks,
-Kame







