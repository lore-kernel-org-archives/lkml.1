Return-Path: <linux-kernel-owner+w=401wt.eu-S932241AbYBMSWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932241AbYBMSWT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 13:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753539AbYBMSWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 13:22:10 -0500
Received: from hu-out-0506.google.com ([72.14.214.233]:30670 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbYBMSWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 13:22:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=VrpAqEjn4aapYQzN0HgzTf1brnh6NfwDJuWmvI75tjy4Tkh52APfIDitzflWTaCt0kYMX41qHQVc4pw7isZEapAoad1y+dAfyUxSrfDvdvTF2QnzYlPX/0cw5Dq+yI+82DwF88vaBtQPiMFko7YeGSU9YUamUqK9CwZaBPE7QPg=
Date: Wed, 13 Feb 2008 19:21:21 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Evgeniy Dushistov <dushistov@mail.ru>
Subject: Re: [PATCH] ufs: [bl]e*_add_cpu conversion
Message-ID: <20080213182116.GA6150@joi>
References: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com> <1202857582-15450-18-git-send-email-marcin.slusarz@gmail.com> <47B2BB58.5040401@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B2BB58.5040401@tiscali.nl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 10:41:44AM +0100, Roel Kluin wrote:
> marcin.slusarz@gmail.com wrote:
> > replace all:
> > big/little_endian_variable = cpu_to_[bl]eX([bl]eX_to_cpu(big/little_endian_variable) +
> > 					expression_in_cpu_byteorder);
> > with:
> > 	[bl]eX_add_cpu(&big/little_endian_variable, expression_in_cpu_byteorder);
> 
> you may also want these:
> ---
> [bl]e_add_cpu conversion in return
> 
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Acked-by: Marcin Slusarz <marcin.slusarz@gmail.com>

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
> 
