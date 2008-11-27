Return-Path: <linux-kernel-owner+w=401wt.eu-S1755636AbYK0P6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636AbYK0P6U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 10:58:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbYK0P6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 10:58:09 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:50148 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbYK0P6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 10:58:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=wl4VLkDoGai27BbET/HnnrF70wjR+tOdAqgIw7W18YBG9KwrX/S+Bh8ybhRPRSQGFE
         DlWG+Xa6e+hQEXUsHacA+njg419SxYo+K2dZwCQZMmWFJkE50GR/3kGmJ9D5MKRC6maK
         yTqdkJj7p+N/VfNEc5D4/BafB6B2FJjSPuoms=
Message-ID: <c62985530811270758q214119e1gbd7699da55d68581@mail.gmail.com>
Date: Thu, 27 Nov 2008 16:58:06 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: walimis <walimisdev@gmail.com>
Subject: Re: about use wild cards for set_ftrace_filter and so on
Cc: "Steven Rostedt" <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <20081127155047.GB24616@ubuntu.mshome.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081127152124.GA24616@ubuntu.mshome.net>
	 <alpine.DEB.1.10.0811271032360.18691@gandalf.stny.rr.com>
	 <20081127155047.GB24616@ubuntu.mshome.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/27 walimis <walimisdev@gmail.com>:
> On Thu, Nov 27, 2008 at 10:34:19AM -0500, Steven Rostedt wrote:
>>
>>On Thu, 27 Nov 2008, walimis wrote:
>>
>>>
>>> I encountered an issue when using ftrace.
>>> We know that we can use wild cards to set set_ftrace_filter, but there's
>>> problem when using such as "echo h* > /debug/tracing/set_ftrace_filter".
>>> If there are files named with "h" prefix in current directory, echo "h*"
>>> will echo these files' name to set_ftrace_filter, not "h*".
>>> For example:
>>>
>>> #cat /debug/tracing/available_filter_functions |grep ^hr |wc -l
>>> 23
>>> #ls
>>> #touch hraa hrdd
>>> #ls
>>> hraa  hrdd
>>> #echo hr* > /debug/tracing/set_ftrace_filter
>>> #cat /debug/tracing/set_ftrace_filter
>>>
>>> No output in /debug/tracing/set_ftrace_filter!
>>> If we use "" to enclose wild cards, it works:
>>>
>>> #ls
>>> hraa  hrdd
>>> #echo "hr*" > /debug/tracing/set_ftrace_filter
>>> #cat /debug/tracing/set_ftrace_filter |wc -l
>>> 23
>>>
>>> This problem can lead to unexpected result if current directory has a
>>> lot of files.
>>> I suppose that we can add some notes to document, so a patch attached.
>>
>>Using TB? It's best to inline the patch, that way I can comment on it
>>better.
> Using mutt, but I don't know how to inline the patch now.
>
>>
>>Anyway, you should fix the example. I also recommend a single quote over
>>double, to prevent any other translation that bash might do.
>>
>>The example in ftrace.txt should be:
>>
>> # echo 'hrtimer_*' > /debug/tracing/set_ftrace_filter
>>
>>
>>Thanks,
>>
>>-- Steve
>>
>>/me goes back to eating turkeys.
> I only add a note, but I wonder whether enough.
> If needed, I can add a example to this document.
>
> Impact: imporve document
>
> Signed-off-by: walimis <walimisdev@gmail.com>
> ---
>  Documentation/ftrace.txt |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/Documentation/ftrace.txt b/Documentation/ftrace.txt
> index de05042..9735434 100644
> --- a/Documentation/ftrace.txt
> +++ b/Documentation/ftrace.txt
> @@ -1251,6 +1251,9 @@ These are the only wild cards which are supported.
>
>   <match>*<match> will not work.
>
> +Note: you'd better to use '' to enclose wild cards, otherwise in some
> +case you can't get the correct result.
> +
>  # echo hrtimer_* > /debug/tracing/set_ftrace_filter
>
>  Produces:
> --
> 1.6.0.3


Cc'ed Ingo.
