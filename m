Return-Path: <linux-kernel-owner+w=401wt.eu-S1757434AbYAKCzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434AbYAKCzL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 21:55:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbYAKCy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 21:54:59 -0500
Received: from one.firstfloor.org ([213.235.205.2]:43761 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbYAKCy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 21:54:58 -0500
Date: Fri, 11 Jan 2008 03:57:34 +0100
From: Andi Kleen <andi@firstfloor.org>
To: John Reiser <jreiser@BitWagon.com>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu,
       Jeff Dike <jdike@addtoit.com>, Sam Ravnborg <sam@ravnborg.org>,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: STT_FUNC for assembler checksum and semaphore ops" in git-x86
Message-ID: <20080111025734.GA6908@one.firstfloor.org>
References: <20080109215725.GA18185@basil.nowhere.org> <20080110074201.GA12585@uranus.ravnborg.org> <478649D8.9080209@BitWagon.com> <20080110180225.GA747@one.firstfloor.org> <4786BF88.5010802@BitWagon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4786BF88.5010802@BitWagon.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2008 at 04:59:52PM -0800, John Reiser wrote:
> Andi Kleen wrote:
> > But actually checking the default implementation in linkage.h already
> > implements size: [snip]
> 
> > Are you sure it doesn't work?  Your patch should be not needed. If it's
> > still wrong then just ENDPROCs() need to be added.
> 
> The ENDPROCs() were not used everywhere.  Some code used just END() instead,
> while other code used nothing.  um/sys-i386/checksum.S didn't #include

END() is fine too since it contains .size too:

#ifndef END
#define END(name) \
  .size name, .-name
#endif

> diff --git a/arch/x86/lib/semaphore_32.S b/arch/x86/lib/semaphore_32.S
> index 444fba4..e2c6e0d 100644
> --- a/arch/x86/lib/semaphore_32.S
> +++ b/arch/x86/lib/semaphore_32.S
> @@ -49,7 +49,7 @@ ENTRY(__down_failed)
>  	ENDFRAME
>  	ret
>  	CFI_ENDPROC
> -	END(__down_failed)
> +	ENDPROC(__down_failed)

I don't think these change makes sense given the definition of END()
shown above.

The only change that would make sense is adding END() (or ENDPROC()) 
to a function that doesn't have either of them yet.

Since you seem to do nop changes something is wrong with your
testing procedure?

-Andi
