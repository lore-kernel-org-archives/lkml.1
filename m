Return-Path: <linux-kernel-owner+w=401wt.eu-S1757251AbZGCBxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251AbZGCBxw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 21:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751153AbZGCBxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 21:53:44 -0400
Received: from mail-pz0-f193.google.com ([209.85.222.193]:36746 "EHLO
	mail-pz0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbZGCBxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 21:53:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lFAVVGy5MKYsQ1jt6ikzKS4FjYOzbgUASQQIhoX/+5XNyXjOuYGV5IZRRyCPOrbN/K
         FoOyD4iRh7JgRxbg84DK2nsABAq4jN46k4Nx3CfJReG4IdwAnVIRUFEQ70z0e93g7mg+
         0b3dpvfJF91klBrSRz/9N5izpDsiZdyLq6zgM=
Date: Fri, 3 Jul 2009 09:55:54 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Changli Gao <xiaosuo@gmail.com>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: PROPOSAL: extend pipe() to support NULL argument.
Message-ID: <20090703015554.GB5880@cr0.nay.redhat.com>
References: <412e6f7f0907020036y76abbc7du99c7b695f725be4@mail.gmail.com> <20090702091309.GB6372@cr0.nay.redhat.com> <412e6f7f0907020218m1f4a9651l2c682a9905925bcd@mail.gmail.com> <20090702094620.GE6372@cr0.nay.redhat.com> <412e6f7f0907020304u166b6d17id1bcf5d334b45c53@mail.gmail.com> <20090702102138.GF6372@cr0.nay.redhat.com> <412e6f7f0907021743m6ed8ae10uecd13c4fc4ec7cbb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <412e6f7f0907021743m6ed8ae10uecd13c4fc4ec7cbb@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 03, 2009 at 08:43:39AM +0800, Changli Gao wrote:
>On Thu, Jul 2, 2009 at 6:21 PM, Amerigo Wang<xiyou.wangcong@gmail.com> wrote:
>> On Thu, Jul 02, 2009 at 06:04:02PM +0800, Changli Gao wrote:
>>>On Thu, Jul 2, 2009 at 5:46 PM, Amerigo Wang<xiyou.wangcong@gmail.com> wrote:
>>>>>Are you familiar with splice() and tee()? They both use pipes as kernel buffers.
>>>>
>>>> You are not answering the question, obviously.
>>>When you use pipes as kernel buffer handlers, two fd isn't necessary.
>>>Using one will save half of fd resources. Is it obviously?
>>
>> Not really.. I can't see any reason why you use this method to save
>> fd's... pick read(2)/write(2).
>In order to use splice, you must have pipe first. The common code is:
>
>int fd[2];
>
>pipe(fd);
>splice(infd, NULL, fd[1], NULL, getpagesize(), SPLICE_F_MOVE);
>splice(fd[0], NULL, outfd, NULL, getpagesize(), SPLICE_F_MOVE);
>close(fd[0]);
>close(fd[1]);
>
>if pipe supports NULL argument, and returnes a RW pipe fd in that
>case, the code will become:
>
>int fd;
>
>fd = pipe(NULL);
>splice(infd, NULL, fd, NULL, getpagesize(), SPLICE_F_MOVE);
>splice(fd, NULL, outfd, NULL, getpagesize(), SPLICE_F_MOVE);
>close(fd);
>
>One fd is saved.


What is a pipe in your mind? A pipe has two points, obviously,
you are making it a single point, thus you can't call it a pipe
any more...

I don't like this.

And just as what you showed above, you can close the fd's
after finishing, thus you only save one fd during these
two splice(), not useful...


>>
>> You are trying to break it...
>>
>
>It depends on the argument for pipe, if the argument is NULL, it
>breaks the code above.
>

Sure, malloc(2) can return NULL.

