Return-Path: <linux-kernel-owner+w=401wt.eu-S1755270AbYBPF3E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbYBPF3E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 00:29:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750998AbYBPF2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 00:28:55 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36100 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750828AbYBPF2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 00:28:54 -0500
Date: Fri, 15 Feb 2008 21:28:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: marcin.slusarz@gmail.com, LKML <linux-kernel@vger.kernel.org>,
       Evgeniy Dushistov <dushistov@mail.ru>
Subject: Re: [PATCH] ufs: [bl]e*_add_cpu conversion
Message-Id: <20080215212815.26117a19.akpm@linux-foundation.org>
In-Reply-To: <47B2BB58.5040401@tiscali.nl>
References: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com>
	<1202857582-15450-18-git-send-email-marcin.slusarz@gmail.com>
	<47B2BB58.5040401@tiscali.nl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008 10:41:44 +0100 Roel Kluin <12o3l@tiscali.nl> wrote:

> you may also want these:
> ---
> [bl]e_add_cpu conversion in return
> 
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> ---
> diff --git a/fs/ufs/swab.h b/fs/ufs/swab.h
> index 1683d2b..a1e3000 100644
> --- a/fs/ufs/swab.h
> +++ b/fs/ufs/swab.h
> @@ -44,18 +44,22 @@ static __inline u32
>  fs64_add(struct super_block *sbp, u32 *n, int d)
>  {
>  	if (UFS_SB(sbp)->s_bytesex == BYTESEX_LE)
> -		return *n = cpu_to_le64(le64_to_cpu(*n)+d);
> +		le64_add_cpu(n, d);
>  	else
> -		return *n = cpu_to_be64(be64_to_cpu(*n)+d);
> +		be64_add_cpu(n, d);
> +
> +	return *n;
>  }
>  
>  static __inline u32
>  fs64_sub(struct super_block *sbp, u32 *n, int d)
>  {
>  	if (UFS_SB(sbp)->s_bytesex == BYTESEX_LE)
> -		return *n = cpu_to_le64(le64_to_cpu(*n)-d);
> +		le64_add_cpu(n, -d);
>  	else
> -		return *n = cpu_to_be64(be64_to_cpu(*n)-d);
> +		be64_add_cpu(n, -d);
> +
> +	return *n;
>  }
>  
>  static __inline u32

upsets powerpc (at least):

fs/ufs/swab.h: In function `fs64_add':
fs/ufs/swab.h:47: warning: passing arg 1 of `le64_add_cpu' from incompatible pointer type
fs/ufs/swab.h:49: warning: passing arg 1 of `be64_add_cpu' from incompatible pointer type
fs/ufs/swab.h: In function `fs64_sub':
fs/ufs/swab.h:58: warning: passing arg 1 of `le64_add_cpu' from incompatible pointer type
fs/ufs/swab.h:60: warning: passing arg 1 of `be64_add_cpu' from incompatible pointer type
