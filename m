Return-Path: <linux-kernel-owner+w=401wt.eu-S1754644AbZGCI1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbZGCI1n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 04:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbZGCI13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 04:27:29 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:63099 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbZGCI11 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 04:27:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HUqAcSg8FE1pIbntjxzmXTGl/HgpfYtwkQj98VethF0FDW42qfh2iTrASHRlyeGGwe
         AIlFAH3rqc+93RDafoRj05x9OG7goCEoFgn9KM+QKk7RJ+kJp34yRfC5+Jct8gAWiR/C
         31Nab4uvaKXyzLKiJi1qcOPnzXWlF1l1uLzUg=
MIME-Version: 1.0
In-Reply-To: <20090703081655.GH5880@cr0.nay.redhat.com>
References: <20090702102138.GF6372@cr0.nay.redhat.com>
	 <20090703015554.GB5880@cr0.nay.redhat.com>
	 <412e6f7f0907021910w64af0525h17afb518f0e18f97@mail.gmail.com>
	 <20090703030008.GD5880@cr0.nay.redhat.com>
	 <412e6f7f0907022108p7c533ed2wd16fceb0f282ed62@mail.gmail.com>
	 <20090703051917.GE5880@cr0.nay.redhat.com>
	 <412e6f7f0907022242r52ad981fyd51c2a55f41ab228@mail.gmail.com>
	 <20090703071504.GG5880@cr0.nay.redhat.com>
	 <412e6f7f0907030040v6133badat7058186a01d78f44@mail.gmail.com>
	 <20090703081655.GH5880@cr0.nay.redhat.com>
Date: Fri, 3 Jul 2009 16:27:29 +0800
Message-ID: <412e6f7f0907030127u3d6806dfo9168600e7c71b241@mail.gmail.com>
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

On Fri, Jul 3, 2009 at 4:16 PM, Amerigo Wang<xiyou.wangcong@gmail.com> wrote:
> On Fri, Jul 03, 2009 at 03:40:34PM +0800, Changli Gao wrote:
>>On Fri, Jul 3, 2009 at 3:15 PM, Amerigo Wang<xiyou.wangcong@gmail.com> wrote:
>>>
>>> If saving one fd really helps here, probably you want to
>>> save more, you will need a syscall like:
>>>
>>>  int splice_without_new_fd(int infd, int outfd);
>>Do you know sendfile()? Its current implementation is buggy, and will
>>be blocked on outfd. Anyway, the above code is just a use case, there
>>are other cases sendfile can't cover.
>
> So what? So you should fix it intead of inventing a new pipe() and use
> splice(2)...
I said: It just a special case. Fixing sendfile() won't fix everything.

>
> Wait... if splice(2) doesn't block, what is your point for saving
> an fd in your code? You can do:
>
> int splice_two_fd(int fd1, int fd2)
> {
>        int fds[2];
>        pipe(fds);
>        splice(fd1, fds[0]);//not block
>        splice(fds[1], fd2);//not block
>        close(fds[0]); //can be closed soon
>        close(fds[1]); //ditto
> }
>
> Outside this function no new fd's are used.
>
In fact, sendfile(2) is implemented via splice(2) infrastructure. The
logic is the same, and much clever than yours. Dive into its code, you
will find the reason why it must be blocked on outfd.

>>
>>>
>>> But splice(2) is designed to be as it is. You need to increase
>>> your fd limit, instead of saving one by pipe().
>>>
>>I don't agree with you. We should save resource as much as we can, and
>>not work around it.
>
> You are saying splice(2) is wrong? Because it is splice(2) who
> needs 3 fd's finally.
>
It isn't splice(2)'s fault. In fact, I can also work around this issue
by named pipe.



-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
