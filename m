Return-Path: <linux-kernel-owner+w=401wt.eu-S933030AbXDKF6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933030AbXDKF6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 01:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933020AbXDKF6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 01:58:44 -0400
Received: from smtp.osdl.org ([65.172.181.24]:60815 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932526AbXDKF6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 01:58:43 -0400
Date: Tue, 10 Apr 2007 22:58:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nate Diller <nate.diller@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 13/13] fs: deprecate memclear_highpage_flush
Message-Id: <20070410225838.5e6ed364.akpm@linux-foundation.org>
In-Reply-To: <20070411033600.11000.89714.patchbomb.py@localhost>
References: <20070411033600.11000.38285.patchbomb.py@localhost>
	<20070411033600.11000.89714.patchbomb.py@localhost>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Apr 2007 20:36:00 -0700 Nate Diller <nate.diller@gmail.com> wrote:

> Now that all the in-tree users are converted over to zero_user_page(),
> deprecate the old memclear_highpage_flush() call.
> 
> Signed-off-by: Nate Diller <nate.diller@gmail.com>
> 
> ---
> 
> diff -urpN -X dontdiff linux-2.6.21-rc6-mm1/include/linux/highmem.h linux-2.6.21-rc6-mm1-test/include/linux/highmem.h
> --- linux-2.6.21-rc6-mm1/include/linux/highmem.h	2007-04-10 18:32:41.000000000 -0700
> +++ linux-2.6.21-rc6-mm1-test/include/linux/highmem.h	2007-04-10 19:40:14.000000000 -0700
> @@ -149,6 +149,8 @@ static inline void zero_user_page(struct
>  	kunmap_atomic(kaddr, KM_USER0);
>  }
>  
> +static void memclear_highpage_flush(struct page *page, unsigned int offset,
> +					unsigned int size) __deprecated;
>  static inline void memclear_highpage_flush(struct page *page, unsigned int offset, unsigned int size)
>  {
>  	return zero_user_page(page, offset, size);

oh, there it is.

one can stick the __deprecated at the end of the definition, actually.
