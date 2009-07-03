Return-Path: <linux-kernel-owner+w=401wt.eu-S1756635AbZGCCKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbZGCCKY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 22:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756175AbZGCCKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 22:10:11 -0400
Received: from mail-vw0-f202.google.com ([209.85.212.202]:42990 "EHLO
	mail-vw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbZGCCKK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 22:10:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=TCxWp0oy5zDnqhb3FfLcVjRO7bV083MxJ1L7ihlD7fz93lPJNbU0gzUM7693eCg0nm
         53K1vA37dCEM8M0nqso7dN5mF6p2ZB9qSlg9LUPR/f6LybLCq6Vsuo+Q0RP//M3nPNFE
         n6HbyJVVQDHPBYwUMgj9LvezSbW4Rolnu/TAs=
MIME-Version: 1.0
In-Reply-To: <20090703015554.GB5880@cr0.nay.redhat.com>
References: <412e6f7f0907020036y76abbc7du99c7b695f725be4@mail.gmail.com>
	 <20090702091309.GB6372@cr0.nay.redhat.com>
	 <412e6f7f0907020218m1f4a9651l2c682a9905925bcd@mail.gmail.com>
	 <20090702094620.GE6372@cr0.nay.redhat.com>
	 <412e6f7f0907020304u166b6d17id1bcf5d334b45c53@mail.gmail.com>
	 <20090702102138.GF6372@cr0.nay.redhat.com>
	 <412e6f7f0907021743m6ed8ae10uecd13c4fc4ec7cbb@mail.gmail.com>
	 <20090703015554.GB5880@cr0.nay.redhat.com>
Date: Fri, 3 Jul 2009 10:10:13 +0800
Message-ID: <412e6f7f0907021910w64af0525h17afb518f0e18f97@mail.gmail.com>
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

On Fri, Jul 3, 2009 at 9:55 AM, Amerigo Wang<xiyou.wangcong@gmail.com> wrote:
>
>
> What is a pipe in your mind? A pipe has two points, obviously,
> you are making it a single point, thus you can't call it a pipe
> any more...
>
> I don't like this
How do you think the following code?

mkfifo("/tmp/a", O_RDWR);
fd = open("'/tmp/a", O_RDWR);

Is it right? Is it allowed by Linux/Unix/POSIX?

and when used by splice(), pipe represents a kernel buffer handler not
its original meaning.
.
>
> And just as what you showed above, you can close the fd's
> after finishing, thus you only save one fd during these
> two splice(), not useful...
splice() is a high performance system call. It maybe used in thousands
of connection environment, so one instance saves one fd, and thousands
of fd will be saved.

>
>
>>>
>>> You are trying to break it...
>>>
>>
>>It depends on the argument for pipe, if the argument is NULL, it
>>breaks the code above.
>>
>
> Sure, malloc(2) can return NULL.
>
>
You should check the return value returned by malloc brefore passing
it to pipe(), and not rely on pipe()'s check.


-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
