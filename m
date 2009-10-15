Return-Path: <linux-kernel-owner+w=401wt.eu-S1762736AbZJOMN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762736AbZJOMN1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 08:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758271AbZJOMN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 08:13:27 -0400
Received: from [207.36.208.214] ([207.36.208.214]:54558 "EHLO mail.dvmed.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751072AbZJOMN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 08:13:26 -0400
Message-ID: <4AD711BC.2030409@garzik.org>
Date: Thu, 15 Oct 2009 08:12:44 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Remove or convert empty ioctls ?
References: <alpine.LFD.2.00.0910151113340.9428@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0910151113340.9428@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2009 05:20 AM, Thomas Gleixner wrote:
> Hi,
>
> while looking into pushing down BKL to ioctls I noticed that we have a
> lot of ioctls which simply return -EINVAL or some other fancy error
> code.
>
> The question is whether we should convert them to unlocked_ioctl or
> simply remove them and let the sys_ioctl code return the default
> -ENOTTY error code.
>
> One could argue that this is a user visible change, but OTOH there is
> no particular value of EINVAL or any other weird error code when it
> just says: there is no ioctl for this fd.

It seems like a mistake to generalize a rule out of this, especially if 
it leads to error return values changing unexpectedly in years-old code.

"no particular value" is highly subjective, and I think unprovable, 
without an exhaustive survey of userland programs interacting with 
kernel drivers.  Userland programs often interact with a -class- of 
drivers, expecting predictable behavior from a DoThisThing ioctl, with 
EINVAL or "other weird error code" returned intentionally.

Changing the return codes seems quite unwise.

	Jeff




