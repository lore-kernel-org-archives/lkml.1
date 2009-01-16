Return-Path: <linux-kernel-owner+w=401wt.eu-S933768AbZAPNIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933768AbZAPNIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 08:08:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760689AbZAPNIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 08:08:41 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:56063 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760665AbZAPNIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 08:08:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=CW2AbebFX1p+kda/AY0PsF3P87hOkJORiCHeDayk9CVVhK+U6jrUBL7nXyTULKwcW4
         U+uV035X5mVw+9WNtvVjwSNGee2zieFzr0FHnpjiCQECNFRctxFGpiq4F0qbIUpvegxY
         zKV2eTl9SCDNs8S8rZWlKZz4VKNLed3QhOPIU=
Message-ID: <c62985530901160508t318980a5vbbe9198f326e124@mail.gmail.com>
Date: Fri, 16 Jan 2009 14:08:36 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 0/2] ftrace: updates to tip
Cc: "Steven Rostedt" <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Chris Mason" <chris.mason@oracle.com>
In-Reply-To: <20090116112345.GC20082@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090116004050.273665842@goodmis.org>
	 <20090116112345.GC20082@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/16 Ingo Molnar <mingo@elte.hu>:
>
> * Steven Rostedt <rostedt@goodmis.org> wrote:
>
>> Ingo,
>>
>> The first patch is critical, and needs to stay with trace_output.c Not
>> that critical since trace_output.c is not in mainline yet.
>>
>> The second patch gives the ability to stack trace functions. I've been
>> leery about adding this and still keep it a separate option from the
>> "stacktrace" that already exists. This is because when enabled with no
>> filtering, the lag between typing and seeing what is typed can be up to
>> 10 seconds or more.
>
> Btw., is this true even if frame pointers are enabled? When frame pointers
> are disabled we scan the full kernel stack => that can be quite slow if
> every kernel function is traced ;-)


Hi Ingo,

The function tracer selects Frame pointers :-)

Frederic.


>> I made the function stack trace an option attached to the function
>> tracer, so it must be enabled after the function tracer has been set.
>> This still needs to be updated in ftrace.txt.
>
> maybe we could drive this via the filter API? Something like:
>
>   echo "*btrfs*:stacktrace" >> set_filter_functions
>
> Would automatically mean that those functions will all generate
> stacktraces too. Note how safe this API is by default: the filter is used
> for a narrow scope of functions anwyay. To get it for all kernel functions
> one would have to do:
>
>   echo "*:stacktrace" >> set_filter_functions
>
> Which one cannot do accidentally.
>
> What do you think?
>
>> The following patches are in:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
>>
>>     branch: tip/devel
>>
>>
>> Lai Jiangshan (1):
>>       ftrace: fix trace_output
>>
>> Steven Rostedt (1):
>>       ftrace: add stack trace to function tracer
>>
>> ----
>>  kernel/trace/trace.c           |   26 ++++++++----
>>  kernel/trace/trace.h           |    7 +++
>>  kernel/trace/trace_functions.c |   84 ++++++++++++++++++++++++++++++++++++++++
>>  kernel/trace/trace_output.c    |   65 +++++++++++++++----------------
>>  kernel/trace/trace_output.h    |    4 +-
>>  5 files changed, 141 insertions(+), 45 deletions(-)
>
> Pulled into tip/tracing/ftrace, thanks Steve!
>
>        Ingo
>
