Return-Path: <linux-kernel-owner+w=401wt.eu-S1753761AbZEIQql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761AbZEIQql (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 12:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbZEIQqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 12:46:31 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:33905 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbZEIQqb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 12:46:31 -0400
MIME-Version: 1.0
In-Reply-To: <20090509082233.32cbb8e4@infradead.org>
References: <20090509143742.GA27663@kroah.com> <b637ec0b0905090810t188e39e3w92d9f4eff04011f1@mail.gmail.com> 
	<20090509150853.GA32394@suse.de> <20090509082233.32cbb8e4@infradead.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Sat, 9 May 2009 18:46:10 +0200
Message-ID: <ac3eb2510905090946t52926a5j1be2cac31f480352@mail.gmail.com>
Subject: Re: [patch 00/13] devtmpfs patches
To: Arjan van de Ven <arjan@infradead.org>
Cc: Greg KH <gregkh@suse.de>, Fabio Comolli <fabio.comolli@gmail.com>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 9, 2009 at 17:22, Arjan van de Ven <arjan@infradead.org> wrote:
> On Sat, 9 May 2009 08:08:53 -0700
> Greg KH <gregkh@suse.de> wrote:
>
>> > Well, guess you meant the opposite ;-)
>>
>> Heh, yes, sorry about that.  It makes booting faster :)
>
> .. and I don't buy that.

Don't buy, just try it - and you will see. :)

We must mount a tmpfs at some point during bootup, wherever you do
that, in initramfs or the real root. Doing that, there will obviously
be a point, where /dev is empty, exactly at that time you can not do
anything else, which is not very tightly controlled, you can not just
start stuff in parallel during that time. Devtmpfs gets rid of that
limitation, and offers you to do things without waiting for a hard
checkpoint. It's obviously the fastest one can do, like number can
show. There can be no faster alternatives for this implemented in
userspace.

> The only argument I've heard is "oh but it's hard". No it's not.
> The other argument is "but for more partitions we get other device
> numbers"... you know what, that's easy to fix. Just make the 32 bit dev
> number consistent. Few lines of code I bet, and it is benefit for
> everyone to do that....

And all the other subsystems. You can't even trust a single static
node for rtc devices, and so on ... Converting all of that stuff in
the kernel is just not a real option. Static device nodes a bad hack,
and distros do not do that today, and can for reasons of correctness
and reliability, not start doing that.

> Beyond that... this is not needed... but at least call it "devfs".. for
> what it is.
>
> (and yes there is very obvious irony)

No problem, it's just a random name we've choosen, that even contains
all of "devfs". :) I just liked to express, that one can do whatever
one wants to do with the nodes from userspace, just like we can today.

Thanks,
Kay
