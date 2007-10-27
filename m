Return-Path: <linux-kernel-owner+w=401wt.eu-S1756841AbXJ1SM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841AbXJ1SM1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 14:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbXJ1SL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 14:11:56 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4533 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752096AbXJ1SLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 14:11:55 -0400
Date: Sat, 27 Oct 2007 07:31:40 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Matthew Wilcox <matthew@wil.cx>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 1/4] stringbuf: A string buffer implementation
Message-ID: <20071027073140.GB6043@ucw.cz>
References: <1193173966-3550-1-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193173966-3550-1-git-send-email-matthew@wil.cx>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2007-10-23 17:12:43, Matthew Wilcox wrote:
> Consecutive calls to printk are non-atomic, which leads to various
> implementations for accumulating strings which can be printed in one call.
> This is a generic string buffer which can also be used for non-printk
> purposes.  There is no sb_scanf implementation yet as I haven't identified
> a user for it.

GFP_ATOMIC alloca5tion there is bad news. It can randomly fail.....
without good method of handling that in caller.
							Pavel
> +/*
> + * Convert the stringbuf to a string.  It is the caller's responsibility
> + * to free the string.  The stringbuf is then ready to be reused.
> + */
> +static inline char *sb_to_string(struct stringbuf *sb)
> +{
> +	char *s = sb->s;
> +	if (sb_error(sb))
> +		s = kstrdup(s, GFP_ATOMIC);
> +	sb_init(sb);
> +	return s;
> +}

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
