Return-Path: <linux-kernel-owner+w=401wt.eu-S1756725AbXKFKBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725AbXKFKBP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 05:01:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754666AbXKFKBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 05:01:00 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:59315 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752024AbXKFKA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 05:00:59 -0500
Date: Tue, 6 Nov 2007 11:00:35 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: pavel@ucw.cz, torvalds@linux-foundation.org, darwish.07@gmail.com,
       casey@schaufler-ca.com, akpm@linux-foundation.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       viro@ftp.linux.org.uk
Subject: Re: [PATCH] Smackv10: Smack rules grammar + their stateful parser
Message-ID: <20071106100035.GE26163@stusta.de>
References: <472B8DAF.9080706@schaufler-ca.com> <20071103164303.GA26707@ubuntu> <20071104122848.GC3921@ucw.cz> <20071105094007.GA19367@ubuntu> <alpine.LFD.0.999.0711050818200.15101@woody.linux-foundation.org> <200711060656.ADF87510.tJLVFOHOFSOFMQ@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200711060656.ADF87510.tJLVFOHOFSOFMQ@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2007 at 06:56:43AM +0900, Tetsuo Handa wrote:
> 
> Linus Torvalds wrote:
> > I personally think string parsers are *much* better than the alternatives 
> > (which basically boil down to nasty binary interfaces)
> Me too.
> 
> > Binary structures and ioctl's are *much* worse. They are totally 
> > undebuggable with generic tools (think "echo" or "strace"), and they are a 
> > total nightmare to parse across architectures and pointer sizes.
> Not only pointer sizes bugs, but also checking pointer address costs.
> For binary policy, we have to examine ->next pointer is valid or not.
> We can't blindly use address supplied from userland.
> 
> I have encountered mismatch of kernel version and AppArmor's policy parser version
> when I just updated only kernel. As a result, the segmentation faults rushed toward me.
>  From this experience, TOMOYO still uses string parser in the kernel.
> If a parser doesn't consume much stack (i.e. call functions recursively), I think it is no problem.

You have a "\?" pattern which is defined as "1 byte character other
than '/'".

The user usually doesn't know how many bytes a character in a path or 
file name on his system has.

IMHO not ideal for name-based MAC...

> Thanks.


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

