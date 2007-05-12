Return-Path: <linux-kernel-owner+w=401wt.eu-S1756655AbXELKBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655AbXELKBy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 06:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755466AbXELKBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 06:01:47 -0400
Received: from viefep13-int.chello.at ([213.46.255.15]:55358 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755327AbXELKBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 06:01:47 -0400
Subject: Re: [PATCH 0/2] convert mmap_sem to a scalable rw_mutex
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Esben Nielsen <nielsen.esben@googlemail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>
In-Reply-To: <Pine.LNX.4.64.0705121120210.26287@frodo.shire>
References: <20070511131541.992688403@chello.nl>
	 <Pine.LNX.4.64.0705121120210.26287@frodo.shire>
Content-Type: text/plain
Date: Sat, 12 May 2007 12:01:43 +0200
Message-Id: <1178964103.6810.55.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-05-12 at 11:27 +0200, Esben Nielsen wrote:
> 
> On Fri, 11 May 2007, Peter Zijlstra wrote:
> 
> >
> > I was toying with a scalable rw_mutex and found that it gives ~10% reduction in
> > system time on ebizzy runs (without the MADV_FREE patch).
> >
> 
> You break priority enheritance on user space futexes! :-(
> The problems is that the futex waiter have to take the mmap_sem. And as 
> your rw_mutex isn't PI enabled you get priority inversions :-(

Do note that rwsems have no PI either.
PI is not a concern for mainline - yet, I do have ideas here though.


