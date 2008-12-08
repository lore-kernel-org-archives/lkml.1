Return-Path: <linux-kernel-owner+w=401wt.eu-S1751773AbYLHH1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773AbYLHH1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 02:27:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750800AbYLHH1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 02:27:10 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:44439 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbYLHH1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 02:27:09 -0500
Date: Mon, 8 Dec 2008 08:26:58 +0100
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH -suspend] Hibernate: Replace unnecessary evaluation of
	pfn_to_page()
Message-ID: <20081208072657.GA2418@ucw.cz>
References: <200812080052.49604.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812080052.49604.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-12-08 00:52:49, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: Hibernate: Replace unnecessary evaluation of pfn_to_page()
> 
> Replace one evaluation of pfn_to_page() in copy_data_pages() with
> the value of a local variable containing the right number already.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Acked-by: Pavel Machek <pavel@suse.cz>

> ---
>  kernel/power/snapshot.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6/kernel/power/snapshot.c
> ===================================================================
> --- linux-2.6.orig/kernel/power/snapshot.c
> +++ linux-2.6/kernel/power/snapshot.c
> @@ -981,7 +981,7 @@ static void copy_data_page(unsigned long
>  			 * data modified by kmap_atomic()
>  			 */
>  			safe_copy_page(buffer, s_page);
> -			dst = kmap_atomic(pfn_to_page(dst_pfn), KM_USER0);
> +			dst = kmap_atomic(d_page, KM_USER0);
>  			memcpy(dst, buffer, PAGE_SIZE);
>  			kunmap_atomic(dst, KM_USER0);
>  		} else {

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
