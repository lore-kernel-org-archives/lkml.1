Return-Path: <linux-kernel-owner+w=401wt.eu-S1754355AbXKEUXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355AbXKEUXK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 15:23:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753459AbXKEUW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 15:22:57 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:56125 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299AbXKEUW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 15:22:56 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Mikael Petterson <mikpe@it.uu.se>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [GIT PULL] x86 setup: correct booting on 486 (revised)
References: <200711050358.lA53wlho003349@tazenda.hos.anvin.org>
	<alpine.LFD.0.999.0711050842360.15101@woody.linux-foundation.org>
	<472F5941.2060507@zytor.com>
	<alpine.LFD.0.999.0711051006060.15101@woody.linux-foundation.org>
	<472F61C8.4040300@zytor.com>
	<alpine.LFD.0.999.0711051035090.15101@woody.linux-foundation.org>
Date: Mon, 05 Nov 2007 13:21:33 -0700
In-Reply-To: <alpine.LFD.0.999.0711051035090.15101@woody.linux-foundation.org>
	(Linus Torvalds's message of "Mon, 5 Nov 2007 10:36:50 -0800 (PST)")
Message-ID: <m1pryoa1f6.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Mon, 5 Nov 2007, H. Peter Anvin wrote:
>> 
>> Well, the 32-bit code needs to set up its own stack, and only it knows where
>> it wants its stack; we don't guarantee that the stack is valid when we enter
>> the 32-bit code and we're entering with both INT and NMI disabled (requiring a
>> stack would probably break all existing users of the 32-bit entrypoint.)
>
> I agree. But it would be nice if some basic instructions still worked: as 
> is, you cannot even do things like reloading %eflags, because the only way 
> to do that requires a stack.
>
>> However, that being said, doing so is trivial, and it might help some
>> debugging hack; anything that makes debugging easier is a Good Thing[TM].
>
> Yeah. Even if it was just re-using the boot-time stack area temporarily, 
> just to give code the choice to use a common set of instructions.

If I had to do it from scratch today I would make the 32-bit entry
point require a stack, segments and use C calling conventions to pass
struct boot_params *.

Besides %esi I'm not really fond of requiring anything in the 32bit
entrypoint.  At the same time I totally agree that it is always nice
to provide way more then you need.

Eric
