Return-Path: <linux-kernel-owner+w=401wt.eu-S1761105AbYDZSr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761105AbYDZSr0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 14:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759189AbYDZSrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 14:47:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46576 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759172AbYDZSrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 14:47:14 -0400
Date: Sat, 26 Apr 2008 11:45:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, agk@sourceware.org,
       Sergey Kononenko <sergk@sergk.org.ua>
Subject: Re: [PATCH 2/2] dm-ioband: I/O bandwidth controller v0.0.4:
 Document
Message-Id: <20080426114535.e19283be.akpm@linux-foundation.org>
In-Reply-To: <20080424.202219.59667073.ryov@valinux.co.jp>
References: <20080424.201857.183035295.ryov@valinux.co.jp>
	<20080424.202219.59667073.ryov@valinux.co.jp>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Apr 2008 20:22:19 +0900 (JST) Ryo Tsuruta <ryov@valinux.co.jp> wrote:

> +What's dm-ioband all about?
> +
> +     dm-ioband is an I/O bandwidth controller implemented as a device-mapper
> +   driver. Several jobs using the same physical device have to share the
> +   bandwidth of the device. dm-ioband gives bandwidth to each job according
> +   to its weight, which each job can set its own value to.
> +
> +     At this time, a job is a group of processes with the same pid or pgrp or
> +   uid. There is also a plan to make it support cgroup. A job can also be a
> +   virtual machine such as KVM or Xen.

Most writes are performed by pdflush, kswapd, etc.  This will lead to large
inaccuracy.

It isn't trivial to fix.  We'd need deep, long tracking of ownership
probably all the way up to the pagecache page.  The same infrastructure
would be needed to make Sergey's "BSD acct: disk I/O accounting" vaguely
accurate.  Other proposals need it, but I forget what they are.

Much more minor points: when merge-time comes, the patches should have the
LINUX_VERSION_CODE stuff removed.  And probably all of the many `inline's
should be removed.


