Return-Path: <linux-kernel-owner+w=401wt.eu-S1752890Ab0AZKGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab0AZKGH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 05:06:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642Ab0AZKGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 05:06:06 -0500
Received: from smtp.nokia.com ([192.100.122.230]:50965 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560Ab0AZKGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 05:06:05 -0500
Subject: Re: UBIFS assert failed in ubifs_dirty_inode
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Matt Mackall <mpm@selenic.com>
Cc: Jeff Angielski <jeff@theptrgroup.com>, linux-mtd@lists.infradead.org,
       LKML <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.apana.org.au>
In-Reply-To: <1264484928.3536.1017.camel@calx>
References: <4B591573.60602@theptrgroup.com>
	 <1264480808.2401.78.camel@localhost.localdomain>
	 <1264484928.3536.1017.camel@calx>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Jan 2010 12:03:34 +0200
Message-ID: <1264500214.3867.21.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 26 Jan 2010 10:03:51.0054 (UTC) FILETIME=[DC25DAE0:01CA9E6E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-01-25 at 23:48 -0600, Matt Mackall wrote:
> Hmm. I'd just as soon drop it entirely. Here's a patch. Herbert, you
> want to send this through your crypto tree?
> 
> 
> random: drop weird m_time/a_time manipulation
> 
> No other driver does anything remotely like this that I know of except
> for the tty drivers, and I can't see any reason for random/urandom to do
> it. In fact, it's a (trivial, harmless) timing information leak. And
> obviously, it generates power- and flash-cycle wasting I/O, especially
> if combined with something like hwrngd. Also, it breaks ubifs's
> expectations.
> 
> Signed-off-by: Matt Mackall <mpm@selenic.com>
> 
> diff -r 29db0c391ce8 drivers/char/random.c
> --- a/drivers/char/random.c	Sun Jan 17 11:01:16 2010 -0800
> +++ b/drivers/char/random.c	Mon Jan 25 23:32:00 2010 -0600
> @@ -1051,12 +1051,6 @@
>  				/* like a named pipe */
>  	}
>  
> -	/*
> -	 * If we gave the user some bytes, update the access time.
> -	 */
> -	if (count)
> -		file_accessed(file);
> -
>  	return (count ? count : retval);
>  }
>  
> @@ -1116,8 +1110,6 @@
>  	if (ret)
>  		return ret;
>  
> -	inode->i_mtime = current_fs_time(inode->i_sb);
> -	mark_inode_dirty(inode);
>  	return (ssize_t)count;
>  }

It may brake other FSes expectations, theoretically, as well.

Anyway, I'm perfectly fine if this is removed.

Jeff, could you please try Matt's patch and report back if you still
have issues or not. If no, you can use this as a temporary work-around
until a proper fix hits upstream or ubifs-2.6.git.

Thanks!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

