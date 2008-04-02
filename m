Return-Path: <linux-kernel-owner+w=401wt.eu-S1750939AbYDBHbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750939AbYDBHbU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 03:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751404AbYDBHbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 03:31:11 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50204 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbYDBHbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 03:31:09 -0400
Date: Wed, 02 Apr 2008 16:31:27 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Tom May" <tom@tommay.com>
Subject: Re: [PATCH 0/8][for -mm] mem_notify v6
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <ab3f9b940804011635g2de833d0l44558f78a1cce1e5@mail.gmail.com>
References: <2f11576a0802090719i3c08a41aj38504e854edbfeac@mail.gmail.com> <ab3f9b940804011635g2de833d0l44558f78a1cce1e5@mail.gmail.com>
Message-Id: <20080402154910.9588.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tom,

Thank you very useful comment.
that is very interesting.

> I tried it with a real-world program that, among other things, mmaps
> anonymous pages and touches them at a reasonable speed until it gets
> notified via /dev/mem_notify, releases most of them with
> madvise(MADV_DONTNEED), then loops to start the cycle again.
>
> What tends to happen is that I do indeed get notifications via
> /dev/mem_notify when the kernel would like to be swapping, at which
> point I free memory.  But the notifications come at a time when the
> kernel needs memory, and it gets the memory by discarding some Cached
> or Mapped memory (I can see these decreasing in /proc/meminfo with
> each notification).  With each mmap/notify/madvise cycle the Cached
> and Mapped memory gets smaller, until eventually while I'm touching
> pages the kernel can't find enough memory and will either invoke the
> OOM killer or return ENOMEM from syscalls.  This is precisely the
> situation I'm trying to avoid by using /dev/mem_notify.

Could you send your test program?
I can't reproduce that now, sorry.


> The criterion of "notify when the kernel would like to swap" feels
> correct, but in addition I seem to need something like "notify when
> cached+mapped+free memory is getting low".

Hmmm,
I think this idea is only useful when userland process call 
madvise(MADV_DONTNEED) periodically.

but I hope improve my patch and solve your problem.
if you don' mind, please help my testing ;)



