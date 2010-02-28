Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032055Ab0B1UqL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 15:46:11 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33816 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032025Ab0B1UqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 15:46:10 -0500
Date: Sun, 28 Feb 2010 12:45:51 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Borislav Petkov <borislav.petkov@amd.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/cpu changes for v2.6.34
In-Reply-To: <alpine.LFD.2.00.1002281205320.27475@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1002281239550.3637@localhost.localdomain>
References: <20100227150942.GA6394@elte.hu> <alpine.LFD.2.00.1002281205320.27475@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 28 Feb 2010, Linus Torvalds wrote:
> 
> I haven't bisected this, but something slowed down in bootup on my machine 
> recently.

Hmm. I take that back. It's not consistent, and it's not recent after all. 

It comes and goes:

	[torvalds@nehalem linux]$ grep "CPU 7 MCA" /var/log/messages-* /var/log/messages | cut -d: -f5-
	 [    0.898396] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
	 [    0.898400] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
	 [    1.596240] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
	 [    0.898394] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
	 [    1.600229] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
	 [    0.898395] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
	 [    0.901211] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
	 [    2.633298] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
	 [    0.898393] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
	 [    0.901210] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
	 [    0.898395] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
	 [    0.898393] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
	 [    0.898393] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
	 [    0.898402] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
	 [    0.901213] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
	 [    0.898392] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
	 [    0.898395] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
	 [    1.601467] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
	 [    0.898401] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
	 [    0.898395] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
	 [    0.898397] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8

note how it's pretty consistently at about the 0.89s mark, but then 
there's a _couple_ of times when it's taken rather longer to boot. But the 
delay is always in that CPU bringup phase, because doing the same grep for 
"CPU 0 MCA" gives consistently low numbers (0.0005s).

			Linus
