Return-Path: <linux-kernel-owner+w=401wt.eu-S933886AbXCNIJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933886AbXCNIJj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 04:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933889AbXCNIJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 04:09:39 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:36820 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933886AbXCNIJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 04:09:38 -0400
Date: Wed, 14 Mar 2007 09:00:09 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Steven Rostedt <rostedt@goodmis.org>
cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: Re: [PATCH 00/18] Make common x86 arch area for i386 and x86_64 -
 Take 2
In-Reply-To: <20070314050819.536207642@goodmis.org>
Message-ID: <Pine.LNX.4.61.0703140841580.20730@yvahk01.tjqt.qr>
References: <20070314050819.536207642@goodmis.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 14 2007 01:08, Steven Rostedt wrote:
>
>So I spent last night hacking up something to try to make a common ground
>for all code that is shared between x86_64 and i386.  I called this
>
>   arch/x86
>
>Seems appropriate, but I really don't care what it's called.  One thing about
>this name, is that typing arch/x86<Tab> doesn't tab complete x86_64 anymore.
>But if you can think of something better, I'd be happy to apply it.

80x86
8086
ia32   <- I'd go with this for lack of more entries on this list.
i486
i86pc  <- Solely listed for completes. No Solarisisms in Linux please :p
ix86
x32    <- Blame Microsoft for introducing "x64"
x86_32 <- Will interfere with your tabbing.

>So the moves are simply renames, with the slight exception
>of files that hold the speedstep-lib.h file.  This file was moved from the
>arch/i386/kerne/cpu/cpufreq directory and put into the include/asm-i386
>directory.  This was due to the fact that some of the moved files included
>it, and some files that were not moved also included it. Instead of using
>the #include "../../x86/" hack again,

	cd arch/i386/kernel/;
	ln -s ../../ia32 ia32;

with

	obj-m += ia32/foo.c
and
	#include "ia32/......./foo.h"

a bit nicer IMO, but may not work as intended.

> I just simply moved it to the global
>i386 include directory.  Only the arch/x86 will use the include/asm-i386
>change. But to make this change the move patches of the files that contain
>this change also contain the changes to reference the change to locate this
>file.
>
>With this change of having a single repo that holds both the x86_64 files
>as well as the i386 code, it becomes obvious of what files are being shared.
>This way we don't have to worry about someone changing a file in either
>x86_64 or i386 and having it break the other arch, because they didn't
>realize it was being shared.

Jan
-- 
