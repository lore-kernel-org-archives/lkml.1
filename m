Return-Path: <linux-kernel-owner+w=401wt.eu-S932444AbYD1IGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932444AbYD1IGh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 04:06:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765599AbYD1IG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 04:06:29 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:49739 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763964AbYD1IG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 04:06:29 -0400
Date: Mon, 28 Apr 2008 17:06:27 +0900 (JST)
Message-Id: <20080428.170627.59682428.ryov@valinux.co.jp>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, agk@sourceware.org, sergk@sergk.org.ua
Subject: Re: [PATCH 2/2] dm-ioband: I/O bandwidth controller v0.0.4:
 Document
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20080426114535.e19283be.akpm@linux-foundation.org>
References: <20080424.201857.183035295.ryov@valinux.co.jp>
	<20080424.202219.59667073.ryov@valinux.co.jp>
	<20080426114535.e19283be.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Most writes are performed by pdflush, kswapd, etc.  This will lead to large
> inaccuracy.
>
> It isn't trivial to fix.  We'd need deep, long tracking of ownership
> probably all the way up to the pagecache page.  The same infrastructure
> would be needed to make Sergey's "BSD acct: disk I/O accounting" vaguely
> accurate.  Other proposals need it, but I forget what they are.

I also realize that some kernel threads such as pdflush perform actual
writes instead of tasks which originally issued write requests.
So, taka is developing a blocking I/O tacking down mechanism which is
based on cgroup memory controller and posted it to LKML:
http://lwn.net/Articles/273802/

However, the current implementation works well with Xen virtual
machines, because virtual machine's I/Os are issued from its own kernel
thread and can be tracked down. Please see a benchmark result of Xen
virtual machine:
http://people.valinux.co.jp/~ryov/dm-ioband/benchmark/xen-blktap.html

As for KVM, dm-ioband was also able to track down block I/Os as I
expected. When dm-ioband is used in virtual machine environment,
I think even the current implementation will work fairly.

But unfortunately I found KVM still had a performance problem that
it couldn't handle I/Os efficiently yet, which should be improved.
I already posted this problem to kvm-devel list:
http://sourceforge.net/mailarchive/forum.php?thread_name=20080229.210531.226799765.ryov%40valinux.co.jp&forum_name=kvm-devel
 
> Much more minor points: when merge-time comes, the patches should have the
> LINUX_VERSION_CODE stuff removed.  And probably all of the many `inline's
> should be removed.

Thank you for your advice. I'll have these fixes included in the next
release.

Ryo Tsuruta
