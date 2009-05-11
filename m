Return-Path: <linux-kernel-owner+w=401wt.eu-S1758793AbZEKN3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793AbZEKN3N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 09:29:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758668AbZEKN2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 09:28:54 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:15138 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758766AbZEKN2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 09:28:53 -0400
MIME-Version: 1.0
In-Reply-To: <20090511060528.31e0f20c@infradead.org>
References: <20090509143742.GA27663@kroah.com> <20090510221901.30c1c5a5@lxorguk.ukuu.org.uk> 
	<ac3eb2510905101647k12a1b9ck71d43933037bac48@mail.gmail.com> 
	<20090510170016.1e3a4d97@infradead.org> <ac3eb2510905101822t7fde14b3nf2c689621f69c925@mail.gmail.com> 
	<m1pregmkld.fsf@fess.ebiederm.org> <ac3eb2510905110346p115dc8bbscc8921c9bd7e500d@mail.gmail.com> 
	<20090511115504.568c9a92@lxorguk.ukuu.org.uk> <ac3eb2510905110434nb123423m134e848c17c3c736@mail.gmail.com> 
	<20090511060528.31e0f20c@infradead.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 11 May 2009 15:28:33 +0200
Message-ID: <ac3eb2510905110628y65c9a2b8s576bfa4f17ef52e1@mail.gmail.com>
Subject: Re: [patch 00/13] devtmpfs
To: Arjan van de Ven <arjan@infradead.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Fabio Comolli <fabio.comolli@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 15:05, Arjan van de Ven <arjan@infradead.org> wrote:
> On Mon, 11 May 2009 13:34:52 +0200
> Kay Sievers <kay.sievers@vrfy.org> wrote:
>>
>> > - That the other proposals are worse than yours.
>>
>> I also did, in exactly this thread.
>
> no you have not. But I'd like you to ;)

I did. It's reliability, the race for new devices coming in when you
start reading your list and finishing creating the nodes. You will
miss these device, which we don't want to work around with another
hack. You will have to bring up the machinery that listens to events
for new devices, before synthesizing the stuff that is already there.

> You have not commented substantially on my counter proposal to make the
> single file with the "device list" (eg char/block, major, minor, name)
> so that userland can make the nodes in 0.01-or-less seconds, but
> with the permissions/owners it wants and the tmpfs mount options it
> wants.

I did. We have all that information in /sys already. I don't see the
reason for another file other than to provide the information to make
just another new userspace hack a bit more efficient.

> Again this makes for a more flexible solution (not flexible in "if you
> don't like it don't use it" sense but flexible in the "there's multiple
> uses and ways to use it" sense) while keeping the benefits of what you
> want to achieve.

Sure, but it's already in /sys today, and we use it that way already.

> Eric has shown that making the nodes itself and mounting the tmpfs is
> basically free, but that the cost (0.05 seconds) was in groveling
> through sysfs. Fixing that.. I'm all for it.

The point is the mentioned race, which we need to cover.

And the main point is the reliability, let all the weird speed
arguments and made-up numbers alone. You depend on whatever rather
complex userspace to bring your box. And people complain about that
for years, and for good reason.

On my box we create 12152 files in /sys on bootup, and with devtmps
the same code creates 218 simple device nodes with the same call, and
this makes bootup reliable, more self-contained, and as a nice side
effect makes it faster. Just focus on init=/bin/sh, if you want to see
the reason behind all this.

We focused on the speed here, because we want to solve the initramfs
problem, a problem you solved by getting rid of it entirely, which is
what I do on all my own boxes too, but what the distro guys will never
want to accept.

Thanks,
Kay
