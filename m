Return-Path: <linux-kernel-owner+w=401wt.eu-S1752736AbZA0XXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbZA0XXQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 18:23:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751020AbZA0XW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 18:22:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51548 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbZA0XW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 18:22:59 -0500
Message-ID: <497F9740.4000505@zytor.com>
Date: Tue, 27 Jan 2009 15:22:40 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [mingo@elte.hu: [git pull] headers_check fixes]
References: <20090127222825.GA27097@elte.hu> <alpine.LFD.2.00.0901271441280.3123@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0901271441280.3123@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> So I think it makes our headers worse. Code like
> 
> 	> +#ifdef __KERNEL__
> 	> +# ifdef CONFIG_X86_BSWAP
> 	> +# define __X86_BSWAP  
> 	> +# endif /* CONFIG_X86_BSWAP */
> 	> +#endif /* __KERNEL__ */
> 
> just doesn't make sense. It doesn't make sense _inside_ the kernel, and it 
> doesn't make sense _outside_ it either.
> 
> As far as I can tell, the header install script could literally just do 
> something like run 'sed' over the headers as it installs them, and do 
> something like
> 
> 	sed 's/\<CONFIG_[A-Z0-9_]*\>/__kernel_only__/g'
> 
> which I realize is not really the complete/correct solution (ie you could 
> write a nicer thing that does a better job), but my point here is that 
> rather than have scripts that _whine_ about these kinds of trivial things 
> and cause people to write less readable header files, we should just make 
> sure that if we can recognize them so easily, we can just fix them 
> instead.
> 

We already run the headers through unifdef, so this should be trivial to 
add.

The intent of headers_check is to try to catch people who put things 
that depend on CONFIG_* stuff in exported headers (which, as we have 
seen, have been too sadly common.)  If we declare that the export 
process will treat all CONFIG_* as undefined, we do lose some coverage 
but potentially end up with cleaner code.  Not sure which is worse...

	-hpa
