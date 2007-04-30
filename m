Return-Path: <linux-kernel-owner+w=401wt.eu-S1754140AbXD3DDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbXD3DDf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 23:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbXD3DDf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 23:03:35 -0400
Received: from ozlabs.org ([203.10.76.45]:58026 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754140AbXD3DDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 23:03:34 -0400
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for
	relocatable bzImage
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Jeff Garzik <jeff@garzik.org>,
       Andi Kleen <ak@suse.de>, patches@x86-64.org,
       Vivek Goyal <vgoyal@in.ibm.com>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>,
       virtualization <virtualization@lists.linux-foundation.org>
In-Reply-To: <m14pmz8bbb.fsf@ebiederm.dsl.xmission.com>
References: <20070428758.455116000@suse.de>
	 <20070428175909.1D09D151CA@wotan.suse.de> <46338D72.70402@garzik.org>
	 <m1fy6kdzi1.fsf@ebiederm.dsl.xmission.com> <4634483E.9030307@goop.org>
	 <m14pmz8bbb.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Date: Mon, 30 Apr 2007 13:03:15 +1000
Message-Id: <1177902195.30071.203.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-29 at 09:11 -0600, Eric W. Biederman wrote:
>   Right now I'm a little frustrated that insanity below slipped into
>   head.S right after the 32bit entry point after the review said
>   use the normal linux parameters for parameter passing.
>   
>   > #ifdef CONFIG_PARAVIRT
>   >         movl %cs, %eax
>   >         testl $0x3, %eax
>   >         jnz startup_paravirt
>   > #endif
>   
>   The whole thing should be based on a value in the linux parameter block
>   pointed to by %esi, instead of the insane preserve all registers and
>   attempt to be super compatible with everyone.

Dammit, Eric, you spend a lot of time using words like "insane" where
you mean we didn't do everything all at once.

It's *not* clear that using %esi is sane, but nothing in the current
code prevents that.

I was trying to get Xen to use this entry point rather than their own: I
failed, and only lguest now uses it.

Fortunately, this also means it's trivial to change.
Rusty.

