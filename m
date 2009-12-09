Return-Path: <linux-kernel-owner+w=401wt.eu-S1757244AbZLITJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244AbZLITJW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 14:09:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757030AbZLITJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 14:09:20 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41770 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757023AbZLITJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 14:09:20 -0500
Date: Wed, 9 Dec 2009 11:08:41 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/paravirt for v2.6.33
In-Reply-To: <4B1FF27E.8030701@zytor.com>
Message-ID: <alpine.LFD.2.00.0912091100010.3560@localhost.localdomain>
References: <20091203210913.GA24351@elte.hu> <alpine.LFD.2.00.0912081329460.3560@localhost.localdomain> <20091209073632.GD8187@elte.hu> <4B1FED0D.7060003@goop.org> <alpine.LFD.2.00.0912091039050.3560@localhost.localdomain> <4B1FF27E.8030701@zytor.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 9 Dec 2009, H. Peter Anvin wrote:
>
> The second argument is in %edx, but unlike 64 bits, it is not loaded
> into that register a priory ("asmlinkage" means arguments are on the stack.)

Oh, I missed the fact that we don't actually use asmlinkage on 
sys_iopl() at all on x86-32 for this very reason.

And on x86-64, I think asmlinkage is a no-op, so that's ok - we should 
just make the prototype be

	long sys_iopl(long level, struct pt_regs *regs);

and your fancier macros.

			Linus


