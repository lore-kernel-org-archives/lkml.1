Return-Path: <linux-kernel-owner+w=401wt.eu-S1757574AbXKFM1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574AbXKFM1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 07:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756063AbXKFM1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 07:27:10 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:51178 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755727AbXKFM1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 07:27:09 -0500
To: bunk@kernel.org
Cc: pavel@ucw.cz, torvalds@linux-foundation.org, darwish.07@gmail.com,
       casey@schaufler-ca.com, akpm@linux-foundation.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       viro@ftp.linux.org.uk
Subject: Re: [PATCH] Smackv10: Smack rules grammar + their stateful parser
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20071104122848.GC3921@ucw.cz>
	<20071105094007.GA19367@ubuntu>
	<alpine.LFD.0.999.0711050818200.15101@woody.linux-foundation.org>
	<200711060656.ADF87510.tJLVFOHOFSOFMQ@I-love.SAKURA.ne.jp>
	<20071106100035.GE26163@stusta.de>
In-Reply-To: <20071106100035.GE26163@stusta.de>
Message-Id: <200711062127.CBC60981.tQOOSVFHJFOFML@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Tue, 6 Nov 2007 21:27:00 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Adrian Bunk wrote:
> You have a "\?" pattern which is defined as "1 byte character other
> than '/'".
Don't worry. The "\?" pattern is for temporary files with /tmp/prefixXXXXXX pattern.
/tmp/prefixXXXXXX is represented as /tmp/prefix\?\?\?\?\?\? in TOMOYO Linux's syntax.

> The user usually doesn't know how many bytes a character in a path or 
> file name on his system has.
The "\*" pattern is for this purpose which means more than 0 byte characters other than '/'.

TOMOYO supports various patterns
http://tomoyo.sourceforge.jp/en/1.5.x/policy-reference.html#exception_policy.conf

TOMOYO Linux handles string using 7bit ASCII. In TOMOYO Linux,
a byte 0x21 <= c <= 0x7E && c != 0x5C is represented as is,
c == 0x5C is represented as \\,
0x01 <= c <= 0x20 || 0x7F <= c <= 0xFF is represented as \ooo style.
c == 0x00 is not needed since it is used as end-of-string marker.
This rule makes any string passed from/to kernel safely.

Thanks.

