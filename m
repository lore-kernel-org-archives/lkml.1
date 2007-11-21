Return-Path: <linux-kernel-owner+w=401wt.eu-S1760360AbXKUItX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760360AbXKUItX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 03:49:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754819AbXKUItP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 03:49:15 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50576 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752957AbXKUItO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 03:49:14 -0500
Date: Wed, 21 Nov 2007 00:49:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc3-mm1 (sync is slow ?)
Message-Id: <20071121004909.6157bb9a.akpm@linux-foundation.org>
In-Reply-To: <20071121174215.caff4551.kamezawa.hiroyu@jp.fujitsu.com>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>
	<20071121174215.caff4551.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Nov 2007 17:42:15 +0900 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> Hi, Andrew
> 
> I got following result in 'sync' command.
> It was too slow. (memory controller config is off ;)
> I attaches my .config.
> ==
> [2.6.24-rc3-mm1]
> [kamezawa@dr-test2 ~]$ dd if=/dev/zero of=./tmpfile bs=4096 count=100000
> 100000+0 records in
> 100000+0 records out
> 409600000 bytes (410 MB) copied, 1.46706 seconds, 279 MB/s
> [kamezawa@dr-test2 ~]$ time sync
> 
> real    3m6.440s
> user    0m0.000s
> sys     0m0.133s
> 
> 
> on, 2.6.23-rc2-mm1, 2.6.23-rc3 there was no problem.
> ==
> [2.6.24-rc3]
> [kamezawa@dr-test2 ~]$ dd if=/dev/zero of=tmpfile bs=4096 count=100000
> 100000+0 records in
> 100000+0 records out
> 409600000 bytes (410 MB) copied, 2.07717 seconds, 197 MB/s
> [kamezawa@dr-test2 ~]$ time sync
> 
> real    0m9.935s
> user    0m0.001s
> sys     0m0.113s
> 
> [2.6.24-rc3]
> [kamezawa@dr-test2 ~]$ dd if=/dev/zero of=./tmpfile bs=4096 count=100000
> 100000+0 records in
> 100000+0 records out
> 409600000 bytes (410 MB) copied, 1.37147 seconds, 299 MB/s
> [kamezawa@dr-test2 ~]$ time sync[2.6.24-rc2-mm1]
> 
> 
> real    0m11.718s
> user    0m0.000s
> sys     0m0.138s

Well I wonder how we did that.

It seems OK here from a quick test (i386, ext3-on-IDE).

Maybe device driver/block breakage?
