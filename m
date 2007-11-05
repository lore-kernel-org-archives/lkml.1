Return-Path: <linux-kernel-owner+w=401wt.eu-S1754551AbXKESiK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbXKESiK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 13:38:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752585AbXKESh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 13:37:57 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54280 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753277AbXKESh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 13:37:57 -0500
Date: Mon, 5 Nov 2007 10:36:50 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Mikael Petterson <mikpe@it.uu.se>,
       Eric Biederman <ebiederm@xmission.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [GIT PULL] x86 setup: correct booting on 486 (revised)
In-Reply-To: <472F61C8.4040300@zytor.com>
Message-ID: <alpine.LFD.0.999.0711051035090.15101@woody.linux-foundation.org>
References: <200711050358.lA53wlho003349@tazenda.hos.anvin.org>
 <alpine.LFD.0.999.0711050842360.15101@woody.linux-foundation.org>
 <472F5941.2060507@zytor.com> <alpine.LFD.0.999.0711051006060.15101@woody.linux-foundation.org>
 <472F61C8.4040300@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 Nov 2007, H. Peter Anvin wrote:
> 
> Well, the 32-bit code needs to set up its own stack, and only it knows where
> it wants its stack; we don't guarantee that the stack is valid when we enter
> the 32-bit code and we're entering with both INT and NMI disabled (requiring a
> stack would probably break all existing users of the 32-bit entrypoint.)

I agree. But it would be nice if some basic instructions still worked: as 
is, you cannot even do things like reloading %eflags, because the only way 
to do that requires a stack.

> However, that being said, doing so is trivial, and it might help some
> debugging hack; anything that makes debugging easier is a Good Thing[TM].

Yeah. Even if it was just re-using the boot-time stack area temporarily, 
just to give code the choice to use a common set of instructions.

			Linus
