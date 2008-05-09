Return-Path: <linux-kernel-owner+w=401wt.eu-S933046AbYEIR17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933046AbYEIR17 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 13:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758435AbYEIR1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 13:27:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59555 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757002AbYEIR1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 13:27:25 -0400
Date: Fri, 9 May 2008 10:26:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Gary Hade <garyhade@us.ibm.com>
cc: Ingo Molnar <mingo@elte.hu>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Dave Airlie <airlied@gmail.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: regression fixed by using pci=rom
In-Reply-To: <20080509164551.GB6255@us.ibm.com>
Message-ID: <alpine.LFD.1.10.0805091022020.3142@woody.linux-foundation.org>
References: <21d7e9970805081654h6de38d58q5ad3b6d3520b45f1@mail.gmail.com> <200805081717.54102.jbarnes@virtuousgeek.org> <alpine.LFD.1.10.0805081842030.2940@woody.linux-foundation.org> <20080509064402.GA15754@elte.hu> <20080509164551.GB6255@us.ibm.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 9 May 2008, Gary Hade wrote:
> 
> Ingo, Would you (or others listening to this discussion) know
> exactly what Windows does with respect to BIOS unassigned
> expansion ROMs?

Nobody really seems to know what windows does for *any* resources. And it 
probably depends on windows version too, and on detailed chipset issues 
(ie does Windows do the same thing as Linux wrt transparent bridges that 
still have bus translation resources set up?).

So the "try to do what Windows does" is something we strive for in 
particular cases, but it's not an absolute thing, and probably can never 
even be that in theory. It's more a guideline, especially when we don't 
know which particular choice is better and both seem otherwise equally 
good.

But "doesn't work" always trumps "that's what windows does". Because even 
if something works under Windows, sometimes Linux drivers simply then act 
differently (ie they may use PIO vs MMIO, or in the case of graphics they 
may need ROMs for re-POST'ing while a windows driver is written by the 
chipset vendor and DTRT without even looking at the BIOS tables)

			Linus
