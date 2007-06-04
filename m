Return-Path: <linux-kernel-owner+w=401wt.eu-S1755387AbXFDO3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387AbXFDO3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 10:29:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbXFDO25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 10:28:57 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:45401 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774AbXFDO24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 10:28:56 -0400
Date: Mon, 4 Jun 2007 16:28:55 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [patch 1/2] ufd v1 - unsequential O(1) fdmap core
Message-Id: <20070604162855.f98d1698.dada1@cosmosbay.com>
In-Reply-To: <Pine.LNX.4.64.0706040633360.30231@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.24319.1180825145.1>
	<46633047.1020707@cosmosbay.com>
	<Pine.LNX.4.64.0706031536000.13247@alien.or.mcafeemobile.com>
	<20070603230859.5000424d.akpm@linux-foundation.org>
	<20070604080537.GA22898@elte.hu>
	<20070604080941.GA23537@elte.hu>
	<20070604013449.ea3acca8.akpm@linux-foundation.org>
	<20070604122857.1399e3fc.dada1@cosmosbay.com>
	<Pine.LNX.4.64.0706040523150.30231@alien.or.mcafeemobile.com>
	<20070604152540.985c186a.dada1@cosmosbay.com>
	<Pine.LNX.4.64.0706040633360.30231@alien.or.mcafeemobile.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jun 2007 06:35:16 -0700 (PDT)
Davide Libenzi <davidel@xmailserver.org> wrote:

> On Mon, 4 Jun 2007, Eric Dumazet wrote:
> 
> > You add conditional branches on very hot spots.
> 
> Keep BS for the ones you argue usually, and that are not able to reply.
> You *still* two bitmaps, because allocation spaces are far apart. So the 
> "if" will still be there.

I actually read your patches and spent time to see the pros and cons.

If you dont need reviewers, please dont post your patches on lkml.

If I am not mistaken, you added a test in fget()/fget_light(), which is a known hot point for said huge processes.

fget() dont need to access the bitmap at all. Using fd_slots means less (50%) file pointers per cache line.

On my machines, there is a ratio of 100/1 in cpu time for fget(),fget_light() against get_unused_fd().

