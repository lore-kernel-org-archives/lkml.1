Return-Path: <linux-kernel-owner+w=401wt.eu-S1754788AbYBDOeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbYBDOeX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 09:34:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbYBDOeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 09:34:10 -0500
Received: from styx.suse.cz ([82.119.242.94]:54192 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751051AbYBDOdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 09:33:20 -0500
Date: Mon, 4 Feb 2008 15:33:18 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: brk randomization breaks columns
In-Reply-To: <20080204130156.GA8730@elte.hu>
Message-ID: <Pine.LNX.4.64.0802041528470.30955@jikos.suse.cz>
References: <20080204122837.GA1647@elf.ucw.cz> <20080204130156.GA8730@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Feb 2008, Ingo Molnar wrote:

> hm, so it seems that it isnt even the randomization that causes the 
> problem - but somehow the randomization code itself is broken, right? 
> Would you be interested in figuring out how to unbreak this? [if not, 
> could you send me the binary?]

I still don't seem to fully understand what is happening here -- aparently 
this is triggerable only with old programs linked against libc.so.5, and I 
am not able to trigger it with my trivial program when I link it against 
old libc.so.5, which just basically does brk() and checks whether 
/proc/<pid>/maps are OK. Seems to me that (at least certain versions) of 
libc.so.5 (wrongly) assume that end of the bss is the start of the heap, 
but I will try to investigate it more.

Ingo, the code in commit c1d171a0029 is IMHO funcionalli identical to 
your exec-shield in fedora kernels, so even libc.so.5-linked binaries on 
any Fedora distro should trigger this bug ... (or you can use the binary 
that Pavel supplied). Haven't tried this yet.

Thanks,

-- 
Jiri Kosina
