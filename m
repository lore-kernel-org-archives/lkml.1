Return-Path: <linux-kernel-owner+w=401wt.eu-S1758272AbZEFJU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758272AbZEFJU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 05:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753614AbZEFJUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 05:20:20 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:43969 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbZEFJUT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 05:20:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NHSytnWoSLHvIcrn/IDPi66Ys2pfrBS+EKmjhvvjLZH1/PsIEOCgLRR3u56G7oWUhW
         cDQbEioN3tT3qDJwcTzhuSCJcskoWb/Lt5oFEwDM+X3nrrjBvWiufiyL3y3TD7fTQ++6
         e88SZ6iMwqmHVYRJFvLvTehlP+V5Ni7NR8Sx0=
MIME-Version: 1.0
In-Reply-To: <4A014BA9.9020201@cn.fujitsu.com>
References: <20090506081221.GA15317@damson.getinternet.no>
	 <4A0149FD.3010008@cn.fujitsu.com> <4A014BA9.9020201@cn.fujitsu.com>
Date: Wed, 6 May 2009 11:20:17 +0200
Message-ID: <19f34abd0905060220l2dc241b2j45e4bd127bacade3@mail.gmail.com>
Subject: Re: printk %0*X is broken.
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yinghai@kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/6 Li Zefan <lizf@cn.fujitsu.com>:
>> Vegard Nossum wrote:
>>> 2009/5/6 Ingo Molnar <mingo@elte.hu>:
>>>> Cc:-ed more folks who modified lib/vsprintf.c recently.
>>>>
>>>>        Ingo
>>>>
>>>> * Yinghai Lu <yinghai@kernel.org> wrote:
>>>>
>>>>> it seems someone broke
>>>>>
>>>>> printk(   "%0*X\n", width, x);
>>>>>
>>>>> looks like 0 is dumped.
>>> After %, we look for flags. The problem is that when a flag is found, we
>>> don't advance in the format string. And thus we start looking for the
>>> precision, which is read as 0, because we are still at the 0. I think
>>> this patch should fix it.
>>>
>
> No, we break out of the while loop when we can't find a flag,
> So we are at '*' after we found '0'.

> Lai Jiangshan wrote:
>> It seems that your patch does not change anything.
>> The code logic is still the same as before.

Oh really? So sorry, I didn't look close enough :-(


Vegard
