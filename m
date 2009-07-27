Return-Path: <linux-kernel-owner+w=401wt.eu-S1755860AbZG0DS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860AbZG0DS0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 23:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755587AbZG0DS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 23:18:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56754 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755412AbZG0DSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 23:18:25 -0400
Message-ID: <4A6D1D26.10909@cn.fujitsu.com>
Date: Mon, 27 Jul 2009 11:21:10 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
CC: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH v3 2/2] Use common localtime/gmtime in fat_time_unix2fat()
References: <4A5C3BC0.6020701@cn.fujitsu.com>	<20090714151040.b7b3b26d.akpm@linux-foundation.org>	<20090718115019.GH1433@ucw.cz>	<04e101ca08e5$be078fa0$808410ac@zhaoleiwin>	<20090719202018.497f7ec1.akpm@linux-foundation.org>	<4A643EFE.7090103@cn.fujitsu.com> <4A643F82.5020108@cn.fujitsu.com> <87k51xmi5y.fsf@devron.myhome.or.jp>
In-Reply-To: <87k51xmi5y.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi wrote:
> Zhaolei <zhaolei@cn.fujitsu.com> writes:
> 
>> +	if (sbi->options.tz_utc) {
>> +		gmtime_r(ts->tv_sec, &tm);
>> +	} else {
>> +		localtime_r(ts->tv_sec, &tm);
>> +	}
> 
> Missing error check.
> 
>> -	/* Jan 1 GMT 00:00:00 1980. But what about another time zone? */
>> -	if (second < UNIX_SECS_1980) {
>> +	/*  FAT can only support year between 1980 to 2107 */
>> +	if (tm.tm_year < 1980 - 1900) {
>>  		*time = 0;
>>  		*date = cpu_to_le16((0 << 9) | (1 << 5) | 1);
>>  		if (time_cs)
>>  			*time_cs = 0;
>>  		return;
>>  	}
>> -#if BITS_PER_LONG == 64
>> -	if (second >= UNIX_SECS_2108) {
>> +	if (tm.tm_year > 2107 - 1900) {
>>  		*time = cpu_to_le16((23 << 11) | (59 << 5) | 29);
>>  		*date = cpu_to_le16((127 << 9) | (12 << 5) | 31);
>>  		if (time_cs)
>>  			*time_cs = 199;
>>  		return;
>>  	}
>> -#endif
> 
> I think tm.tm_year is undefine in case of the error.

Hello, Ogawa-san:

Thanks for your review.
I'll fix them

Thanks
Zhaolei


