Return-Path: <linux-kernel-owner+w=401wt.eu-S1752224AbZGYJlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224AbZGYJlA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 05:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751775AbZGYJk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 05:40:59 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:40027 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbZGYJk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 05:40:59 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] Use common localtime/gmtime in fat_time_unix2fat()
References: <4A5C3BC0.6020701@cn.fujitsu.com>
	<20090714151040.b7b3b26d.akpm@linux-foundation.org>
	<20090718115019.GH1433@ucw.cz>
	<04e101ca08e5$be078fa0$808410ac@zhaoleiwin>
	<20090719202018.497f7ec1.akpm@linux-foundation.org>
	<4A643EFE.7090103@cn.fujitsu.com> <4A643F82.5020108@cn.fujitsu.com>
Date: Sat, 25 Jul 2009 14:43:37 +0900
In-Reply-To: <4A643F82.5020108@cn.fujitsu.com> (zhaolei@cn.fujitsu.com's
	message of "Mon, 20 Jul 2009 17:57:22 +0800")
Message-ID: <87k51xmi5y.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhaolei <zhaolei@cn.fujitsu.com> writes:

> +	if (sbi->options.tz_utc) {
> +		gmtime_r(ts->tv_sec, &tm);
> +	} else {
> +		localtime_r(ts->tv_sec, &tm);
> +	}

Missing error check.

> -	/* Jan 1 GMT 00:00:00 1980. But what about another time zone? */
> -	if (second < UNIX_SECS_1980) {
> +	/*  FAT can only support year between 1980 to 2107 */
> +	if (tm.tm_year < 1980 - 1900) {
>  		*time = 0;
>  		*date = cpu_to_le16((0 << 9) | (1 << 5) | 1);
>  		if (time_cs)
>  			*time_cs = 0;
>  		return;
>  	}
> -#if BITS_PER_LONG == 64
> -	if (second >= UNIX_SECS_2108) {
> +	if (tm.tm_year > 2107 - 1900) {
>  		*time = cpu_to_le16((23 << 11) | (59 << 5) | 29);
>  		*date = cpu_to_le16((127 << 9) | (12 << 5) | 31);
>  		if (time_cs)
>  			*time_cs = 199;
>  		return;
>  	}
> -#endif

I think tm.tm_year is undefine in case of the error.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
