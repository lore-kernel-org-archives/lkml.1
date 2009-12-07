Return-Path: <linux-kernel-owner+w=401wt.eu-S1758417AbZLGHU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758417AbZLGHU1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 02:20:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757980AbZLGHUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 02:20:24 -0500
Received: from mail.windriver.com ([147.11.1.11]:34959 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757975AbZLGHUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 02:20:24 -0500
Message-ID: <4B1CAD55.3010808@windriver.com>
Date: Mon, 07 Dec 2009 15:23:01 +0800
From: Wang Liming <liming.wang@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Tom Zanussi <tzanussi@gmail.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       rostedt@goodmis.org, acme@ghostprotocols.net
Subject: Re: [PATCH 2/2] perf trace/scripting: Don't display 'scripting unsupported'
 msg unnecessarily
References: <1260163919-6679-1-git-send-email-tzanussi@gmail.com>	 <1260163919-6679-3-git-send-email-tzanussi@gmail.com>	 <4B1CA15D.1000605@windriver.com> <1260170006.6632.10.camel@tropicana>
In-Reply-To: <1260170006.6632.10.camel@tropicana>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Dec 2009 07:20:15.0652 (UTC) FILETIME=[B90EDE40:01CA770D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tom Zanussi wrote:
> Hi,
> 
> On Mon, 2009-12-07 at 14:31 +0800, Wang Liming wrote:
>> Tom Zanussi wrote:
>>> The 'scripting unsupported' message should only be displayed when the
>>> -s or -g options are used, and not when they aren't, as the current
>>> code does.
>>>
>>> Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
>>> ---
>>>  tools/perf/util/trace-event-perl.c |   64 +++++++++++++++++++++++++++++++-----
>>>  1 files changed, 55 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/tools/perf/util/trace-event-perl.c b/tools/perf/util/trace-event-perl.c
>>> index 59564b2..a5ffe60 100644
>>> --- a/tools/perf/util/trace-event-perl.c
>>> +++ b/tools/perf/util/trace-event-perl.c
>>> @@ -570,26 +570,72 @@ struct scripting_ops perl_scripting_ops = {
>>>  	.generate_script = perl_generate_script,
>>>  };
>>>  
>>> -#ifdef NO_LIBPERL
>>> -void setup_perl_scripting(void)
>>> +static void print_unsupported_msg(void)
>>>  {
>>>  	fprintf(stderr, "Perl scripting not supported."
>>> -		"  Install libperl and rebuild perf to enable it.  e.g. "
>>> -		"apt-get install libperl-dev (ubuntu), yum install "
>>> -		"perl-ExtUtils-Embed (Fedora), etc.\n");
>>> +		"  Install libperl and rebuild perf to enable it.\n"
>>> +		"For example:\n  # apt-get install libperl-dev (ubuntu)"
>>> +		"\n  # yum install perl-ExtUtils-Embed (Fedora)"
>>> +		"\n  etc.\n");
>>>  }
>> I have one question about how to compile c program that embedded perl function:
>>
>> $cat foo.c
>> #include <EXTERN.h>
>> #include <perl.h>
>> int main(void)
>> {
>>          perl_alloc();
>>          return 0;
>> }
>>
>> $gcc  -x c foo.c `perl -MExtUtils::Embed -e ccopts 2>/dev/null`  -o foo `perl 
>> -MExtUtils::Embed -e ldopts 2>/dev/null`
>> /usr/lib/perl/5.8/auto/DynaLoader/DynaLoader.a:1: error: expected identifier or 
>> '(' before '!' token
>> /usr/lib/perl/5.8/auto/DynaLoader/DynaLoader.a:2: error: stray '`' in program
>> ...
>>
>> About thousand of error.
>> I'm using ubuntu 8.04. Above error leads "tools/perl/Makefile" can't find the 
>> libperl-dev and define "NO_LIBPERL", but I have installed "libperl-dev".
>>
>> Did you ever encounter this error?
>> Thanks.
> 
> No, I haven't seen it, but I'm using ubuntu 8.10, which has perl
> v5.10.0.
> 
> ubuntu 8.04 uses what's apparently an ancient version of perl, 5.8,
Yes, it uses perl 5.8.

> which is I'm guessing where the problem is - I'll have to look into
> getting things working with 5.8 in any case...
Another compile error:

     CC util/trace-event-perl.o
cc1: warnings being treated as errors
util/trace-event-perl.c: In function 'xs_init':
util/trace-event-perl.c:43: warning: passing argument 2 of 'Perl_newXS' discards 
qualifiers from pointer target type
util/trace-event-perl.c:43: warning: passing argument 4 of 'Perl_newXS' discards 
qualifiers from pointer target type
util/trace-event-perl.c:45: warning: passing argument 2 of 'Perl_newXS' discards 
qualifiers from pointer target type
util/trace-event-perl.c:45: warning: passing argument 4 of 'Perl_newXS' discards 
qualifiers from pointer target type
make: *** [util/trace-event-perl.o] Error 1

Liming Wang
> 
> Tom
> 
