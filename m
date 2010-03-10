Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429Ab0CJXTI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 18:19:08 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:46284 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754438Ab0CJXTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 18:19:06 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] fs: fat: use hex_asc_lo/hex_asc_hi instead of custom one
References: <1268261495-686-1-git-send-email-andy.shevchenko@gmail.com>
	<1268261495-686-2-git-send-email-andy.shevchenko@gmail.com>
	<1268261495-686-3-git-send-email-andy.shevchenko@gmail.com>
	<1268261495-686-4-git-send-email-andy.shevchenko@gmail.com>
	<1268261495-686-5-git-send-email-andy.shevchenko@gmail.com>
Date: Thu, 11 Mar 2010 08:18:59 +0900
In-Reply-To: <1268261495-686-5-git-send-email-andy.shevchenko@gmail.com> (Andy
	Shevchenko's message of "Thu, 11 Mar 2010 00:51:34 +0200")
Message-ID: <87aaufvk7w.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Shevchenko <andy.shevchenko@gmail.com> writes:

>  			if (uni_xlate == 1) {
> -				*op = ':';
> -				for (k = 4; k > 0; k--) {
> -					nc = ec & 0xF;
> -					op[k] = nc > 9	? nc + ('a' - 10)
> -							: nc + '0';
> -					ec >>= 4;
> -				}
> -				op += 5;
> +				*op++ = ':';
> +				*op++ = hex_asc_hi(ec >> 8);
> +				*op++ = hex_asc_lo(ec >> 8);
> +				*op++ = hex_asc_hi(ec);
> +				*op++ = hex_asc_lo(ec);
>  				len -= 5;

Why doesn't this use pack_hex_byte()?

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
