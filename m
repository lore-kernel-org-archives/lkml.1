Return-Path: <linux-kernel-owner+w=401wt.eu-S1756218AbZGCEJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbZGCEJF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 00:09:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751130AbZGCEI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 00:08:56 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:57549 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbZGCEIz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 00:08:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iWP3SLzkDt9ywl1NJ5dkjAHhlyaKqtGDKzD2Pe0pCmG9o/89Ud+GOeWdtbNH/eR8DH
         g6PO7oEi4lkimS9VxP5IK47ktoUNOiLMxEY8XjN4gvb7r5d9o9Y+U0jMVBSW6q5haUj/
         0IrKhRED80lgOFbYaa2lg9N+K48MgXsvAiVgQ=
MIME-Version: 1.0
In-Reply-To: <20090703030008.GD5880@cr0.nay.redhat.com>
References: <412e6f7f0907020036y76abbc7du99c7b695f725be4@mail.gmail.com>
	 <20090702091309.GB6372@cr0.nay.redhat.com>
	 <412e6f7f0907020218m1f4a9651l2c682a9905925bcd@mail.gmail.com>
	 <20090702094620.GE6372@cr0.nay.redhat.com>
	 <412e6f7f0907020304u166b6d17id1bcf5d334b45c53@mail.gmail.com>
	 <20090702102138.GF6372@cr0.nay.redhat.com>
	 <412e6f7f0907021743m6ed8ae10uecd13c4fc4ec7cbb@mail.gmail.com>
	 <20090703015554.GB5880@cr0.nay.redhat.com>
	 <412e6f7f0907021910w64af0525h17afb518f0e18f97@mail.gmail.com>
	 <20090703030008.GD5880@cr0.nay.redhat.com>
Date: Fri, 3 Jul 2009 12:08:58 +0800
Message-ID: <412e6f7f0907022108p7c533ed2wd16fceb0f282ed62@mail.gmail.com>
Subject: Re: PROPOSAL: extend pipe() to support NULL argument.
From: Changli Gao <xiaosuo@gmail.com>
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 3, 2009 at 11:00 AM, Amerigo Wang<xiyou.wangcong@gmail.com> wrote:
>
> When I said 'pipe', I meant *anonymous* pipe, definitely!
> There is nothing related with *named* pipe here.
>
Pipe means *anonymous* pipe? Who defined that? What the difference
between an anonymou pipe and a named pipe? Two ends or one ends? I
don't think so. Having explicit name is the right difference between
them.

And when I said 'kernel buffer handler', I means it is not a
traditional pipe, and I just extend and reuse the pipe API to create a
kernel buffer handler for splicing use.

> You are going to a *wrong* direction.
>
What is the right direction you think? Keep the pipe() API unchanged
and keep two fds refering to the same kernel buffer? If you want to
keep the API unchanged just for compatiblity with POSIX, I agree with
you, and maybe a new system call is needed.

>
> If you repeat your (pipe,splice,splice,close,close) sequence for
> thousands times, it is still the same, nothing saves...
>
You means that?

while (<condition>) {
 pipe/splice/splice/close/close?
}

You don't know my meaning. As a proxy server, there maybe lots of
connections to maintain, and these connections will keep open for a
long time. If the data received can be sent in a relay cycle, the
kernel buffer can be reused. If not, the kernel buffer must be
reserved. When there are lots of these kinds of connections, lots of
kernel buffers must be reserved. At this time, whether two fds per
kernel buffer or one fds per kernel buffer matters.


-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
