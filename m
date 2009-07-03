Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbZGCJ7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbZGCJ7S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 05:59:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbZGCJ7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 05:59:08 -0400
Received: from mail-qy0-f193.google.com ([209.85.221.193]:60035 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbZGCJ7H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 05:59:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XX8PFUCn1GCAgKmDBOd8+fORQ7wfsMv4jqHIl4j3doqPx/Ta+sfV2OlnxSmUfuhxsS
         zkfXIrNkLOcpPhubKsUYXFRcsi2MMkLvlGK460zuPNkOxF7QdUc4fbi/Tcwlc2qMZT1i
         nnPqocL7OMtDqCYyYTgNKXXvekaAuy6bJNKPk=
MIME-Version: 1.0
In-Reply-To: <20090703094229.GI5880@cr0.nay.redhat.com>
References: <20090703015554.GB5880@cr0.nay.redhat.com>
	 <20090703030008.GD5880@cr0.nay.redhat.com>
	 <412e6f7f0907022108p7c533ed2wd16fceb0f282ed62@mail.gmail.com>
	 <20090703051917.GE5880@cr0.nay.redhat.com>
	 <412e6f7f0907022242r52ad981fyd51c2a55f41ab228@mail.gmail.com>
	 <20090703071504.GG5880@cr0.nay.redhat.com>
	 <412e6f7f0907030040v6133badat7058186a01d78f44@mail.gmail.com>
	 <20090703081655.GH5880@cr0.nay.redhat.com>
	 <412e6f7f0907030127u3d6806dfo9168600e7c71b241@mail.gmail.com>
	 <20090703094229.GI5880@cr0.nay.redhat.com>
Date: Fri, 3 Jul 2009 17:59:10 +0800
Message-ID: <412e6f7f0907030259m5556ee2fobbb58d377bce4d17@mail.gmail.com>
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

On Fri, Jul 3, 2009 at 5:42 PM, Amerigo Wang<xiyou.wangcong@gmail.com> wrote:
>>I said: It just a special case. Fixing sendfile() won't fix everything.
>
> What do you want? Just saving an fd, isn't it?
>
> sendfile() does this but you said it's buggy, if you fix it, what is the
> rest problem?
>
You should know why Linux invented splice(2). Not all of the problems
can be solved by sendfile(2).

>>
>>In fact, sendfile(2) is implemented via splice(2) infrastructure. The
>>logic is the same, and much clever than yours. Dive into its code, you
>>will find the reason why it must be blocked on outfd.
>
>
> Sure, this is done in user-space, definitely....
>
Did you review the code of sendfile(2)? If so, you will know the
common problem.If the data buffered in pipe can't be sent by one
splice(2) call, there are two ways:
1. reserve this pipe to reserve the data in it.
2. block on splice(pipe, outfd) until all the data in it is sent.
and sendfile(2) chooses this second one. In fact, there is  another
choice: simply close the pipe, and the data in the pipe is lost
forever. It isn't a choice, is it?

>>
>>It isn't splice(2)'s fault. In fact, I can also work around this issue
>>by named pipe.
>
> And increase the max fd number...
>
Yea, in many cases, max fd number must be enlarged. More fds means
more memory. Although memory is cheaper today, we have to do our best
to save money.


-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
