Return-Path: <linux-kernel-owner+w=401wt.eu-S1752195AbZFPIMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195AbZFPIMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 04:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbZFPIMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 04:12:31 -0400
Received: from mail-pz0-f187.google.com ([209.85.222.187]:60787 "EHLO
	mail-pz0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbZFPIM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 04:12:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=s7BHVhxmO+f+mrQuvm3NM09kaux2eKVhV+ons1cjVKaCTKy42ORidEBXxNVzJwc62N
         c7UQXmkz5lOChGMh3tR8d2OyV9028mLj8PJm2FISoGiiJaPoD7TnmC1VZ91IjTpYSG/u
         GErlQ5Houwl3WIGnAjYxUUMOgJUnMiV5OOUjo=
Date: Tue, 16 Jun 2009 16:14:45 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [x86] Build error at arch/x86/boot/bioscall.S
Message-ID: <20090616081445.GB6270@cr0.nay.redhat.com>
References: <200906160738.n5G7cs9r007216@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906160738.n5G7cs9r007216@www262.sakura.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 04:38:54PM +0900, Tetsuo Handa wrote:
>Hello.
>
>I tried to build 03347e2592078a90df818670fddf97a33eec70fb and got this error.
>
>(...snipped...)
>WARNING: modpost: Found 2 section mismatch(es).
>To see full details build your kernel with:
>'make CONFIG_DEBUG_SECTION_MISMATCH=y'
>/usr/src/all/linux/kernel/git/torvalds/linux-2.6.git/usr/include/linux/netfilter/xt_osf.h:40: found __[us]{8,16,32,64} type without #include <linux/types.h>
>/usr/src/all/linux/kernel/git/torvalds/linux-2.6.git/usr/include/mtd/jffs2-user.h:21: userspace cannot call function or variable defined in the kernel
>Documentation/accounting/getdelays.c: In function `main':
>Documentation/accounting/getdelays.c:249: warning: `cmd_type' might be used uninitialized in this function
>Documentation/spi/spidev_fdx.c: In function `do_msg':
>Documentation/spi/spidev_fdx.c:61: warning: cast from pointer to integer of different size
>Documentation/spi/spidev_fdx.c:64: warning: cast from pointer to integer of different size
>arch/x86/boot/bioscall.S: Assembler messages:
>arch/x86/boot/bioscall.S:68: Error: `68(%esp)' is not a valid 16 bit base/index expression

Huh?
16 bit mode doesn't allow 'esp' to be used as a base/index register?

How about:

- movw 68(%esp), %di
+ movzwl %sp, %ebx
+ movw 68(%ebx), %di

? Does this work?

Thanks.
