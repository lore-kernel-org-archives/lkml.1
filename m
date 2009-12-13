Return-Path: <linux-kernel-owner+w=401wt.eu-S1752573AbZLMLfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbZLMLfH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 06:35:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752516AbZLMLfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 06:35:06 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44039 "HELO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1751918AbZLMLfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 06:35:05 -0500
Date: Sun, 13 Dec 2009 11:36:26 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] TTY patches for 2.6.33-git
Message-ID: <20091213113626.7a854941@lxorguk.ukuu.org.uk>
In-Reply-To: <20091213065844.GA20244@elte.hu>
References: <20091212084611.GA28266@elte.hu>
	<20091212013927.58d386d1.akpm@linux-foundation.org>
	<20091212101032.GB25286@elte.hu>
	<20091212023603.93768833.akpm@linux-foundation.org>
	<alpine.LFD.2.00.0912120915390.3526@localhost.localdomain>
	<alpine.LFD.2.00.0912120920190.3526@localhost.localdomain>
	<20091212214235.31429790@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.00.0912121418490.3526@localhost.localdomain>
	<alpine.LFD.2.00.0912122331200.3089@localhost.localdomain>
	<alpine.LFD.2.00.0912121513190.3535@localhost.localdomain>
	<20091213065844.GA20244@elte.hu>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  earth4:~/tip> git checkout linus
>  Date:   Fri Dec 11 20:58:20 2009 -0800
>  earth4:~/tip> git grep -w unlock_kernel | wc -l
>  841
> 
> we grew the (absolute) number of BKL sites by ~15%. Certainly the kernel grew 
> at a much faster rate, so the relative proportion of the BKL shrunk.

Thats actually very misleading. The reason is we have created more
lock/unlock points as we remove and drive down the lock.

By your metric the original SMP kernel was best - it had one of each 8)
	
> Also, a lot of BKL use was hidden before, and due to the BKL removal 
> activities (by Thomas, Frederic, Jon, Alan and others) the remaining BKL using 
> sites are a lot more well defined, a lot more isolated and thus a lot more 
> removable than ever before.

ioctl is almost done and I've gont some other random ones in my tree.
lseek is close. At that point most of the nasties are squashed except tty.

We do have some remaining locking horrors some partly introduced by the
finer locking work in the past including the rather nasty device
unload/load v open file handle races.

