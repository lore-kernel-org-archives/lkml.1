Return-Path: <linux-kernel-owner+w=401wt.eu-S1756312AbXKTSOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312AbXKTSOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 13:14:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760952AbXKTSOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 13:14:39 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38337 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760942AbXKTSOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 13:14:37 -0500
Message-ID: <474323CA.9030306@zytor.com>
Date: Tue, 20 Nov 2007 10:13:30 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       torvalds@linux-foundation.org
Subject: Re: [PATCHv4 5/6] Allow setting O_NONBLOCK flag for new sockets
References: <200711200653.lAK6rE6B025891@devserv.devel.redhat.com> <20071119.235944.82120402.davem@davemloft.net> <474305A5.7070100@redhat.com>
In-Reply-To: <474305A5.7070100@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Drepper wrote:
> 
>> And I agree with all of the objections raised by both H. Pater Anvin
>> and Eric Dumazet.
> 
> Eric had no arguments and HP's comments lack a viable alternative proposal.
> 

That's only because you're being, deliberately or accidentally, vague 
about what your actual (as opposed to imagined) requirements are.

The only thing concrete that I have seen is that the limitation to 6 
system call arguments is insufficient.  This is clearly true, as 
evidenced by things like pselect.  To which I responded that I'd *much* 
rather see a systematized way to handle the the system call ABI beyond 6 
arguments... the system call interface is a calling convention and 
should be treated as such, and the last thing we need is something that 
ends up looking like the MS-DOS kernel interface where every call has 
its own random convention.

The easy answer, to repeat myself, is to adopt the convention that for > 
6 system calls, the sixth argument register carries a pointer to the 6+ 
arguments.  This has minor performance disadvantages on platforms which 
use the stack for return addresses AND uses exactly six registers for 
arguments (a surprisingly common number.)  On those platforms we have 
the option of either take the extra user space copies, or pick a method 
for passing the in-memory copy in a pointer.

If the whole thing about "a dozen new [system calls]" then a dozen 
system calls added to the existing tables are better than this mess.

Inside the kernel, a lot of things could be cleaned up substantially by 
automating the generation of stubs, where necessary.  I did a lot of 
work in klibc to automatically generate stubs of various sorts; some of 
that work may be possible to re-use.

	-hpa
