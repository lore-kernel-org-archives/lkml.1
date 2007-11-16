Return-Path: <linux-kernel-owner+w=401wt.eu-S1765647AbXKPSdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765647AbXKPSdY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 13:33:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757210AbXKPSdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 13:33:16 -0500
Received: from pat.uio.no ([129.240.10.15]:44063 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525AbXKPSdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 13:33:14 -0500
Subject: Re: [TOMOYO #5 02/18] Add wrapper functions for VFS
	helperfunctions.
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
In-Reply-To: <200711170320.GCD21875.OSVJFOHtMQFFLO@I-love.SAKURA.ne.jp>
References: <20071116173439.796600895@I-love.SAKURA.ne.jp>
	 <20071116173524.195366292@I-love.SAKURA.ne.jp>
	 <1195235255.7653.69.camel@heimdal.trondhjem.org>
	 <200711170320.GCD21875.OSVJFOHtMQFFLO@I-love.SAKURA.ne.jp>
Content-Type: text/plain
Date: Fri, 16 Nov 2007 13:33:16 -0500
Message-Id: <1195237996.7653.86.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.140)
X-UiO-Scanned: 3D2217E9E65158758EC73271440202CAF33EC403
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 306 total 5185589 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-11-17 at 03:20 +0900, Tetsuo Handa wrote:
> Hello.
> 
> Trond Myklebust wrote:
> > > This patch allows LSM hooks refer previously associated "struct vfsmount" parameter
> > > so that they can calculate pathname of given "struct dentry".
> > 
> > NACK to this. Passing function parameters through the task_struct is
> > definitely not an acceptable hack (unless you're doing it through the
> > stack).
> 
> Thanks for your advise.
> But I don't know why it is not acceptable.
> The topmost vfsmount's address is retrievable through the task_struct,
> and non-topmost vfsmount's address (if any) are stored on the stack memory.
> Could you show me why this is bad?

The problem is that you have thrown away the main tool for documenting
the requirement, and for enforcing correctness (i.e. function argument
checking by the compiler).
The old functions are still there, are still exported, and still take
the same arguments as before, but you have now added a hidden
requirement that I have to set last_vfsmount when I call them. If I
haven't read your patch, and just call one of those vfs_* functions as
before, without setting last_vfsmount, I break your model, and I won't
find out until someone reports an obscure bug at runtime.

Trond

