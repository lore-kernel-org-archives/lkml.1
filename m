Return-Path: <linux-kernel-owner+w=401wt.eu-S1756548AbZGCC6N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548AbZGCC6N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 22:58:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754248AbZGCC6A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 22:58:00 -0400
Received: from mail-pz0-f193.google.com ([209.85.222.193]:36231 "EHLO
	mail-pz0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbZGCC57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 22:57:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=r7FZsqnVgrQcxfvP9jg0/UK//yIS98o9lDgLnQs9kFi0cBQaJcsDAd2XHxCOA/VsrO
         la2rMoumg1T4+RUKX7qxhiIN0HMRsendI7y71JDNOlePgZpe+VY6XM3KjiVU7AvFa96u
         qzdTTk9ke9+XTonlOtS06F7NKy7BciatMr+LA=
Date: Fri, 3 Jul 2009 11:00:08 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Changli Gao <xiaosuo@gmail.com>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: PROPOSAL: extend pipe() to support NULL argument.
Message-ID: <20090703030008.GD5880@cr0.nay.redhat.com>
References: <412e6f7f0907020036y76abbc7du99c7b695f725be4@mail.gmail.com> <20090702091309.GB6372@cr0.nay.redhat.com> <412e6f7f0907020218m1f4a9651l2c682a9905925bcd@mail.gmail.com> <20090702094620.GE6372@cr0.nay.redhat.com> <412e6f7f0907020304u166b6d17id1bcf5d334b45c53@mail.gmail.com> <20090702102138.GF6372@cr0.nay.redhat.com> <412e6f7f0907021743m6ed8ae10uecd13c4fc4ec7cbb@mail.gmail.com> <20090703015554.GB5880@cr0.nay.redhat.com> <412e6f7f0907021910w64af0525h17afb518f0e18f97@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <412e6f7f0907021910w64af0525h17afb518f0e18f97@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 03, 2009 at 10:10:13AM +0800, Changli Gao wrote:
>On Fri, Jul 3, 2009 at 9:55 AM, Amerigo Wang<xiyou.wangcong@gmail.com> wrote:
>>
>>
>> What is a pipe in your mind? A pipe has two points, obviously,
>> you are making it a single point, thus you can't call it a pipe
>> any more...
>>
>> I don't like this
>How do you think the following code?
>
>mkfifo("/tmp/a", O_RDWR);
>fd = open("'/tmp/a", O_RDWR);
>
>Is it right? Is it allowed by Linux/Unix/POSIX?
>
>and when used by splice(), pipe represents a kernel buffer handler not
>its original meaning.

When I said 'pipe', I meant *anonymous* pipe, definitely!
There is nothing related with *named* pipe here.

You are going to a *wrong* direction.

>.
>>
>> And just as what you showed above, you can close the fd's
>> after finishing, thus you only save one fd during these
>> two splice(), not useful...
>splice() is a high performance system call. It maybe used in thousands
>of connection environment, so one instance saves one fd, and thousands
>of fd will be saved.

If you repeat your (pipe,splice,splice,close,close) sequence for
thousands times, it is still the same, nothing saves...
