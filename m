Return-Path: <linux-kernel-owner+w=401wt.eu-S1762079AbXHXVBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762079AbXHXVBK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 17:01:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757035AbXHXVAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 17:00:54 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:46190 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757361AbXHXVAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 17:00:52 -0400
Date: Fri, 24 Aug 2007 11:02:20 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org, Andi Kleen <ak@suse.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] Re: [RFC][PATCH -mm 3/4] Hibernation: Pass CR3 in the image header on x86_64
Message-ID: <20070824090220.GA2412@elf.ucw.cz>
References: <200708221015.16493.rjw@sisk.pl> <20070822082825.GC2479@elf.ucw.cz> <200708221817.51334.rjw@sisk.pl> <200708222249.51616.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708222249.51616.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > No, I do not think I like that. I believe both -> control and -> crc
> > > is just useless paranoia. Bitflip in this area is not going to be any
> > > worse than bitflip anywhere else, we should not pretend this is
> > > somehow "more important".
> > > 
> > > -> control should really be "protocol version"... probably should
> > > contain some field that is easy to increment.
> > 
> > OK
> > 
> > Perhaps I'll just remove the crc field.
> 
> Like in the patch below.

Yep, thanks.

> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Since we already pass the address of restore_registers() in the image header,
> we can also pass the value of the CR3 register from before the hibernation in
> the same way.  This will allow us to avoid using init_level4_pgt page tables
> during the restore.

ACK.

> @@ -9,6 +9,7 @@
>  
>  #include <linux/smp.h>
>  #include <linux/suspend.h>
> +#include <linux/crc32.h>
>  #include <asm/proto.h>
>  #include <asm/page.h>
>  #include <asm/pgtable.h>

This one is no longer neccessary.


									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
