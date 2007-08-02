Return-Path: <linux-kernel-owner+w=401wt.eu-S1759466AbXHBR4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759466AbXHBR4S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 13:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758513AbXHBR4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 13:56:10 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:49773 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758493AbXHBR4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 13:56:08 -0400
Date: Thu, 2 Aug 2007 19:55:18 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH][Fix] Hibernation: Do not try to mark invalid PFNs as nosave
Message-ID: <20070802175518.GA22547@elf.ucw.cz>
References: <200708021918.52283.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708021918.52283.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> [Please consider as 2.6.23 material.]
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> On some systems some PFNs reported by the early initialization code as 'nosave'
> may be invalid.  If we try to set the corresponding bits in the hibernation
> bitmap, BUG_ON() in memory_bm_find_bit() will be triggered and the system
> won't be able to boot  (cf. https://bugzilla.novell.com/show_bug.cgi?id=296242).
> 
> Prevent this from happening by verifying if the 'nosave' PFNs are valid in
> mark_nosave_pages().
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK.

> @@ -709,7 +709,8 @@ static void mark_nosave_pages(struct mem
>  				region->end_pfn << PAGE_SHIFT);
>  
>  		for (pfn = region->start_pfn; pfn < region->end_pfn; pfn++)
> -			memory_bm_set_bit(bm, pfn);
> +			if (pfn_valid(pfn))
> +				memory_bm_set_bit(bm, pfn);
>  	}
>  }
>  

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
