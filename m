Return-Path: <linux-kernel-owner+w=401wt.eu-S1755685AbZDKGC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685AbZDKGC3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 02:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754655AbZDKGCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 02:02:19 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:49232 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470AbZDKGCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 02:02:18 -0400
Date: Sat, 11 Apr 2009 08:04:15 +0200
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: Andrea Righi <righi.andrea@gmail.com>
Cc: Eric Miao <eric.y.miao@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrey Borzenkov <arvidjaar@gmail.com>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       linux-fbdev-devel@lists.sourceforge.net,
       linux-pm@lists.linux-foundation.org, Dave Jones <davej@redhat.com>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [REGRESSION] commit 66c1ca0: {fbmem: fix fb_info->lock and
 mm->mmap_sem ...} causes Xfbdev not working
Message-Id: <20090411080415.7fe924a2.krzysztof.h1@poczta.fm>
In-Reply-To: <20090410220521.GB21294@linux>
References: <f17812d70904090436kd03744brca4a4bc4b85bba8@mail.gmail.com>
	<20090409125850.GA2727@linux>
	<20090410222122.87be60f6.krzysztof.h1@poczta.fm>
	<20090410220521.GB21294@linux>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-EMID: 14e2b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Apr 2009 00:05:22 +0200
Andrea Righi <righi.andrea@gmail.com> wrote:

> 
> mmmh... I may have missed something, but the common fb_mmap() should
> acquire mm->mmap_sem and then info->lock, while fb_ioctl() can do that
> in reverse order (info->lock first and then mm->mmap_sem) causing the
> circular locking dependency. Are you sure that pushing info->lock down
> each driver's fb_mmap will fix the problem?

Right. The fb_mmap is called with the mmap_sem already held.
I will try other possibilities like breaking info->lock() into two
mutexex.

Something should be done to solve this problem.

Best regards,
Krzysztof

----------------------------------------------------------------------
Oblej swoich znajomych... wirtualnie! ;)
http://link.interia.pl/f2119

