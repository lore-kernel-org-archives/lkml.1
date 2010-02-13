Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111Ab0BMV6B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 16:58:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37374 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758131Ab0BMV57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 16:57:59 -0500
Message-ID: <4B77202F.9090502@zytor.com>
Date: Sat, 13 Feb 2010 13:57:03 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Joe Perches <joe@perches.com>, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 25/35] move round_up/down to kernel.h
References: <1265793639-15071-1-git-send-email-yinghai@kernel.org>	<1265793639-15071-26-git-send-email-yinghai@kernel.org>	<1266086980.16721.837.camel@Joe-Laptop.home>	<4B7702FE.7060407@zytor.com> <20100213121139.b2589bce.akpm@linux-foundation.org>
In-Reply-To: <20100213121139.b2589bce.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2010 12:11 PM, Andrew Morton wrote:
> 
>> Both of these names already exist -- yes, a rename is probably in order
>> but it should be a separate patchset.
> 
> More than a rename is certainly in order.
> 
> And it's not clear who will be shovelling that muck, and when.  We
> haven't even worked out what needs to be done.
> 

OK, I was under the impression that all that was really called for was a
rename -- which is pretty straightforward, after all; it can mostly be
scripted.

I guess there is a bigger discussion here, and as such we should have it
now.  Since in the end, though, it is going to have to be a cross-kernel
change, it is probably one of those things that should be done "just
before -rc1".

Let's figure out what is needed.  At a very minimum, we have the
following operations:

-> align downward, arbitrary alignment
-> align upward, arbitrary alignment	- current roundup()
-> align downward, power of 2 alignment	- current round_down()
-> align upward, power of 2 alignment	- current round_up()
-> truncate downward to a power of 2	- current rounddown_pow_of_two()
-> truncate upward to a power of 2	- current roundup_pow_of_two()

Then we have some oddballs:

__ALIGN_MASK(x,m)	== round_up(x, m-1)
ALIGN(x,a)		== round_up(x, m)
PTR_ALIGN(p, a)		== round_up with wrapper
DIV_ROUND_UP(n,d)	== roundup(n,d)/d
DIV_ROUND_CLOSEST(n,d)

A structural renaming is certainly in order, but what more are you
looking for, here?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.
