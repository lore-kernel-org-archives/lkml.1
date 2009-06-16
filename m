Return-Path: <linux-kernel-owner+w=401wt.eu-S1761548AbZFPSdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761548AbZFPSdw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 14:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761371AbZFPSda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 14:33:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60581 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761422AbZFPSd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 14:33:29 -0400
Message-ID: <4A37B703.3060409@zytor.com>
Date: Tue, 16 Jun 2009 08:15:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Amerigo Wang <xiyou.wangcong@gmail.com>
CC: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [x86] Build error at arch/x86/boot/bioscall.S
References: <200906160738.n5G7cs9r007216@www262.sakura.ne.jp> <20090616081445.GB6270@cr0.nay.redhat.com>
In-Reply-To: <20090616081445.GB6270@cr0.nay.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amerigo Wang wrote:
> 
> Huh?
> 16 bit mode doesn't allow 'esp' to be used as a base/index register?
> 

16-bit mode does, but gas used to be utterly broken with regards to
32-bit address overrides.  This has been fixed, but apparently these
old, broken versions of gas are still out there festering in the
environment.

One possible workaround is to switch .code16 to .code16gcc at the top of
the file; another is:

-	movw	68(%esp), %di
+	movw	%sp, %di
+	movw	68(%di), %di

Does changing .code16 to .code16gcc work for you?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

