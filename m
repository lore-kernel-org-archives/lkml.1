Return-Path: <linux-kernel-owner+w=401wt.eu-S1757453AbYAFBBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453AbYAFBBJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 20:01:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754220AbYAFBA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 20:00:56 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:11718 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253AbYAFBAz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 20:00:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=cjFz/Qyu7oNTQCYBB/yDoaECBsM0Y8EDkCgRORbh4oJrxcRCkEPlJOvckwutQDDXmyGYexIgZnK+lUcC+L5k59IsYpcXmvX8g2H4dmCkbt32tJctGZ42DUe67OwaAUdRrbpM3g/+J0rvLpnqWmVLgWpNQ4O3OrutkRjNssRUCgw=
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] x86: ioport_{32|64}.c unification
Date: Sun, 6 Jan 2008 02:00:50 +0100
User-Agent: KMail/1.9.7
Cc: Miguel =?utf-8?q?Bot=C3=B3n?= <mboton.lkml@gmail.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       tglx@linutronix.de
References: <200801060059.48333.mboton@gmail.com> <200801060147.48185.arnd@arndb.de>
In-Reply-To: <200801060147.48185.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200801060200.51166.mboton@gmail.com>
From: Miguel =?utf-8?q?Bot=C3=B3n?= <mboton.lkml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 06 January 2008 01:47:47 Arnd Bergmann wrote:
> This #ifdef overload could probably be avoided if you just move
> the body of this function into an extra place and do
>
> static int do_iopl(unsigned int level, unsigned long *flags)
> {
>         unsigned int old = (*flags >> 12) & 3;
> 	...
>         *flags = (*flags & ~X86_EFLAGS_IOPL) | (level << 12);;
> }
>
> #ifdef CONFIG_X86_32
> asmlinkage long sys_iopl(unsigned long regsp)
> {
> 	/* why is this volatle anyway? */
> 	volatile struct pt_regs *regs = (struct pt_regs *)&regsp;
> 	unsigned int level = regs->bx;
> 	return do_iopl(regs->bx, &regs->flags);
> }
> #else
> asmlinkage long sys_iopl(unsigned int level, struct pt_regs *regs)
> {
> 	return do_iopl(level, &regs->flags);
> }
> #endif
>
> 	Arnd <><

I agree. I'll send the a proper patch soon.

-- 
	Miguel Botón
