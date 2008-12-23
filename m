Return-Path: <linux-kernel-owner+w=401wt.eu-S1751932AbYLWMOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbYLWMOu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 07:14:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750966AbYLWMOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 07:14:40 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:9066 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbYLWMOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 07:14:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jucqtKPBGZ4Clw/hwcHvl1XDFWSF/zA2YkBNxVglcc+byuMDexiYiwWsyEKdvtQhUk
         tPPnlSUEHYsgqKduRWLcCIYeFnnjwougEzGx74eVotx5N0VRNIAytcNpFKPMHwVi6mUV
         lWVgbgJkGQyyJd7rNIh9VVsFIO6khDs2DtS10=
Message-ID: <c62985530812230414y695e36b3oa03b6679a20fb14f@mail.gmail.com>
Date: Tue, 23 Dec 2008 13:14:37 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] tracing/function-graph-tracer: strip ending newlines on comments
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081223064804.GA24956@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <494FD967.2000002@gmail.com> <20081223064804.GA24956@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/23 Ingo Molnar <mingo@elte.hu>:
>
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
>> Impact: trivial output improvement
>>
>> Ending newlines are appended automatically on comments by the function graph tracer
>> because the newlines needs to be placed after the "*/" characters.
>> So if the user puts an ending whitespace, we want to strip it.
>>
>> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
>
> applied to tip/tracing/function-graph-tracer, thanks Frederic!
>
>> @@ -584,6 +585,11 @@ print_graph_comment(struct print_entry *trace, struct trace_seq *s,
>>                               return TRACE_TYPE_PARTIAL_LINE;
>>               }
>>
>> +     /* Strip ending newline on the comment */
>> +     len = strlen(trace->buf);
>> +     if (trace->buf[len - 1] == '\n')
>> +             trace->buf[len - 1] = '\0';
>> +
>
> Hm, dont we know the length of the buffer already, so that we could avoid
> the strlen() overhead?
>
>        Ingo
>

We know it during the insertion. But we need a new field struct print_entry.
That makes me remind that I didn't considered the TRACE_CONT rest of
the buffer in this patch.
Actually, the most easy solution would be to print entirely the buffer
to the seq, and then delete
the newline directly to the seq. That would be a bit crappy but
actually the only solution.

So my patch is wrong in cases of long messages.
