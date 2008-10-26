Return-Path: <linux-kernel-owner+w=401wt.eu-S1755199AbYJZNjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199AbYJZNjA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 09:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753589AbYJZNiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 09:38:52 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:31238 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbYJZNiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 09:38:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=fXge6i/7X1ftIUWwUrkDRDWlQB9s3WvcQVSmKR3T6CRfIxQYIP2Eh1chvidwDUoNjO
         WjUvvRpC3HWhkw5IRt8x4V48rbepxcAoemSYqbNOeii24UGFAtJnx4tN32SWsqmtIE/O
         gsEUPBjClCqH/WQKeSW9fBjlTFhPA90rqWe/w=
Message-ID: <490472E5.2070207@gmail.com>
Date: Sun, 26 Oct 2008 15:38:45 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: "Frank Ch. Eigler" <fche@redhat.com>, fweisbec@gmail.com, mingo@elte.hu,
       srostedt@redhat.com, sandmann@daimi.au.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] Add support for userspace stacktraces in tracing/iter_ctrl
References: <1223817124-27239-1-git-send-email-edwintorok@gmail.com>	 <1223817124-27239-3-git-send-email-edwintorok@gmail.com>	 <c62985530810252105k3bce2339k5a49c09fa502ac67@mail.gmail.com>	 <y0mbpx71oqp.fsf@ton.toronto.redhat.com> <1225027782.32713.10.camel@twins>
In-Reply-To: <1225027782.32713.10.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-10-26 15:29, Peter Zijlstra wrote:
> On Sun, 2008-10-26 at 09:15 -0400, Frank Ch. Eigler wrote:
>   
>> "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com> writes:
>>
>>     
>>> [...]
>>>       
>>>> +/* Userspace stacktrace - based on kernel/trace/trace_sysprof.c */
>>>> +
>>>> +struct stack_frame {
>>>> +       const void __user       *next_fp;
>>>> +       unsigned long           return_address;
>>>> +};
>>>>         
>>> [...]
>>>       
>> To what extent does this actually work, and on which architectures?
>> While the kernel appears willing to sacrifice some performance for
>> functionality by building with frame pointers at the drop of a tracing
>> hat, userspace is not like that.
>>     
>
> Aww, common, Gentoo is brilliant for that :-)
>
> CFLAGS+=-fframe-pointer
>
> emerge -uDNe world
>
> Then again, you'd better not have all that desktop bloat installed,
> otherwise that will take ages.. KDE/OOo compile times anyone?
>
> /me runs

It should be enough to rebuild the application you are tracing[1] +
libraries, or at least libc.
In userspace I can get a stacktrace using DWARF unwind info, but doing
that in the kernel would be too expensive, right?

[1] assuming you are tracing latencies in a single application

Best regards,
--Edwin
