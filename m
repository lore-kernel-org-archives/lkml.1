Return-Path: <linux-kernel-owner+w=401wt.eu-S1753845AbYI3QQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbYI3QQm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 12:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbYI3QQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 12:16:35 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:44599 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbYI3QQe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 12:16:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=fdwpwgb0qxq2AZO5bzxmJT50bHBW43FGb5FstGfxcsqCYc7fnj3hu5InQT5ZkV63bt
         R8c6jj05ef5cE0mB+n8pBBb68bE6dJJnYXJVjFC/0zRKoVYWY4+FCkyj3rs9jI2dQhwH
         M4FLKqQobbd/u3sB3gqa8DK566Fv2kgCaAXPg=
Message-ID: <c62985530809300916k1151ff87ib45e2f913bf1728d@mail.gmail.com>
Date: Tue, 30 Sep 2008 18:16:31 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH V2 -tip 3/4] Tracing/ftrace: Adapt mmiotrace to the new type of print_line
Cc: "Steven Rostedt" <rostedt@goodmis.org>, "Pekka Paalanen" <pq@iki.fi>,
       linux-kernel@vger.kernel.org
In-Reply-To: <48E25039.8080907@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <48E11E1E.7010001@gmail.com>
	 <20080929221934.260306dd@daedalus.pq.iki.fi>
	 <20080930085241.GB10374@elte.hu>
	 <c62985530809300539o2842c14fk16708abaf69c4e2f@mail.gmail.com>
	 <alpine.DEB.1.10.0809300844270.1984@gandalf.stny.rr.com>
	 <c62985530809300625p6c178c0ew6b9619998c3d5011@mail.gmail.com>
	 <20080930153912.GB22693@elte.hu> <48E25039.8080907@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops sorry...
Cut in the middle....

2008/9/30 Frederic Weisbecker <fweisbec@gmail.com>:
> Ingo Molnar wrote:
>> * Frédéric Weisbecker <fweisbec@gmail.com> wrote:
>>
>>> 2008/9/30 Steven Rostedt <rostedt@goodmis.org>:
>>>> OK, I'll nuke the ring_buffer_lock :-/
>>>>
>>>> The trace_pipe calls that and then calls print_trace_line which will
>>>> eventually lock the buffer again. This is a bug on my part. I'll fix that
>>>> today.
>>>>
>>>> Thanks,
>>> Strange, I can't see any case where print_trace_line could call the
>>> ring_buffer_lock.
>>> Hmm, I will see in your patch.
>>>
>>> Ingo, I just saw one damage from the merging, trace_empty() returns
>>> TRACE_TYPE_HANDLED. The type is wrong, it should return 1. It's not
>>> urgent since the value is the same. Should I send a patch for such a
>>> small error?
>>
>> yes, please do. One too many patch is far better than one too few ;-)
>>
>>       Ingo
>>
>
> :)
>
> Here it is!
>
> Subject: [PATCH -tip] Tracing/ftrace: correct return value of trace_empty
>
> Correct the value's type of trace_empty function
>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 6a1c76b..da3789d 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -1686,7 +1686,7 @@ static int trace_empty(struct trace_iterator *iter)
>                if (!ring_buffer_iter_empty(iter->buffer_iter[cpu]))
>                        return 0;
>        }
> -       return TRACE_TYPE_HANDLED;
> +       return 1;
>  }
>
>  static enum print_line_t print_trace_line(struct trace_iterator *iter)
>
>
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 6a1c76b..da3789d 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -1686,7 +1686,7 @@ static int trace_empty(struct trace_iterator *iter)
>                if (!ring_buffer_iter_empty(iter->buffer_iter[cpu]))
>                        return 0;
>        }
> -       return TRACE_TYPE_HANDLED;
> +       return 1;
>  }
>
>  static enum print_line_t print_trace_line(struct trace_iterator *iter)
>
