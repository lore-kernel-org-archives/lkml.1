Return-Path: <linux-kernel-owner+w=401wt.eu-S1757363AbYJXXBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363AbYJXXBa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 19:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752554AbYJXXBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 19:01:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:51635 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330AbYJXXBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 19:01:00 -0400
Date: Fri, 24 Oct 2008 16:01:20 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Tony Vroon <tony@vroon.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Linux 2.6.28-rc1
Message-ID: <20081024160120.07d37930@infradead.org>
In-Reply-To: <1224888808.3938.11.camel@localhost>
References: <alpine.LFD.2.00.0810232028500.3287@nehalem.linux-foundation.org>
	<1224888808.3938.11.camel@localhost>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Oct 2008 23:53:28 +0100
Tony Vroon <tony@vroon.org> wrote:

> On Thu, 2008-10-23 at 21:10 -0700, Linus Torvalds wrote:
> > It's been two weeks, so it's time to close the merge window. A
> > 2.6.28-rc1 is out there, and it's hopefully all good.
> 
> I'm afraid it fails to boot here entirely.
> Gets as far as:
> hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
> hpet0: 3 32-bit timers, 25000000 Hz
> 
> And it sits there, instead of showing me it switched into
> high-resolution mode as expected:
> Switched to high resolution mode on CPU 0
> Switched to high resolution mode on CPU 4
> Switched to high resolution mode on CPU 2
> Switched to high resolution mode on CPU 3
> Switched to high resolution mode on CPU 1
> Switched to high resolution mode on CPU 5
> Switched to high resolution mode on CPU 7
> Switched to high resolution mode on CPU 6
> 
> I'll go and bisect now if it doesn't ring any bells. It's a dual
> quad-core Opteron 2354 on a Tyan n6650W (S2915-E), BIOS 2.07
> I've attached .config; personally I'm suspecting commit
> 1f6d6e8ebe73ba9d9d4c693f7f6f50f661dbd6e4 as I booted a tree from
> Wednesday without issue.
> 
> No accusation as I can't back that up yet. Any patches that you want
> me to try and revert first?

I suspect these are totally innocent; the reason I think this is that
select/poll only get used once you hit userspace... and you're hanging
way before that.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
