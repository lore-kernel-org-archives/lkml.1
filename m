Return-Path: <linux-kernel-owner+w=401wt.eu-S1762031AbZC0W4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762031AbZC0W4e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 18:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757500AbZC0W4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 18:56:04 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:59281 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042AbZC0Wz7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 18:55:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=d3DpUmqf2D+YTq1ZWIIvbt3SGJ0d3CGTkCNN91k6btKsM+v6ePI9qpzy+w/lEruSz6
         qLnl8itTcOX/wRpz6rlekZoUtiAteba5n8tLLJelIwrzcmKsQ1ATLvYDzfdcuw2kzOqr
         sb/akKR5ysIxqc+8BK2HXmH3T+mIErBdOKkEQ=
MIME-Version: 1.0
In-Reply-To: <49CD564E.6050101@msgid.tls.msk.ru>
References: <84a01a8b0903250545n799a8727o1faad60c8eaf372e@mail.gmail.com>
	 <49CAA055.5060603@goop.org>
	 <84a01a8b0903251437l9f9059s3c548b5d35ea47d4@mail.gmail.com>
	 <84a01a8b0903270244s146ca50cr2758d36c2d9d77cd@mail.gmail.com>
	 <49CD4967.2090606@msgid.tls.msk.ru>
	 <84a01a8b0903271517t668c6276l7fe098d74c24b836@mail.gmail.com>
	 <84a01a8b0903271530of8d43ffhf77e7ba73e309f75@mail.gmail.com>
	 <49CD564E.6050101@msgid.tls.msk.ru>
Date: Fri, 27 Mar 2009 23:55:56 +0100
Message-ID: <84a01a8b0903271555i7a4fea50nd95009539aa2f94d@mail.gmail.com>
Subject: Re: epoll_ctl and const correctness
From: nicolas sitbon <nicolas.sitbon@gmail.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do you read my post? there is a confusion, my question was first : why
the structure isn't const? and you answer me. ok. second, I asked if
the kernel keep track of this structure, that is, it keeps a pointer
on it for doing his job? according to your last answer, no. last
question : why the size type of the first parameter of epoll_create is
int and not size_t? no answer for the moment.

2009/3/27 Michael Tokarev <mjt@tls.msk.ru>:
> nicolas sitbon wrote:
>>
>> I was looking at libevent of niels provos, and even him, is apparently
>> doing a mistake :
>>
>> static int
>> epoll_add(void *arg, struct event *ev)
>> {
>>        struct epollop *epollop = arg;
>>        struct epoll_event epev = {0, {0}};
>>
>>        /* ... some code here ... */
>>        if (epoll_ctl(epollop->epfd, op, ev->ev_fd, &epev) == -1)
>>                        return (-1);
>>
>>        /* Update events responsible */
>>        if (ev->ev_events & EV_READ)
>>                evep->evread = ev;
>>        if (ev->ev_events & EV_WRITE)
>>                evep->evwrite = ev;
>>
>>        return (0);
>> }
>>
>> the structure pointed to by &epev is allocated on the stack, so how
>> the kernel could keep track of it?
>
> I've no idea what are you talking about and what exactly
> is your problem.  Both the examples (one at cplayer.org and
> another above) gives correct usage of epoll.  If you don't
> understand it, well, I'd suggest reading some documentation
> first, maybe in kernel, maybe in glibc, maybe numerous
> available on the net.  And all the numerous examples too,
> which you quote as, for some reason, wrong.
>
> /mjt
>
