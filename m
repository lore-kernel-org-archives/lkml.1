Return-Path: <linux-kernel-owner+w=401wt.eu-S1754124AbZLNBEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbZLNBEd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 20:04:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752371AbZLNBEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 20:04:32 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54451 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751966AbZLNBEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 20:04:32 -0500
Message-ID: <4B258F0A.3030903@cn.fujitsu.com>
Date: Mon, 14 Dec 2009 09:04:10 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Riss <frederic.riss@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Wenji Huang <wenji.huang@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] ftrace: Fix MATCH_END_ONLY filter matching
References: <4B2217D0.5000308@cn.fujitsu.com> <87d3b2040912110420w270cff7ew36a7f2389a88fdb9@mail.gmail.com> <20091211122721.GH5244@nowhere> <1260544231.2146.360.camel@gandalf.stny.rr.com> <20091211174632.GC5094@nowhere>
In-Reply-To: <20091211174632.GC5094@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> For '*foo' pattern, we should allow any string ending with
>>>>> 'foo', but ftrace filter incorrectly disallows strings
>>>>> like bar_foo_foo:
>>>> [...]
>>>>>        case MATCH_END_ONLY:
>>>>> -               ptr = strstr(str, regex);
>>>>> -               if (ptr && (ptr[len] == 0))
>>>>> +               slen = strlen(str);
>>>>> +               if (slen >= len && memcpy(str + slen - len, regex, len))
>>>>>                        matched = 1;
>>>> Shouldn't that be memcmp() == 0? I don't see how memcpy might serve as
>>>> a compare operator.
>>>>
>>>> Fred.
>>>
>>> Oh you're right, I reviewed it too quickly. Perhaps the star's
>>> alignment made it possible for only one Frederic to review it
>>> the right way...
>>>
>> The stars are still fuzzy to me. How does memcpy work here?
> 
> 
> It doesn't, I guess Li intended to use memcmp.
> 

Oops, I forgot to fix this before sending the patch out.. :(

