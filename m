Return-Path: <linux-kernel-owner+w=401wt.eu-S1754495AbXKEV5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbXKEV5A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 16:57:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752045AbXKEV4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 16:56:52 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:51327 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887AbXKEV4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 16:56:51 -0500
To: pavel@ucw.cz, torvalds@linux-foundation.org
Cc: darwish.07@gmail.com, casey@schaufler-ca.com, akpm@linux-foundation.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       viro@ftp.linux.org.uk
Subject: Re: [PATCH] Smackv10: Smack rules grammar + their stateful parser
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <472B8DAF.9080706@schaufler-ca.com>
	<20071103164303.GA26707@ubuntu>
	<20071104122848.GC3921@ucw.cz>
	<20071105094007.GA19367@ubuntu>
	<alpine.LFD.0.999.0711050818200.15101@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0711050818200.15101@woody.linux-foundation.org>
Message-Id: <200711060656.ADF87510.tJLVFOHOFSOFMQ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Tue, 6 Nov 2007 06:56:43 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Linus Torvalds wrote:
> I personally think string parsers are *much* better than the alternatives 
> (which basically boil down to nasty binary interfaces)
Me too.

> Binary structures and ioctl's are *much* worse. They are totally 
> undebuggable with generic tools (think "echo" or "strace"), and they are a 
> total nightmare to parse across architectures and pointer sizes.
Not only pointer sizes bugs, but also checking pointer address costs.
For binary policy, we have to examine ->next pointer is valid or not.
We can't blindly use address supplied from userland.

I have encountered mismatch of kernel version and AppArmor's policy parser version
when I just updated only kernel. As a result, the segmentation faults rushed toward me.
 From this experience, TOMOYO still uses string parser in the kernel.
If a parser doesn't consume much stack (i.e. call functions recursively), I think it is no problem.

Thanks.

