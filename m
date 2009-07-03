Return-Path: <linux-kernel-owner+w=401wt.eu-S1756584AbZGCFRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756584AbZGCFRU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 01:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751358AbZGCFRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 01:17:10 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:44555 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbZGCFRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 01:17:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WhBQy3y1U9K/Rmwyf1tAGtUEvVHz11kYiOKl/N3AeSodKlqIzcSeUMVlR2m9PpgL2v
         HZdfxU+fH50gLX3ny9wcuRL1+HBwIxauMESveo6Ux4rUc2ABMu7NlMzw5Zewdtwpy4z5
         MWUtCXZbh5jKQAB1f7AcUs4sM+cDl+W1kLWBo=
Date: Fri, 3 Jul 2009 13:19:17 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Changli Gao <xiaosuo@gmail.com>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: PROPOSAL: extend pipe() to support NULL argument.
Message-ID: <20090703051917.GE5880@cr0.nay.redhat.com>
References: <20090702091309.GB6372@cr0.nay.redhat.com> <412e6f7f0907020218m1f4a9651l2c682a9905925bcd@mail.gmail.com> <20090702094620.GE6372@cr0.nay.redhat.com> <412e6f7f0907020304u166b6d17id1bcf5d334b45c53@mail.gmail.com> <20090702102138.GF6372@cr0.nay.redhat.com> <412e6f7f0907021743m6ed8ae10uecd13c4fc4ec7cbb@mail.gmail.com> <20090703015554.GB5880@cr0.nay.redhat.com> <412e6f7f0907021910w64af0525h17afb518f0e18f97@mail.gmail.com> <20090703030008.GD5880@cr0.nay.redhat.com> <412e6f7f0907022108p7c533ed2wd16fceb0f282ed62@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <412e6f7f0907022108p7c533ed2wd16fceb0f282ed62@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 03, 2009 at 12:08:58PM +0800, Changli Gao wrote:
>On Fri, Jul 3, 2009 at 11:00 AM, Amerigo Wang<xiyou.wangcong@gmail.com> wrote:
>>
>> When I said 'pipe', I meant *anonymous* pipe, definitely!
>> There is nothing related with *named* pipe here.
>>
>Pipe means *anonymous* pipe? Who defined that? What the difference
>between an anonymou pipe and a named pipe? Two ends or one ends? I
>don't think so. Having explicit name is the right difference between
>them.

I have no interests to teach you its definition.

if you re-read my email, you should conclude what 'pipe' there means,
according to the contexts.

>
>And when I said 'kernel buffer handler', I means it is not a
>traditional pipe, and I just extend and reuse the pipe API to create a
>kernel buffer handler for splicing use.


What pipe(2) creates is exactly an *anonymous* pipe.

>
>> You are going to a *wrong* direction.
>>
>What is the right direction you think? Keep the pipe() API unchanged
>and keep two fds refering to the same kernel buffer? If you want to
>keep the API unchanged just for compatiblity with POSIX, I agree with
>you, and maybe a new system call is needed.


Yes, exactly.
Inventing a new API is better than modifying pipe(2), IMO.

BUT I still don't agree that you really need this... I think you
can add a flag or something like that to an fd to do this, e.g.

   fcntl(fd, F_SETFD, FD_PIPERW);

Isn't this better?

>
>>
>> If you repeat your (pipe,splice,splice,close,close) sequence for
>> thousands times, it is still the same, nothing saves...
>>
>You means that?
>
>while (<condition>) {
> pipe/splice/splice/close/close?
>}

At least this is what I understand from your words.

>
>You don't know my meaning. As a proxy server, there maybe lots of
>connections to maintain, and these connections will keep open for a
>long time. If the data received can be sent in a relay cycle, the
>kernel buffer can be reused. If not, the kernel buffer must be
>reserved. When there are lots of these kinds of connections, lots of
>kernel buffers must be reserved. At this time, whether two fds per
>kernel buffer or one fds per kernel buffer matters.

SHow us the code, please.
