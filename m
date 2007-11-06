Return-Path: <linux-kernel-owner+w=401wt.eu-S1754778AbXKFO7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778AbXKFO7p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 09:59:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbXKFO7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 09:59:38 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:49334 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752605AbXKFO7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 09:59:37 -0500
Date: Tue, 6 Nov 2007 15:59:13 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: pavel@ucw.cz, torvalds@linux-foundation.org, darwish.07@gmail.com,
       casey@schaufler-ca.com, akpm@linux-foundation.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       viro@ftp.linux.org.uk
Subject: Re: [PATCH] Smackv10: Smack rules grammar + their stateful parser
Message-ID: <20071106145913.GM26163@stusta.de>
References: <alpine.LFD.0.999.0711050818200.15101@woody.linux-foundation.org> <200711060656.ADF87510.tJLVFOHOFSOFMQ@I-love.SAKURA.ne.jp> <20071106100035.GE26163@stusta.de> <200711062127.CBC60981.tQOOSVFHJFOFML@I-love.SAKURA.ne.jp> <20071106135845.GJ26163@stusta.de> <200711062332.DFH35933.FtQLMSOOOVHJFF@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200711062332.DFH35933.FtQLMSOOOVHJFF@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2007 at 11:32:15PM +0900, Tetsuo Handa wrote:
> Hello.
> 
> Adrian Bunk wrote:
> > And \* is not a replacement for \?. It's quite common to have both ways 
> > to express "one character" and to express "at least one character", and 
> > both have their use cases and will get used if available.
> You can use \? to represent "one character" and
> \?\* to represent "at least one character".

Not "one character", it's "one byte".

> > But the problem is that in your code you only match one byte for \?, 
> > and this might or might not be equal to one character.
> "one byte" is almost equal to "one character".
> "\?" matches to one of the following types.
> 
> *  1 ASCII printable character (for 0x21-0x2E or 0x30-0x5B or 0x5D-0x7E)
> *  2 ASCII printable characters \\ (for 0x5C, which means single "\")
> *  4 ASCII printable characters \ooo (for 0x01-0x20 or 0x7F-0xFF, where "ooo" is octal value)
> 
> These 3 types represents one *byte*.
> I want to say "\? matches to one character",
> but since expression of a character depends on the value of that byte,
> I'm saying "\? matches to one *byte* character" instead.
> Well, this sentence might be confusing, but how can I express more accurately?

The problem is that your code matches one byte, not one character.

More or less all userspace programs handle multi-byte UTF-8 characters 
just fine without bothering the user with the fact whether a character 
consists of one or more bytes.

And users will try to use this \? for matching one character when 
writing a pattern that denies access.

That's not just a documentation problem.

> Thanks.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

