Return-Path: <linux-kernel-owner+w=401wt.eu-S1752869AbXKQFYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbXKQFYR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 00:24:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750992AbXKQFYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 00:24:04 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:53816 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794AbXKQFYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 00:24:01 -0500
To: trond.myklebust@fys.uio.no
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [TOMOYO #5 02/18] Add wrapper functions for VFShelperfunctions.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1195235255.7653.69.camel@heimdal.trondhjem.org>
	<200711170320.GCD21875.OSVJFOHtMQFFLO@I-love.SAKURA.ne.jp>
	<1195237996.7653.86.camel@heimdal.trondhjem.org>
	<200711171304.JHD30277.tOHOOJFQSFLFMV@I-love.SAKURA.ne.jp>
	<1195274788.13488.8.camel@heimdal.trondhjem.org>
In-Reply-To: <1195274788.13488.8.camel@heimdal.trondhjem.org>
Message-Id: <200711171423.GGC65617.HLJQtFSFOVOMFO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sat, 17 Nov 2007 14:23:56 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Trond Myklebust wrote:
> I'm confused. How do you tell the difference between a 'userland'
> request and a 'kernel' request, and why is the latter safe from a
> security perspective?
For example, if userland process wants to create a directory,
it will call mkdir(2).
In the kernel, mkdir(2) is mapped to sys_mkdir(),
sys_mkdir() calls sys_mkdirat(),
sys_mkdirat() calls vfs_mkdir().

Therefore, there is a chance to tell whether
vfs_mkdir() is triggered by userland process's request.
Some kernel code *might* call sys_mkdir() too.
But at least I think I can hook all requests
triggered by userland process's request
because routes to call vfs_mkdir() from userland is not infinite.

We are regarding the kernel code as trusted.
For example, no security checks for code that are called by only kernel.
http://www.mail-archive.com/linux-security-module@vger.kernel.org/msg01830.html

Regards.

