Return-Path: <linux-kernel-owner+w=401wt.eu-S1752119AbZKCXes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbZKCXes (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 18:34:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751792AbZKCXer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 18:34:47 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:58041 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbZKCXer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 18:34:47 -0500
Date: Tue, 3 Nov 2009 23:34:51 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Rakib Mullick <rakib.mullick@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH] x86, apicdef: Fix checkpatch issues in apicdef.h
In-Reply-To: <20091031095959.GC4869@lenovo>
Message-ID: <alpine.LFD.2.00.0911032317240.9725@eddie.linux-mips.org>
References: <b9df5fa10910310229s2d9f85c1y31403ecbf8c31567@mail.gmail.com> <20091031094431.GB4869@lenovo> <20091031095959.GC4869@lenovo>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Oct 2009, Cyrill Gorcunov wrote:

> [Cyrill Gorcunov - Sat, Oct 31, 2009 at 12:44:31PM +0300]
> | [Rakib Mullick - Sat, Oct 31, 2009 at 03:29:32PM +0600]
> | |
> | |  In apicdef.h - we have a checkpatch issue - needs to be fixed.
> | | We were warned by the following checkpatch warning:
> | | 
> | | ERROR: space prohibited before that ':' (ctx:WxW)
> | | #276: FILE: arch/x86/include/asm/apicdef.h:376:
> | | +                       hi      : 1;
> | |                                 ^
> | | ---
> | | Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
> | | 
> | 
> | personally I would not change it even having checkpatch
> | issue. Really, it's easier to read this bitfield width
> | aligned rather then moved left. But this is a personal
> | opinion only (sorry).

 I agree -- don't fix what ain't broke!

> On the other hands -- I wonder if we need this structure
> at all. Perhaps there was an idea to use it with suspend/resume
> actions? Ingo, Maciej, Yinghai?

 The existence of this structure is purely documentary as it's considered 
unsafe to map device registers using bitfields -- first: the C language 
standard does not guarantee the layout of bitfield struct members, second: 
the compiler may choose to use machine instructions such as BT that are 
unsafe for MMIO, so all accesses should be made via the appropriate 
accessors.

 Then even as such, the contents are out of date and as such may be 
misleading, especially to the newcomers, so I think the choice is either 
to fix the declarations or to dump them altogether and given I couldn't be 
bothered to do the former, my vote is for the latter.

  Maciej
