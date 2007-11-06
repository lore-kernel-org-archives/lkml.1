Return-Path: <linux-kernel-owner+w=401wt.eu-S1755219AbXKFOcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219AbXKFOcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 09:32:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752915AbXKFOcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 09:32:24 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:54842 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753122AbXKFOcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 09:32:23 -0500
To: bunk@kernel.org
Cc: pavel@ucw.cz, torvalds@linux-foundation.org, darwish.07@gmail.com,
       casey@schaufler-ca.com, akpm@linux-foundation.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       viro@ftp.linux.org.uk
Subject: Re: [PATCH] Smackv10: Smack rules grammar + their stateful parser
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <alpine.LFD.0.999.0711050818200.15101@woody.linux-foundation.org>
	<200711060656.ADF87510.tJLVFOHOFSOFMQ@I-love.SAKURA.ne.jp>
	<20071106100035.GE26163@stusta.de>
	<200711062127.CBC60981.tQOOSVFHJFOFML@I-love.SAKURA.ne.jp>
	<20071106135845.GJ26163@stusta.de>
In-Reply-To: <20071106135845.GJ26163@stusta.de>
Message-Id: <200711062332.DFH35933.FtQLMSOOOVHJFF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Tue, 6 Nov 2007 23:32:15 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Adrian Bunk wrote:
> And \* is not a replacement for \?. It's quite common to have both ways 
> to express "one character" and to express "at least one character", and 
> both have their use cases and will get used if available.
You can use \? to represent "one character" and
\?\* to represent "at least one character".

> But the problem is that in your code you only match one byte for \?, 
> and this might or might not be equal to one character.
"one byte" is almost equal to "one character".
"\?" matches to one of the following types.

*  1 ASCII printable character (for 0x21-0x2E or 0x30-0x5B or 0x5D-0x7E)
*  2 ASCII printable characters \\ (for 0x5C, which means single "\")
*  4 ASCII printable characters \ooo (for 0x01-0x20 or 0x7F-0xFF, where "ooo" is octal value)

These 3 types represents one *byte*.
I want to say "\? matches to one character",
but since expression of a character depends on the value of that byte,
I'm saying "\? matches to one *byte* character" instead.
Well, this sentence might be confusing, but how can I express more accurately?

Thanks.

