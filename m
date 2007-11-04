Return-Path: <linux-kernel-owner+w=401wt.eu-S1755852AbXKDXhl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755852AbXKDXhl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 18:37:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753801AbXKDXhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 18:37:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56982 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645AbXKDXhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 18:37:31 -0500
Message-ID: <472E5785.4020004@zytor.com>
Date: Sun, 04 Nov 2007 15:36:37 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Mikael Petterson <mikpe@it.uu.se>,
       Eric Biederman <ebiederm@xmission.com>
Subject: Re: [GIT PULL] x86 setup: correct booting on 486DX4
References: <200711042259.lA4Mxa0n025210@tazenda.hos.anvin.org> <alpine.LFD.0.999.0711041512530.15101@woody.linux-foundation.org> <alpine.LFD.0.999.0711041522300.15101@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0711041522300.15101@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Sun, 4 Nov 2007, Linus Torvalds wrote:
>> I'm not entirely sure that it needs to be a long-jump, btw. I think any
>> regular branch is sufficient. You obviously *do* need to make the long 
>> jump later (to reload %cs in protected mode), but I'm not sure it's needed 
>> in that place. I forget the exact rules (but they definitely were 
>> documented).
> 
> Hmm. The original Linux code did
> 
> 	movw    $1, %ax
> 	lmsw    %ax
> 	jmp     flush_instr
>     flush_instr:
> 
> and I think that was straigh out of the documentation. So yeah, I think 
> that's the right fix - not a longjmp (which in itself is dangerous: it 
> potentially behaves *differently* on different CPU's, since some CPU's may 
> do the long jump with pre-protected-mode semantics, while others will do 
> it with protected mode already in effect!)
> 

Just looked it up; it was a bit hard to find (it is Intel vol 3 page 
9-27, at least in the version I have), but you're right -- the 
documentation only demands a short jump here, not a long jmp (which 
actually makes sense given what I remembered that a long jump should be 
deferrable here.)  So yes, that is definitely the right fix and avoids 
the ugly mixing of code.

I'll update the patch.

	-hpa
