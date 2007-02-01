Return-Path: <linux-kernel-owner+w=401wt.eu-S1422744AbXBAKJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422744AbXBAKJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 05:09:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422740AbXBAKJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 05:09:26 -0500
Received: from wx-out-0506.google.com ([66.249.82.229]:29332 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422744AbXBAKJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 05:09:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OJ0x53FDLtQHbKlZbysUgGQFPsaXOzNlJRnDDE7cE3+GNAdXySpPSNxty6Bi0IoC3pM1/uulcuzhT7rjiGlP/cZjio053gSeBu/2vveNVsByuzSZbbCKu9M3BV1oJ+c3QfnJfYLVcYZGvZFbA3r0yiYNKjy1jo+Ol7IjtrxwMyU=
Message-ID: <6d6a94c50702010209t94964ew1aebfad2677aa315@mail.gmail.com>
Date: Thu, 1 Feb 2007 18:09:24 +0800
From: "Aubrey Li" <aubreylee@gmail.com>
To: "Aubrey Li" <aubreylee@gmail.com>, Alan <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [BUG]: 2.6.19.2: Weird serial core issue
In-Reply-To: <20070201094522.GA24608@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6d6a94c50701310249o2b2c8024i4d3f28ec1601246a@mail.gmail.com>
	 <20070131162123.67e22e23@localhost.localdomain>
	 <6d6a94c50701311833m5952c6fdn8e1f0db28d674e79@mail.gmail.com>
	 <20070201094522.GA24608@flint.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/1/07, Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> On Thu, Feb 01, 2007 at 10:33:40AM +0800, Aubrey Li wrote:
> > On 2/1/07, Alan <alan@lxorguk.ukuu.org.uk> wrote:
> > >What code is running on that console at the time. Most likely that user
> > >code is also saving/restoring terminal settings so overwrite yours
> > >
> >
> > I implemented the serial driver by myself, :). See the attachment.
> > I didn't save/restore terminal setting in the my_set_termios().
> >
> > I trace this back till tty_tioctl(..., unsigned long arg), everytime I
> > type "ENTER" key,
> > the argument "arg" passed into tty_ioctl() is the address of a termios
> > structure, which include wrong c_cflag.
>
> If userspace is issuing an ioctl to re-enable crtscts, and the kernel
> is obliging, how can this be a kernel bug?

But the fact is not.
1) kernel boot up and enable crtscts by default
2) issue an ioctl to disable crtscts.
3) not do anything but type "ENTER", kernel re-enable crtscts.

That's wrong. Terminal setting seems not be recorded by the serial core.
Is it clear?

-Aubrey
