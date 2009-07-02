Return-Path: <linux-kernel-owner+w=401wt.eu-S1752089AbZGBKTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbZGBKTh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 06:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828AbZGBKT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 06:19:29 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:51769 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbZGBKT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 06:19:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=b5Lm4k4w7NBC/OiY1hnDxILqSounMamfPMYcbhXyfVV08sWzrF2E95G50dRrgvWcaT
         hGm32stpmqmz7nenLIILq8ew1NADBXEJgWDJAhuJJ5TAsF87Vbp3NRV0YeK+Rp/yakjn
         DsfdjOn7+5t27BksUwUV/Dh8zBDtwl2SQjG3w=
Date: Thu, 2 Jul 2009 18:21:38 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Changli Gao <xiaosuo@gmail.com>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: PROPOSAL: extend pipe() to support NULL argument.
Message-ID: <20090702102138.GF6372@cr0.nay.redhat.com>
References: <412e6f7f0907020036y76abbc7du99c7b695f725be4@mail.gmail.com> <20090702091309.GB6372@cr0.nay.redhat.com> <412e6f7f0907020218m1f4a9651l2c682a9905925bcd@mail.gmail.com> <20090702094620.GE6372@cr0.nay.redhat.com> <412e6f7f0907020304u166b6d17id1bcf5d334b45c53@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <412e6f7f0907020304u166b6d17id1bcf5d334b45c53@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 02, 2009 at 06:04:02PM +0800, Changli Gao wrote:
>On Thu, Jul 2, 2009 at 5:46 PM, Amerigo Wang<xiyou.wangcong@gmail.com> wrote:
>>>Are you familiar with splice() and tee()? They both use pipes as kernel buffers.
>>
>> You are not answering the question, obviously.
>When you use pipes as kernel buffer handlers, two fd isn't necessary.
>Using one will save half of fd resources. Is it obviously?

Not really.. I can't see any reason why you use this method to save
fd's... pick read(2)/write(2).

>
>>
>> And you snipped too much, how can you return that fd? Using the return value?
>one RW file descriptor is returned. I have answered this in the first post.

No, you never say *how* it is returned.

>
>> Ah! This will probably break the user-space program...
>>
>I don't think so. As a skillful programmer, who will trasfter pipe() a
>NULL pointer? In any way, it is break sth, but not very seriously, and
>won't affact any right and robust program.

Huh? Isn't the code sample below too common?

if (pipe(...))
   perror("pipe");

Currently pipe(2) can make sure this is robust.

You are trying to break it...
