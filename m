Return-Path: <linux-kernel-owner+w=401wt.eu-S1754455AbZLNBIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455AbZLNBIY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 20:08:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752843AbZLNBIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 20:08:24 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49738 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751966AbZLNBIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 20:08:23 -0500
Message-ID: <4B258FF2.3070600@cn.fujitsu.com>
Date: Mon, 14 Dec 2009 09:08:02 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Wenji Huang <wenji.huang@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] tracing/filters: Fix MATCH_EBD_ONLY filter matching
References: <4B2217D0.5000308@cn.fujitsu.com>	 <4B22180E.6090907@cn.fujitsu.com> <1260544458.2146.362.camel@gandalf.stny.rr.com>
In-Reply-To: <1260544458.2146.362.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>  static int regex_match_end(char *str, struct regex *r, int len)
>>  {
>> -	char *ptr = strstr(str, r->pattern);
>> +	int strlen = len - 1;
>>  
>> -	if (ptr && (ptr[r->len] == 0))
>> +	if (strlen >= r->len &&
>> +	    !memcmp(str + strlen - r->len, r->pattern, r->len))
> 
> Please use memcmp() == 0, I've seen too many bugs with !*cmp as well as
> with *cmp, because humans tend to think instinctively when reading this
> that ! is not a match. With "== 0" we think that "==" is a match and
>  "!=" is a miss.
> 

Though I sometimes don't care much about this, I do
think memcmp() == 0 is better.

