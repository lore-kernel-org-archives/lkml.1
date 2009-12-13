Return-Path: <linux-kernel-owner+w=401wt.eu-S1752049AbZLMRrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049AbZLMRrG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 12:47:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751180AbZLMRrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 12:47:05 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48106 "HELO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751161AbZLMRrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 12:47:03 -0500
Date: Sun, 13 Dec 2009 09:46:26 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Thomas Gleixner <tglx@linutronix.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] TTY patches for 2.6.33-git
In-Reply-To: <20091213065844.GA20244@elte.hu>
Message-ID: <alpine.LFD.2.00.0912130941050.5516@localhost.localdomain>
References: <20091212084611.GA28266@elte.hu> <20091212013927.58d386d1.akpm@linux-foundation.org> <20091212101032.GB25286@elte.hu> <20091212023603.93768833.akpm@linux-foundation.org> <alpine.LFD.2.00.0912120915390.3526@localhost.localdomain>
 <alpine.LFD.2.00.0912120920190.3526@localhost.localdomain> <20091212214235.31429790@lxorguk.ukuu.org.uk> <alpine.LFD.2.00.0912121418490.3526@localhost.localdomain> <alpine.LFD.2.00.0912122331200.3089@localhost.localdomain> <alpine.LFD.2.00.0912121513190.3535@localhost.localdomain>
 <20091213065844.GA20244@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 13 Dec 2009, Ingo Molnar wrote:
> 
> In the last ~4.5 years:
> 
>  earth4:~/tip> git checkout v2.6.12
>  Date:   Fri Jun 17 12:48:29 2005 -0700
>  earth4:~/tip> git grep -w unlock_kernel | wc -l
>  713
> 
>  earth4:~/tip> git checkout linus
>  Date:   Fri Dec 11 20:58:20 2009 -0800
>  earth4:~/tip> git grep -w unlock_kernel | wc -l
>  841

Git hint of the day: you don't need to check out a kernel to do "git 
grep".

Do this:

	git grep -w unlock_kernel v2.6.12 | wc

and it will JustWork(tm).

> Also, a lot of BKL use was hidden before, and due to the BKL removal 
> activities (by Thomas, Frederic, Jon, Alan and others) the remaining BKL using 
> sites are a lot more well defined, a lot more isolated and thus a lot more 
> removable than ever before.

That's the main thing. We've been pushing them down a lot.

We still have a few annoying core ones, though. I hate the execve() and 
file locking ones.

			Linus
