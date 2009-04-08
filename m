Return-Path: <linux-kernel-owner+w=401wt.eu-S1757234AbZDHOmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234AbZDHOmj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 10:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752493AbZDHOm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 10:42:28 -0400
Received: from mx.sz.bfs.de ([194.94.69.70]:45431 "EHLO mx.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752477AbZDHOm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 10:42:27 -0400
X-Greylist: delayed 1352 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Apr 2009 10:42:27 EDT
Message-ID: <49DCB26C.3070709@bfs.de>
Date: Wed, 08 Apr 2009 16:19:24 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Bert Wesarg <bert.wesarg@googlemail.com>
Cc: Jack Stone <jwjstone@fastmail.fm>, linux-kernel@vger.kernel.org,
       jeff@garzik.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 20/56] inflate: Remove void casts
References: <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-13-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-14-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-15-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-16-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-17-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-18-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-19-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-20-git-send-email-jwjstone@fastmail.fm>	 <1239189748-11703-21-git-send-email-jwjstone@fastmail.fm> <36ca99e90904080439u7098d2feka5dd39f8ab6a470c@mail.gmail.com>
In-Reply-To: <36ca99e90904080439u7098d2feka5dd39f8ab6a470c@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Bert Wesarg schrieb:
> On Wed, Apr 8, 2009 at 13:21, Jack Stone <jwjstone@fastmail.fm> wrote:
>> Remove uneeded void casts
>>
>> Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
>> ---
>>  lib/inflate.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/lib/inflate.c b/lib/inflate.c
>> index 1a8e8a9..4b672f9 100644
>> --- a/lib/inflate.c
>> +++ b/lib/inflate.c
>> @@ -249,7 +249,7 @@ static void *malloc(int size)
>>
>>        malloc_ptr = (malloc_ptr + 3) & ~3;     /* Align */
>>
>> -       p = (void *)malloc_ptr;
>> +       p = malloc_ptr;
>>        malloc_ptr += size;
>>
>>        if (free_mem_end_ptr && malloc_ptr >= free_mem_end_ptr)
>> @@ -481,7 +481,7 @@ DEBG1("3 ");
>>         z = 1 << j;             /* table entries for j-bit table */
>>
>>         /* allocate and link in new table */
>> -        if ((q = (struct huft *)malloc((z + 1)*sizeof(struct huft))) ==
>> +        if ((q = malloc((z + 1)*sizeof(struct huft))) ==
>>             (struct huft *)NULL)
> Thats an unneeded cast too. (After that, the NULL can move up one line.)
> 
> Bert
>>         {
>>           if (h)

and move the q= from the if. less than half the size.

q = malloc( (z + 1)*sizeof(*q) ):
if ( q == NULL )

re,
 wh





