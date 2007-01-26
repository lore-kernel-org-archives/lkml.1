Return-Path: <linux-kernel-owner+w=401wt.eu-S1161157AbXAZSnf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161157AbXAZSnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 13:43:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161165AbXAZSnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 13:43:35 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:52610 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161157AbXAZSne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 13:43:34 -0500
Date: Fri, 26 Jan 2007 19:43:06 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Christoph Lameter <clameter@sgi.com>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: mm snapshot broken-out-2007-01-26-00-36.tar.gz uploaded
Message-ID: <20070126184306.GC964@elf.ucw.cz>
References: <200701260837.l0Q8blBr011622@shell0.pdx.osdl.net> <45BA42B9.7020203@googlemail.com> <6bffcb0e0701261008u2fd5a7d9va16d7fd9f250e14b@mail.gmail.com> <Pine.LNX.4.64.0701261035430.7848@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0701261035430.7848@schroedinger.engr.sgi.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> but I would think that this would fix the compile errors that are my 
> responsibility (sort of .... patch was against rc6 and not against mm).
> More when I track down the above issue:

...

> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> 
> Index: linux-2.6.20-rc6/kernel/power/swsusp.c
> ===================================================================
> --- linux-2.6.20-rc6.orig/kernel/power/swsusp.c	2007-01-26 10:32:05.000000000 -0800
> +++ linux-2.6.20-rc6/kernel/power/swsusp.c	2007-01-26 10:32:24.000000000 -0800
> @@ -230,7 +230,8 @@ int swsusp_shrink_memory(void)
>  		for_each_zone (zone)
>  			if (populated_zone(zone)) {
>  				if (is_highmem(zone)) {
> -					highmem_size -= zone->free_pages;
> +					highmem_size -=
> +					zone_page_state(zone, NR_FREE_PAGES);
>  				} else {
>  					tmp -= zone->free_pages;

Does last line need similar conversion, too?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
