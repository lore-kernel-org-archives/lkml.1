Return-Path: <linux-kernel-owner+w=401wt.eu-S1754595AbXKFP1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbXKFP1V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 10:27:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752605AbXKFP1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 10:27:13 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:62737 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237AbXKFP1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 10:27:12 -0500
To: bunk@kernel.org
Cc: pavel@ucw.cz, torvalds@linux-foundation.org, darwish.07@gmail.com,
       casey@schaufler-ca.com, akpm@linux-foundation.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       viro@ftp.linux.org.uk
Subject: Re: [PATCH] Smackv10: Smack rules grammar + their stateful parser
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20071106100035.GE26163@stusta.de>
	<200711062127.CBC60981.tQOOSVFHJFOFML@I-love.SAKURA.ne.jp>
	<20071106135845.GJ26163@stusta.de>
	<200711062332.DFH35933.FtQLMSOOOVHJFF@I-love.SAKURA.ne.jp>
	<20071106145913.GM26163@stusta.de>
In-Reply-To: <20071106145913.GM26163@stusta.de>
Message-Id: <200711070027.GCH09822.QFFSOOFHJtLVOM@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Wed, 7 Nov 2007 00:27:04 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Adrian Bunk wrote:
> The problem is that your code matches one byte, not one character.
> 
> More or less all userspace programs handle multi-byte UTF-8 characters 
> just fine without bothering the user with the fact whether a character 
> consists of one or more bytes.
I understood what you are saying.

You are saying "a character" does not always consist of one byte,
while I'm saying "a character" does always consist of one byte.

Yes, some userspace programs don't use strcmp()
since strcmp() can't handle some encodings like UTF-16.
But the kernel uses strcmp()
since the VFS related functions can't handle encodings
which contains '\0' in the pathname.
VFS related functions assume that '\0' is end-of-string marker.

So, from the point of view of userland programs,
'\?' should match to a single character (which depends on encoding).
But from the point of view of the kernel,
'\?' should match to a single byte (which doesn't depend on encoding).
Handling all possible encoding in the kernel is too difficult to implement.
I'll continue using '\?' matches to a single byte.

> And users will try to use this \? for matching one character when 
> writing a pattern that denies access.
Yes, but since this string is handled by the *kernel*,
I want users follow point of view of the kernel.

Thanks.

