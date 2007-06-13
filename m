Return-Path: <linux-kernel-owner+w=401wt.eu-S1751541AbXFMURL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541AbXFMURL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 16:17:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754815AbXFMUQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 16:16:44 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2813 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752728AbXFMUQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 16:16:41 -0400
Date: Wed, 13 Jun 2007 19:47:27 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Shani Moideen <shani.moideen@wipro.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       kernel-janitors@lists.osdl.org
Subject: Re: [KJ PATCH] Replacing memcpy(dest,src,PAGE_SIZE) with copy_page(dest,src) in arch/i386/mm/init.c
Message-ID: <20070613194726.GB8273@ucw.cz>
References: <1181618174.2282.16.camel@shani-win>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181618174.2282.16.camel@shani-win>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2007-06-12 08:46:14, Shani Moideen wrote:
> Hi,
> Replacing memcpy(dest,src,PAGE_SIZE) with copy_page(dest,src) in arch/i386/mm/init.c.
> 
> Signed-off-by: Shani Moideen <shani.moideen@wipro.com>
> ----
> 
> 
> diff --git a/arch/i386/mm/init.c b/arch/i386/mm/init.c
> index ae43688..7dc3d46 100644
> --- a/arch/i386/mm/init.c
> +++ b/arch/i386/mm/init.c
> @@ -397,7 +397,7 @@ char __nosavedata swsusp_pg_dir[PAGE_SIZE]
>  
>  static inline void save_pg_dir(void)
>  {
> -	memcpy(swsusp_pg_dir, swapper_pg_dir, PAGE_SIZE);
> +	copy_page(swsusp_pg_dir, swapper_pg_dir);
>  }
>  #else
>  static inline void save_pg_dir(void)


ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
