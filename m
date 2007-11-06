Return-Path: <linux-kernel-owner+w=401wt.eu-S1754473AbXKFN7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473AbXKFN7U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 08:59:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143AbXKFN7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 08:59:11 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:55518 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752064AbXKFN7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 08:59:10 -0500
Date: Tue, 6 Nov 2007 14:58:45 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: pavel@ucw.cz, torvalds@linux-foundation.org, darwish.07@gmail.com,
       casey@schaufler-ca.com, akpm@linux-foundation.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       viro@ftp.linux.org.uk
Subject: Re: [PATCH] Smackv10: Smack rules grammar + their stateful parser
Message-ID: <20071106135845.GJ26163@stusta.de>
References: <20071104122848.GC3921@ucw.cz> <20071105094007.GA19367@ubuntu> <alpine.LFD.0.999.0711050818200.15101@woody.linux-foundation.org> <200711060656.ADF87510.tJLVFOHOFSOFMQ@I-love.SAKURA.ne.jp> <20071106100035.GE26163@stusta.de> <200711062127.CBC60981.tQOOSVFHJFOFML@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200711062127.CBC60981.tQOOSVFHJFOFML@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2007 at 09:27:00PM +0900, Tetsuo Handa wrote:
> Hello.
> 
> Adrian Bunk wrote:
> > You have a "\?" pattern which is defined as "1 byte character other
> > than '/'".
> Don't worry. The "\?" pattern is for temporary files with /tmp/prefixXXXXXX pattern.
> /tmp/prefixXXXXXX is represented as /tmp/prefix\?\?\?\?\?\? in TOMOYO Linux's syntax.
> 
> > The user usually doesn't know how many bytes a character in a path or 
> > file name on his system has.
> The "\*" pattern is for this purpose which means more than 0 byte characters other than '/'.
> 
> TOMOYO supports various patterns
> http://tomoyo.sourceforge.jp/en/1.5.x/policy-reference.html#exception_policy.conf

And there you document \* as well as \? as wildcards for "pathname 
patterns".

And \* is not a replacement for \?. It's quite common to have both ways 
to express "one character" and to express "at least one character", and 
both have their use cases and will get used if available.

> TOMOYO Linux handles string using 7bit ASCII. In TOMOYO Linux,
> a byte 0x21 <= c <= 0x7E && c != 0x5C is represented as is,
> c == 0x5C is represented as \\,
> 0x01 <= c <= 0x20 || 0x7F <= c <= 0xFF is represented as \ooo style.
> c == 0x00 is not needed since it is used as end-of-string marker.
> This rule makes any string passed from/to kernel safely.

That's unrelated to this problem.

You talk about your internal byte representation.

But the problem is that in your code you only match one byte for \?, 
and this might or might not be equal to one character.

> Thanks.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

