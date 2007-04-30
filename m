Return-Path: <linux-kernel-owner+w=401wt.eu-S1945931AbXD3QQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945931AbXD3QQk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 12:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946327AbXD3QQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 12:16:23 -0400
Received: from terminus.zytor.com ([192.83.249.54]:34107 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946281AbXD3QOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 12:14:23 -0400
Message-ID: <463615BA.4020703@zytor.com>
Date: Mon, 30 Apr 2007 09:13:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andi Kleen <ak@suse.de>,
       virtualization <virtualization@lists.linux-foundation.org>,
       linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 06/12] i386: Minimum cpu detection cleanups.
References: <m1d51l6f1y.fsf@ebiederm.dsl.xmission.com>	<m18xc96eyq.fsf@ebiederm.dsl.xmission.com>	<m14pmx6ewk.fsf_-_@ebiederm.dsl.xmission.com>	<m1zm4p509a.fsf_-_@ebiederm.dsl.xmission.com>	<m1vefd4zyj.fsf_-_@ebiederm.dsl.xmission.com>	<m1r6q14zow.fsf_-_@ebiederm.dsl.xmission.com> <m1mz0p4zfc.fsf_-_@ebiederm.dsl.xmission.com>
In-Reply-To: <m1mz0p4zfc.fsf_-_@ebiederm.dsl.xmission.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> 
> diff --git a/arch/i386/kernel/verify_cpu.S b/arch/i386/kernel/verify_cpu.S
> index ba9e03e..e51a869 100644
> --- a/arch/i386/kernel/verify_cpu.S
> +++ b/arch/i386/kernel/verify_cpu.S
> @@ -4,10 +4,6 @@
>  #include <asm/cpufeature.h>
>  
>  verify_cpu:
> -#if REQUIRED_MASK1 == 0
> -	xorl %eax,%eax
> -	ret
> -#endif
>  	pushfl				# Save caller passed flags
>  	pushl	$0			# Kill any dangerous flags
>  	popfl
> @@ -21,7 +17,7 @@ verify_cpu:
>  	testl	$(1<<18),%eax
                 ^^^^^^^
>  	jz	bad

While you're in there can you change references to the flags to use the
<asm/cpuflags.h> constants?

	-hpa
