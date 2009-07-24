Return-Path: <linux-kernel-owner+w=401wt.eu-S1753493AbZGXXtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbZGXXtO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 19:49:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444AbZGXXtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 19:49:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50516 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751324AbZGXXtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 19:49:13 -0400
Date: Fri, 24 Jul 2009 16:49:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Zhaolei <zhaolei@cn.fujitsu.com>
Subject: Re: [PATCH] smbfs: Read buffer overflow
Message-Id: <20090724164909.b3f6cf2b.akpm@linux-foundation.org>
In-Reply-To: <4A688661.9040506@gmail.com>
References: <4A688661.9040506@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jul 2009 17:48:49 +0200
Roel Kluin <roel.kluin@gmail.com> wrote:

> This function uses signed integers for the unix_date and local variables - if a
> negative number is supplied and the leap-year condition is not met, month
> will be 0, leading to a read of day_n[-1]
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> This is the easiest way to prevent the buffer overflow, but it produces a date.
> Maybe a magic date would be better? What should we choose?
> 
> Credits to Parfait and Nathan Keynes,
> 
> diff --git a/fs/smbfs/proc.c b/fs/smbfs/proc.c
> index 9468168..71c29b6 100644
> --- a/fs/smbfs/proc.c
> +++ b/fs/smbfs/proc.c
> @@ -509,7 +509,7 @@ date_unix2dos(struct smb_sb_info *server,
>  		month = 2;
>  	} else {
>  		nl_day = (year & 3) || day <= 59 ? day : day - 1;
> -		for (month = 0; month < 12; month++)
> +		for (month = 1; month < 12; month++)
>  			if (day_n[month] > nl_day)
>  				break;
>  	}

Again, fixable by switching to the kernel/time/timeconv.c functions.
