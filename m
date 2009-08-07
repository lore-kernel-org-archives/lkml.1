Return-Path: <linux-kernel-owner+w=401wt.eu-S1756325AbZHGXGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325AbZHGXGZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 19:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755352AbZHGXGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 19:06:25 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:56300 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168AbZHGXGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 19:06:24 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fat: Read buffer overflow
References: <4A7CAF28.8020908@gmail.com>
Date: Sat, 08 Aug 2009 08:06:22 +0900
In-Reply-To: <4A7CAF28.8020908@gmail.com> (Roel Kluin's message of "Sat, 08
	Aug 2009 00:48:08 +0200")
Message-ID: <87y6pvi5qp.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin <roel.kluin@gmail.com> writes:

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

Um..., what case is this possible? vfat_add_entry() checks (len == 0).
And if xlate_to_uni() couldn't convert name, it should return the error.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
