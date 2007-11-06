Return-Path: <linux-kernel-owner+w=401wt.eu-S1755808AbXKFWmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808AbXKFWmk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 17:42:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754386AbXKFWmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 17:42:32 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:48453 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754406AbXKFWmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 17:42:31 -0500
Date: Tue, 6 Nov 2007 23:42:06 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: pavel@ucw.cz, torvalds@linux-foundation.org, darwish.07@gmail.com,
       casey@schaufler-ca.com, akpm@linux-foundation.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       viro@ftp.linux.org.uk
Subject: Re: [PATCH] Smackv10: Smack rules grammar + their stateful parser
Message-ID: <20071106224206.GN26163@stusta.de>
References: <20071106100035.GE26163@stusta.de> <200711062127.CBC60981.tQOOSVFHJFOFML@I-love.SAKURA.ne.jp> <20071106135845.GJ26163@stusta.de> <200711062332.DFH35933.FtQLMSOOOVHJFF@I-love.SAKURA.ne.jp> <20071106145913.GM26163@stusta.de> <200711070027.GCH09822.QFFSOOFHJtLVOM@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200711070027.GCH09822.QFFSOOFHJtLVOM@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2007 at 12:27:04AM +0900, Tetsuo Handa wrote:
> Hello.
> 
> Adrian Bunk wrote:
> > The problem is that your code matches one byte, not one character.
> > 
> > More or less all userspace programs handle multi-byte UTF-8 characters 
> > just fine without bothering the user with the fact whether a character 
> > consists of one or more bytes.
> I understood what you are saying.
> 
> You are saying "a character" does not always consist of one byte,
> while I'm saying "a character" does always consist of one byte.
> 
> Yes, some userspace programs don't use strcmp()
> since strcmp() can't handle some encodings like UTF-16.
> But the kernel uses strcmp()
> since the VFS related functions can't handle encodings
> which contains '\0' in the pathname.
> VFS related functions assume that '\0' is end-of-string marker.
>...

The common case isn't UTF-16, it's UTF-8.

And UTF-8 is both quite common and doesn't have this problem with '\0'.

> > And users will try to use this \? for matching one character when 
> > writing a pattern that denies access.
> Yes, but since this string is handled by the *kernel*,
> I want users follow point of view of the kernel.

Users are used to deal with characters and hot having to bother with all 
the mess of different encodings.

Having patterns that describe rules to deny access in an LSM breaking 
this expectation is really a bad thing.

> Thanks.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

