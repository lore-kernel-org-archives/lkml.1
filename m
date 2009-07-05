Return-Path: <linux-kernel-owner+w=401wt.eu-S1756554AbZGEOUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554AbZGEOUa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 10:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754169AbZGEOUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 10:20:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59842 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753697AbZGEOUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 10:20:17 -0400
Date: Sun, 5 Jul 2009 07:19:33 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Wu Zhangjin <wuzhangjin@gmail.com>
cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org, Krzysztof Helt <krzysztof.h1@wp.pl>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ralf Baechle <ralf@linux-mips.org>,
       =?GB2312?B?6sy7qg==?= <yanh@lemote.com>, zhangfx <zhangfx@lemote.com>
Subject: Re: [BUG] drivers/video/sis: deadlock introduced by "fbdev: add
 mutex for fb_mmap locking"
In-Reply-To: <1246785112.14240.34.camel@falcon>
Message-ID: <alpine.LFD.2.01.0907050715490.3210@localhost.localdomain>
References: <1246785112.14240.34.camel@falcon>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 5 Jul 2009, Wu Zhangjin wrote:
> 
> then it works! so, I guess there is a deadlock introduced by the above
> commit.

Hmm. Perhaps more likely, the 'mm_lock' mutex hasn't even been initialized 
yet.  We appear to have had that problem with matroxfb and sm501fb, and it 
may be more common than that. See commit f50bf2b2.

That said, I do agree that the mm_lock seems to be causing more problems 
than it actually fixes, and maybe we should revert it. Krzysztof?

		Linus
