Return-Path: <linux-kernel-owner+w=401wt.eu-S1755337AbXKDXZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbXKDXZx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 18:25:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754014AbXKDXZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 18:25:46 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39167 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753933AbXKDXZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 18:25:45 -0500
Date: Sun, 4 Nov 2007 15:25:06 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Mikael Petterson <mikpe@it.uu.se>,
       Eric Biederman <ebiederm@xmission.com>
Subject: Re: [GIT PULL] x86 setup: correct booting on 486DX4
In-Reply-To: <alpine.LFD.0.999.0711041512530.15101@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.999.0711041522300.15101@woody.linux-foundation.org>
References: <200711042259.lA4Mxa0n025210@tazenda.hos.anvin.org>
 <alpine.LFD.0.999.0711041512530.15101@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 4 Nov 2007, Linus Torvalds wrote:
> 
> I'm not entirely sure that it needs to be a long-jump, btw. I think any
> regular branch is sufficient. You obviously *do* need to make the long 
> jump later (to reload %cs in protected mode), but I'm not sure it's needed 
> in that place. I forget the exact rules (but they definitely were 
> documented).

Hmm. The original Linux code did

	movw    $1, %ax
	lmsw    %ax
	jmp     flush_instr
    flush_instr:

and I think that was straigh out of the documentation. So yeah, I think 
that's the right fix - not a longjmp (which in itself is dangerous: it 
potentially behaves *differently* on different CPU's, since some CPU's may 
do the long jump with pre-protected-mode semantics, while others will do 
it with protected mode already in effect!)

			Linus
