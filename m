Return-Path: <linux-kernel-owner+w=401wt.eu-S1756007AbZC0Vrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbZC0Vrc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 17:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbZC0VrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 17:47:23 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:33686 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863AbZC0VrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 17:47:22 -0400
Message-ID: <49CD4967.2090606@msgid.tls.msk.ru>
Date: Sat, 28 Mar 2009 00:47:19 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: nicolas sitbon <nicolas.sitbon@gmail.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Davide Libenzi <davidel@xmailserver.org>
Subject: Re: epoll_ctl and const correctness
References: <84a01a8b0903250545n799a8727o1faad60c8eaf372e@mail.gmail.com>	 <49CAA055.5060603@goop.org>	 <84a01a8b0903251437l9f9059s3c548b5d35ea47d4@mail.gmail.com> <84a01a8b0903270244s146ca50cr2758d36c2d9d77cd@mail.gmail.com>
In-Reply-To: <84a01a8b0903270244s146ca50cr2758d36c2d9d77cd@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nicolas sitbon wrote:
> Please, can anyone answer me, I need a response.

> 2009/3/25 nicolas sitbon <nicolas.sitbon@gmail.com>:
>> You don't teach me anything, I know that, the fact is the
>> documentation is incomplete, so rather saying that, please answer my
>> questions. For the moment, only the documenation and the prototype of
>> epoll are buggy.

So which response do you want -- the one saying that the documentation
is buggy or or epoll prototype?  Or something else?

[]
>>>>  or the good prototype is
>>>>
>>>> int epoll_ctl(int epfd, int op, int fd, struct epoll_event const *event);

Why should it be const?  There is no guarantee the argument will not be
modified by the kernel.  Documentation does not say that.  Current prototype
does not say that.  If you need such a guarantee, you're free to add another
system call into your kernel, and fix both your documentation and your
prototype to match.  What's the deal?

Back from useless rants and to the technical points.

Again: there's no guarantee the `event' argument will not be modified.
Even if kernel CURRENTLY indeed does not modify it, but the interface
does not PROMISE it to be that way for ever.

Why does it not promise that is another question.  Just one example:
what, some day, stops us from adding some EPOLL_CTL_GET operation
to RETRIEVE information associated with that filedescriptor in kernel
currently and STORE that info in the structure pointed to by `event'
argument?  That way it will not be const anymore.

So.. what's your problem?

/mjt
