Return-Path: <linux-kernel-owner+w=401wt.eu-S1756252AbZKBSNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252AbZKBSNu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 13:13:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755990AbZKBSNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 13:13:49 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:52650 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755724AbZKBSNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 13:13:49 -0500
From: Andreas Schwab <schwab@linux-m68k.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: =?utf-8?Q?Andr=C3=A9?= Goddard Rosa <andre.goddard@gmail.com>,
       laijs@cn.fujitsu.com, mingo@elte.hu, davem@davemloft.net,
       akpm@linux-foundation.org, harvey.harrison@gmail.com,
       linux list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vsprintf: reduce code size, clean up
References: <b8bf37780911010901i3426f143ve394ae569be74ec1@mail.gmail.com>
	<20091101224547.GB5263@nowhere>
X-Yow: Yow!  Are we in the perfect mood?
Date: Mon, 02 Nov 2009 19:13:47 +0100
In-Reply-To: <20091101224547.GB5263@nowhere> (Frederic Weisbecker's message of
	"Sun, 1 Nov 2009 23:45:49 +0100")
Message-ID: <m2ocnkdcbo.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker <fweisbec@gmail.com> writes:

> On Sun, Nov 01, 2009 at 03:01:40PM -0200, André Goddard Rosa wrote:
>> @@ -822,30 +825,34 @@ static char *pointer(const char *fmt, char *buf,
>> char *end, void *ptr,
>>  			struct printf_spec spec)
>>  {
>>  	if (!ptr)
>> -		return string(buf, end, "(null)", spec);
>> +		return string(buf, end, null, spec);
>> 
>> -	switch (*fmt) {
>> -	case 'F':
>> +	switch (TOLOWER(*fmt)) {
>>  	case 'f':
>> +	/* or case 'F' */
>>  		ptr = dereference_function_descriptor(ptr);
>> -	case 's':
>>  		/* Fallthrough */
>> -	case 'S':
>> +	case 's':
>> +	/* or case 'S' */
>>  		return symbol_string(buf, end, ptr, spec, *fmt);
>>  	case 'R':
>>  		return resource_string(buf, end, ptr, spec);
>
>
>
> What happens if we have %pr ?
> It will behave like %pR but it shouldn't.

%pR does not work any more anyway. :-)

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
