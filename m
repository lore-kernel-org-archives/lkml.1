Return-Path: <linux-kernel-owner+w=401wt.eu-S1758844AbYCBUAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758844AbYCBUAj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 15:00:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754580AbYCBUAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 15:00:30 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33955 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbYCBUAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 15:00:30 -0500
Date: Sun, 2 Mar 2008 12:00:10 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc: complete lockup on boot/start of X (bisected)
Message-ID: <20080302120010.79d19405@laptopd505.fenrus.org>
In-Reply-To: <20080302185935.GA6100@joi>
References: <20080302185935.GA6100@joi>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Mar 2008 20:00:05 +0100
Marcin Slusarz <marcin.slusarz@gmail.com> wrote:

> Hi
> Since early 2.6.25 days I'm having strange lockup on boot. As it
> happens rarely (in ~10% of boots), I couldn't bisect it. No kernel
> panic, SysRq didn't work, so I couldn't provide any useful
> informations to LK community. I hoped someone else would fix it... :)
> 
> It's rc3 so I decided to narrow it down myself. I enabled netconsole 
> to see whether some other informations are printed before lockup.
> It didn't help, but I noticed that lockup happens much more
> frequenly! (~50%) So I bisected it down to:
> 
> 8f4d37ec073c17e2d4aa8851df5837d798606d6f is first bad commit
> commit 8f4d37ec073c17e2d4aa8851df5837d798606d6f
> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date:   Fri Jan 25 21:08:29 2008 +0100
> 
>     sched: high-res preemption tick
> 
>     Use HR-timers (when available) to deliver an accurate preemption
> tick.


the only unusual/suspect thing you have is nvidiafb driver; that's not very commonly used.
Can you do a quick try with that thing disabled? Maybe it has some races that are more likely
to trigger after this patch...


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
