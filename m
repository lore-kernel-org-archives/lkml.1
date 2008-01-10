Return-Path: <linux-kernel-owner+w=401wt.eu-S1757443AbYAJHmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443AbYAJHmO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 02:42:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753610AbYAJHl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 02:41:59 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:54969 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770AbYAJHl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 02:41:58 -0500
Date: Thu, 10 Jan 2008 08:42:01 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: jreiser@BitWagon.com, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: STT_FUNC for assembler checksum and semaphore ops" in git-x86
Message-ID: <20080110074201.GA12585@uranus.ravnborg.org>
References: <20080109215725.GA18185@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080109215725.GA18185@basil.nowhere.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 10:57:25PM +0100, Andi Kleen wrote:
> 
> In gitx86:
> 
> commit 692effca950d7c6032e8e2ae785a32383e7af4a3
> Author: John Reiser <jreiser@BitWagon.com>
> Date:   Wed Jan 9 13:31:12 2008 +0100
> 
>     STT_FUNC for assembler checksum and semaphore ops
> ...
>     Comments?
>     
>     Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> diff --git a/arch/x86/lib/checksum_32.S b/arch/x86/lib/checksum_32.S
> index adbccd0..1f9aacb 100644
> --- a/arch/x86/lib/checksum_32.S
> +++ b/arch/x86/lib/checksum_32.S
> @@ -48,6 +48,7 @@ unsigned int csum_partial(const unsigned char * buff, int len, unsigned int sum)
>            * Fortunately, it is easy to convert 2-byte alignment to 4-byte
>            * alignment for the unrolled loop.
>            */           
> +       .type csum_partial, @function
>  ENTRY(csum_partial)
> +       .type csum_partial, @function
>  ENTRY(csum_partial)
>         CFI_STARTPROC
>         pushl %esi
> @@ -141,11 +142,13 @@ ENTRY(csum_partial)
>         ret
>         CFI_ENDPROC
>  ENDPROC(csum_partial)
> +       .size csum_partial, . - csum_partial
> 
> AK:
> Better option would be to just add to ENTRY/ENDPROC
> 
> do something like (untested) 
> 
> #define ENTRY(x) \
> 	...
> 	.set curfunc, x
> 
> #define ENDPROC(x) \
> 	...
> 	.size x - curfunc
> 
John got more or less same comment from me - but
I did not hear further.
As it stands out now it not nice.

	Sam
