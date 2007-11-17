Return-Path: <linux-kernel-owner+w=401wt.eu-S1760939AbXKQEET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760939AbXKQEET (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 23:04:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756221AbXKQEEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 23:04:08 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:65425 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756041AbXKQEEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 23:04:07 -0500
To: trond.myklebust@fys.uio.no
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [TOMOYO #5 02/18] Add wrapper functions for VFShelperfunctions.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20071116173439.796600895@I-love.SAKURA.ne.jp>
	<20071116173524.195366292@I-love.SAKURA.ne.jp>
	<1195235255.7653.69.camel@heimdal.trondhjem.org>
	<200711170320.GCD21875.OSVJFOHtMQFFLO@I-love.SAKURA.ne.jp>
	<1195237996.7653.86.camel@heimdal.trondhjem.org>
In-Reply-To: <1195237996.7653.86.camel@heimdal.trondhjem.org>
Message-Id: <200711171304.JHD30277.tOHOOJFQSFLFMV@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sat, 17 Nov 2007 13:04:02 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Trond Myklebust wrote:
> The problem is that you have thrown away the main tool for documenting
> the requirement, and for enforcing correctness (i.e. function argument
> checking by the compiler).
I'm sorry. I wanted to know whether the below approach is possible.

> The old functions are still there, are still exported, and still take
> the same arguments as before, but you have now added a hidden
> requirement that I have to set last_vfsmount when I call them. If I
> haven't read your patch, and just call one of those vfs_* functions as
> before, without setting last_vfsmount, I break your model, and I won't
> find out until someone reports an obscure bug at runtime.
I don't care if some kernel module calls vfs_* without setting last_vfsmount
because there is no reason to reject requests from kernel code.
Setting last_vfsmount is required for requests from userland process.
This approach makes it possible to
(1) tell whether the vfs_* calls are from userland or kernel
and
(2) leave kernel modules that are not called from userland unchanged.
This is why this patch doesn't and needn't to modify fs/*/ files.

Thanks.

