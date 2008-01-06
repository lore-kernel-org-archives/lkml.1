Return-Path: <linux-kernel-owner+w=401wt.eu-S1758401AbYAFBVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758401AbYAFBVB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 20:21:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755692AbYAFBUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 20:20:51 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:32247 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920AbYAFBUu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 20:20:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=VwTZ+JIUhutDzedc33StqFw2QYlqfAlizQJcttOfRWEqi0XnuI9hUR/0UgpBW6lLT4OHT+a4u5YXnf+LrbC2mXDJCgnzwq69YFLVLzVpx4sMDHAviIbcWu1R9V57J8qJgtB8lhhwWkSr8MZd2ICt9ErgW00gJuJbn5jwSyxTMmk=
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] x86: ioport_{32|64}.c unification
Date: Sun, 6 Jan 2008 02:20:45 +0100
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
Message-Id: <200801060220.45669.mboton@gmail.com>
From: Miguel =?utf-8?q?Bot=C3=B3n?= <mboton.lkml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just realize that in some cases 'regs->flags' is a long instead of an 
unsigned long so... this would be a proper solution?

static long do_iopl(unsigned int level, long *flags)
{
	...
}

#ifdef CONFIG_X86_32
asmlinkage long sys_iopl(unsigned long regsp)
{
	volatile struct pt_regs *regs = (struct pt_regs *)&regsp;
	unsigned int level = regs->bx;
#else
asmlinkage long sys_iopl(unsigned int level, struct pt_regs *regs)
{
#endif
	return do_iopl(level, (long *)&regs->flags);
}

Or maybe would be better if 'do_iopl' prototype is:

static long do_iopl(unsigned int level, struct pt_regs *regs);

-- 
	Miguel Botón
