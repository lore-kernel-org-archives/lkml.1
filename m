Return-Path: <linux-kernel-owner+w=401wt.eu-S1945997AbXBBRku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945997AbXBBRku (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 12:40:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945998AbXBBRku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 12:40:50 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:31595 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945997AbXBBRkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 12:40:49 -0500
Subject: Re: 2.6.20-rc6-mm3
From: Daniel Walker <dwalker@mvista.com>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070129204528.eb8d695e.akpm@osdl.org>
References: <20070129204528.eb8d695e.akpm@osdl.org>
Content-Type: text/plain
Date: Fri, 02 Feb 2007 09:39:16 -0800
Message-Id: <1170437956.9781.241.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-01-29 at 20:45 -0800, Andrew Morton wrote:
> Temporarily at
> 
> 	http://userweb.kernel.org/~akpm/2.6.20-rc6-mm3/
> 
> Will appear later at
> 
> 	ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc6/2.6.20-rc6-mm3/
> 

I was running likely profiling and I noticed that when I turn on the
"tickless" option I get the following line, 

+unlikely | 21111208|  9367278  need_resched()@:include/linux/sched.h@1597

This means that this line is 21111208 true, and 9367278 false.

This existed on bootup, and stayed after about 7 hours of runtime
(mostly idle). Since need_resched is a "static inline" there are
multiple instances of need_resched() in the kernel. If I turn off the
"tickless" feature this wrong unlikely disappears, and the output looks
like this,

 unlikely |        0|      169  need_resched()@:include/linux/sched.h@1597
 unlikely |        0|       94  need_resched()@:include/linux/sched.h@1597
 unlikely |        0|       63  need_resched()@:include/linux/sched.h@1597
 unlikely |        0|       19  need_resched()@:include/linux/sched.h@1597
 unlikely |        0|      379  need_resched()@:include/linux/sched.h@1597
 unlikely |        1|   202596  need_resched()@:include/linux/sched.h@1597
 unlikely |        7|   205929  need_resched()@:include/linux/sched.h@1597
 unlikely |     6461|   271690  need_resched()@:include/linux/sched.h@1597

Only a little after boot. I suppose this could be a natural side effect
of the tickless feature but I thought I would report it anyway.

Daniel

