Return-Path: <linux-kernel-owner+w=401wt.eu-S1754521AbZDWGF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521AbZDWGF4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 02:05:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498AbZDWGFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 02:05:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41539 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbZDWGFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 02:05:47 -0400
Date: Thu, 23 Apr 2009 08:09:17 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Joe Damato <ice799@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: Re: [PATCH] X86-32: Let gcc decide whether to inline memcpy was Re: New x86 warning
Message-ID: <20090423060917.GF13896@one.firstfloor.org>
References: <49EEBD3C.3060009@garzik.org> <20090422070157.GA28438@elte.hu> <8763gxoz50.fsf_-_@basil.nowhere.org> <3605561d0904221649n169dc579xb0694297154d97fa@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3605561d0904221649n169dc579xb0694297154d97fa@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > It's a very attractive patch because it removes a lot of code:
> 
> I think this patch is great. Perhaps this would be a good time to also
> clean out memset for x86_32? (If needed, I can start a new email

Yes looks reasonable. You can add

Reviewed-by: Andi Kleen <ak@linux.intel.com>

if you fix the comment below.

In fact it should be synced to do the same as on 64bit which already
does all that and was originally written for gcc 3.1/3.2 ...

-Andi
> +void *__memset(void *s, char c, size_t count)
> +{
> +	int d0, d1;
> +	asm volatile("rep\n\t"
> +		     "stosb"
> +		     : "=&c" (d0), "=&D" (d1)
> +		     : "a" (c), "1" (s), "0" (count)
> +		     : "memory");
> +	return s;
> +}
> +EXPORT_SYMBOL(__memset);

I suspect _memset is not needed anymore, just memset() alone
should be enough. So remove the wrapper below.

> +
>  void *memset(void *s, int c, size_t count)
>  {
>  	return __memset(s, c, count);
> -- 
> 1.6.2
> 

-- 
ak@linux.intel.com -- Speaking for myself only.
