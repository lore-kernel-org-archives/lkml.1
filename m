Return-Path: <linux-kernel-owner+w=401wt.eu-S1761239AbXEQDG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761239AbXEQDG5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 23:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758590AbXEQDGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 23:06:51 -0400
Received: from terminus.zytor.com ([192.83.249.54]:45579 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758584AbXEQDGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 23:06:50 -0400
Message-ID: <464BC67F.7080707@zytor.com>
Date: Wed, 16 May 2007 20:05:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Christian <haveaniceday@cv-sv.de>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc1 does not boot on VIA C3_2 cause of X86_CMPXCHG64
References: <464B9D2C.7040704@cv-sv.de> <alpine.LFD.0.98.0705161750350.3890@woody.linux-foundation.org> <464BAF07.9020003@cv-sv.de> <alpine.LFD.0.98.0705161920410.3890@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705161920410.3890@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Thu, 17 May 2007, Christian wrote:
> 
>> Linus Torvalds wrote:
>>> Can you check? The Nehemian (C3-2) should be model 9 or greater.
>> Yes, it's a Nehemiah
> 
> Ok. If so, we should blacklist both MCYRIXIII and MVIAC3_2, I suspect.
> 
>> lola:~ # cat /proc/cpuinfo
>> flags           : fpu vme de pse tsc msr cx8 sep mtrr pge cmov pat mmx fxsr sse rng rng_en ace ace_en
> 
> However, it does seem to *claim* to support "cx8" aka cmpxchg8b. What's up 
> with that?

It gets turned on by the code in arch/i386/kernel/cpu.  It's just that
the new code that Andi added runs during setup, i.e. in real mode, so
*way* earlier than that.

	-hpa
