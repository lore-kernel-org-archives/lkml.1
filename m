Return-Path: <linux-kernel-owner+w=401wt.eu-S1762886AbXKQEqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762886AbXKQEqU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 23:46:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756765AbXKQEqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 23:46:12 -0500
Received: from pat.uio.no ([129.240.10.15]:36898 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756683AbXKQEqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 23:46:10 -0500
Subject: Re: [TOMOYO #5 02/18] Add wrapper functions for VFShelperfunctions.
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
In-Reply-To: <200711171304.JHD30277.tOHOOJFQSFLFMV@I-love.SAKURA.ne.jp>
References: <20071116173439.796600895@I-love.SAKURA.ne.jp>
	 <20071116173524.195366292@I-love.SAKURA.ne.jp>
	 <1195235255.7653.69.camel@heimdal.trondhjem.org>
	 <200711170320.GCD21875.OSVJFOHtMQFFLO@I-love.SAKURA.ne.jp>
	 <1195237996.7653.86.camel@heimdal.trondhjem.org>
	 <200711171304.JHD30277.tOHOOJFQSFLFMV@I-love.SAKURA.ne.jp>
Content-Type: text/plain
Date: Fri, 16 Nov 2007 23:46:28 -0500
Message-Id: <1195274788.13488.8.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.138)
X-UiO-Scanned: 9828015CE67E43DB040B9A113FCB986854E5B70B
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 159 total 5189351 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-11-17 at 13:04 +0900, Tetsuo Handa wrote:
> Hello.
> 
> Trond Myklebust wrote:
> > The problem is that you have thrown away the main tool for documenting
> > the requirement, and for enforcing correctness (i.e. function argument
> > checking by the compiler).
> I'm sorry. I wanted to know whether the below approach is possible.

"Possible" is completely irrelevant. The question you _should_ be asking
is "is it maintainable".

> > The old functions are still there, are still exported, and still take
> > the same arguments as before, but you have now added a hidden
> > requirement that I have to set last_vfsmount when I call them. If I
> > haven't read your patch, and just call one of those vfs_* functions as
> > before, without setting last_vfsmount, I break your model, and I won't
> > find out until someone reports an obscure bug at runtime.
> I don't care if some kernel module calls vfs_* without setting last_vfsmount
> because there is no reason to reject requests from kernel code.
> Setting last_vfsmount is required for requests from userland process.
> This approach makes it possible to
> (1) tell whether the vfs_* calls are from userland or kernel
> and
> (2) leave kernel modules that are not called from userland unchanged.
> This is why this patch doesn't and needn't to modify fs/*/ files.

I'm confused. How do you tell the difference between a 'userland'
request and a 'kernel' request, and why is the latter safe from a
security perspective?

Trond

