Return-Path: <linux-kernel-owner+w=401wt.eu-S1755247AbYCKDTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247AbYCKDTI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 23:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751415AbYCKDSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 23:18:55 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49256 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbYCKDSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 23:18:47 -0400
Date: Tue, 11 Mar 2008 12:17:27 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Dave Young <hidave.darkstar@gmail.com>
Subject: Re: [PATCH v3] Add time_is_after_jiffies and others which compare with jiffies
Cc: kosaki.motohiro@jp.fujitsu.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, hannes@saeurebad.de,
       alan@lxorguk.ukuu.org.uk
In-Reply-To: <20080310012202.GA2958@darkstar.te-china.tietoenator.com>
References: <20080310012202.GA2958@darkstar.te-china.tietoenator.com>
Message-Id: <20080311121553.6214.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Why don't you make jiffies_64 stuff?



> Most of time_after like macros usages just compare jiffies and
> another number, so here add some time_is_* macros for convenience.
> 
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
> 
> ---
> include/linux/jiffies.h |   16 ++++++++++++++++
> 1 file changed, 16 insertions(+)
> 
> diff -upr linux/include/linux/jiffies.h linux.new/include/linux/jiffies.h
> --- linux/include/linux/jiffies.h	2008-03-07 10:40:04.000000000 +0800
> +++ linux.new/include/linux/jiffies.h	2008-03-10 09:11:36.000000000 +0800
> @@ -135,6 +135,22 @@ static inline u64 get_jiffies_64(void)
>  #define time_before_eq64(a,b)	time_after_eq64(b,a)
>  
>  /*
> + * These four macros compare jiffies and 'a' for convenience.
> + */
> +
> +/* time_is_before_jiffies(a) return true if a is before jiffies */
> +#define time_is_before_jiffies(a) time_after(jiffies, a)
> +
> +/* time_is_after_jiffies(a) return true if a is after jiffies */
> +#define time_is_after_jiffies(a) time_before(jiffies, a)
> +
> +/* time_is_before_eq_jiffies(a) return true if a is before or equal to jiffies*/
> +#define time_is_before_eq_jiffies(a) time_after_eq(jiffies, a)
> +
> +/* time_is_after_eq_jiffies(a) return true if a is after or equal to jiffies*/
> +#define time_is_after_eq_jiffies(a) time_before_eq(jiffies, a)
> +
> +/*
>   * Have the 32 bit jiffies value wrap 5 minutes after boot
>   * so jiffies wrap bugs show up earlier.
>   */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


