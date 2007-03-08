Return-Path: <linux-kernel-owner+w=401wt.eu-S1030341AbXCHJAd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030341AbXCHJAd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 04:00:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030346AbXCHJAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 04:00:32 -0500
Received: from smtp.osdl.org ([65.172.181.24]:59164 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030341AbXCHJAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 04:00:31 -0500
Date: Thu, 8 Mar 2007 01:00:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Cc: linux-kernel@vger.kernel.org, GLarson@analogic.com
Subject: Re: Kernel threads
Message-Id: <20070308010023.7d19f420.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.61.0703061101390.4403@chaos.analogic.com>
References: <Pine.LNX.4.61.0703061101390.4403@chaos.analogic.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 6 Mar 2007 11:03:48 -0500 "linux-os \(Dick Johnson\)" <linux-os@analogic.com> wrote:
> 
> Hello,
> 
> In linux-2.6.16.24, there is a problem with kernel threads
> and the aic79xx.c driver.
> 
> When nash is executing /initrd/linuxrc in the initial RAM disk
> during boot, it will be installing drivers. One driver, aic79xx.c
> creates some kernel threads that will exit after the initialization
> procedure. Actually the number of tasks depends upon the number
> of disks found as the driver spawns these tasks so initialization
> can occur in the background. The kernel tasks have been 'parented'
> to init. This may be fine for the real init, but nash and other
> shells receive the SIGCHLD signal and think that the fork()/exec()
> they have executed is complete. This makes nash insert drivers
> when the needed previous ones have not yet initialized. Also, when
> booting a shell, the signals from the exiting kernel tasks confuse
> it.
> 
> I think the top-level thread, kthread, should be reaping children
> instead of init, which in some cases isn't even running yet.
> 
> Any comments?
> 
> The current work-around of putting `sleep 10` in linuxrc after
> installing each driver is a hack of the worse kind. Especially,
> considering an Adaptec controller with many drives attached may
> require 'sleep 60'!
> 

ug.  I've always disliked the kernel's dependence upon init to reap exitted
kernel threads.  It Just Seems Wrong.

But I'd have thought that this is really wart in nash - Linux simply
expects init to reap dead kernel threads, and as a Linux implementation of
init, nash ought to not misbehave in the presence of this logstanding
kernel behaviour.


