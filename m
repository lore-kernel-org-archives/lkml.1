Return-Path: <linux-kernel-owner+w=401wt.eu-S934164AbZHHNAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934164AbZHHNAy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 09:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934145AbZHHNAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 09:00:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:55085 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934144AbZHHNAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 09:00:53 -0400
Message-ID: <4A7D7729.50502@online.de>
Date: Sat, 08 Aug 2009 15:01:29 +0200
From: Alexander Koeppe <format_c@online.de>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: roel.kluin@gmail.com
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fat: Read buffer overflow
References: <d6Gqb-2HX-3@gated-at.bofh.it>
In-Reply-To: <d6Gqb-2HX-3@gated-at.bofh.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX187kJdDwhqLDgjQEiKg4UrgPJXAHD6kvr8GJe+
 2yafxyQmz83by3VVOQ3Pv9HMRkjxQszGr8qESIJY0hT/GzCS/h
 +uU6AD+Hcx3ExkOWMlBEQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin schrieb:
> If len is less or equal to 0, this results in a read of s[-1].
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
> index 6f27853..114ff6d 100644
> --- a/fs/fat/namei_vfat.c
> +++ b/fs/fat/namei_vfat.c
> @@ -202,6 +202,9 @@ static inline int vfat_is_used_badchars(const wchar_t *s, int len)
>  {
>  	int i;
>  
> +	if (len <= 0)
> +		return -EINVAL;
> +
>  	for (i = 0; i < len; i++)
>  		if (vfat_bad_char(s[i]))
>  			return -EINVAL;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

This seem to be a bit redundant code.
If len is 0 or less, the loop won't iterate even one time and hence
not read outside the buffer.
The only advantage is, that re function signals the invalid argument.

-- A.Koeppe
