Return-Path: <linux-kernel-owner+w=401wt.eu-S1754511AbYHXPBC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511AbYHXPBC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 11:01:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751560AbYHXPA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 11:00:56 -0400
Received: from bu3sch.de ([62.75.166.246]:47643 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045AbYHXPAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 11:00:55 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Andreas Schwab <schwab@suse.de>
Subject: Re: Random crashes with 2.6.27-rc3 on PPC
Date: Sun, 24 Aug 2008 17:00:22 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: benh@kernel.crashing.org, linuxppc-dev@ozlabs.org,
       Linus Torvalds <torvalds@osdl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <200808231610.46473.mb@bu3sch.de> <200808241544.12412.mb@bu3sch.de> <je7ia6bhdd.fsf@sykes.suse.de>
In-Reply-To: <je7ia6bhdd.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808241700.22815.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 24 August 2008 16:46:38 Andreas Schwab wrote:
> Michael Buesch <mb@bu3sch.de> writes:
> 
> > The following workaround seems to fix the crashes on powerpc.
> > However, this patch is clearly not what we want for other architectures,
> > as they might need -fno-omit-frame-pointer to function properly.
> 
> This has a better chance to be accepted. :-)
> 
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 8b5a7d3..f9a2e48 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -394,7 +394,7 @@ config LOCKDEP
>  	bool
>  	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
>  	select STACKTRACE
> -	select FRAME_POINTER if !X86 && !MIPS
> +	select FRAME_POINTER if !X86 && !MIPS && !PPC
>  	select KALLSYMS
>  	select KALLSYMS_ALL

This is not what my patch is doing.
Your patch always forces FRAME_POINTER off. At least as far as lockdep is concerned.
What about other parts of the kernel that enable FRAME_POINTER?

I think this should be fixed in the makefile by substitution of
-fno-omit-frame-pointer on PPC (and probably depending on the compiler
version).

Otherwise, if somebody else decides to do select FRAME_POINTER in some other
code, the bug will reappear.
I'm also not sure if it's desired to always force FRAME_POINTER off.

-- 
Greetings Michael.
