Return-Path: <linux-kernel-owner+w=401wt.eu-S1758288AbYBEQDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758288AbYBEQDe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 11:03:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753981AbYBEQDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 11:03:25 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:44172 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752162AbYBEQDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 11:03:24 -0500
Date: Tue, 5 Feb 2008 17:02:14 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Kosina <jkosina@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Abel Bernabeu <abel.bernabeu@gmail.com>,
       Hugh Dickins <hugh@veritas.com>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: brk randomization breaks columns
Message-ID: <20080205160214.GD24331@elf.ucw.cz>
References: <20080204122837.GA1647@elf.ucw.cz> <Pine.LNX.4.64.0802050242440.30873@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802050242440.30873@twin.jikos.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Still, it will probably not fix your particular program crashes, just 
> because it will always assume that brk starts immediately after the end of 
> the bss, which is plain wrong and has never been assured. Could you please 
> check whether there is any compat-* package available for you 
> distribution, that upgrades libc.so.5 to any fixed version?

I got libc.so.5 as a binary from some Slackware-based system, IIRC,
and I can't find any relevant compat-* packages :-(.

> From: Jiri Kosina <jkosina@suse.cz>
> 
> brk: check the lower bound properly
> 
> There is a check in sys_brk(), that tries to make sure that we do not 
> underflow the area that is dedicated to brk heap.
> 
> The check is however wrong, as it assumes that brk area starts immediately 
> after the end of the code (+bss), which is wrong for example in 
> environments with randomized brk start. The proper way is to check whether 
> the address is not below the start_brk address.
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>

ACK.


> diff --git a/mm/mmap.c b/mm/mmap.c
> index 8295577..1c3b48f 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -241,7 +241,7 @@ asmlinkage unsigned long sys_brk(unsigned long brk)
>  
>  	down_write(&mm->mmap_sem);
>  
> -	if (brk < mm->end_code)
> +	if (brk < mm->start_brk)
>  		goto out;
>  
>  	/*

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
