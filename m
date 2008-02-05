Return-Path: <linux-kernel-owner+w=401wt.eu-S1756241AbYBESFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241AbYBESFY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 13:05:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbYBESFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 13:05:12 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:60904 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751756AbYBESFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 13:05:11 -0500
Date: Tue, 5 Feb 2008 19:05:19 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Kosina <jkosina@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Abel Bernabeu <abel.bernabeu@gmail.com>,
       Hugh Dickins <hugh@veritas.com>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: brk randomization breaks columns
Message-ID: <20080205180519.GA1525@elf.ucw.cz>
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

Sorry, I now tested the patch. It looked good to my untrained eyes,
but upon testing it on columns:

...
personality(PER_LINUX)                  = 4194304
geteuid()                               = 1000
getuid()                                = 1000
getgid()                                = 1002
getegid()                               = 1002
brk(0x8054098)                          = 0x922d000
--- SIGSEGV (Segmentation fault) @ 0 (0) ---

...it should have said -EINVAL or something like that.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
