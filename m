Return-Path: <linux-kernel-owner+w=401wt.eu-S1757823AbYCKPGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757823AbYCKPGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 11:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbYCKPGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 11:06:10 -0400
Received: from www.tglx.de ([62.245.132.106]:58085 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753505AbYCKPGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 11:06:09 -0400
Date: Tue, 11 Mar 2008 16:03:41 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Renato S. Yamane" <renatoyamane@mandic.com.br>
cc: linux-kernel@vger.kernel.org, alan-jenkins@tuffmail.co.uk, devzero@web.de,
       mingo@elte.hu
Subject: Re: Kernel Linux 2.6.23.16 hangs when run updatedb
In-Reply-To: <47D6984B.5040108@mandic.com.br>
Message-ID: <alpine.LFD.1.00.0803111558190.3781@apollo.tec.linutronix.de>
References: <47D54A8B.2020303@mandic.com.br> <alpine.LFD.1.00.0803110803280.3781@apollo.tec.linutronix.de> <47D6984B.5040108@mandic.com.br>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2008, Renato S. Yamane wrote:
> > Renato, some questions:
> > 1) is this fully reproducible with updatedb ?
> 
> Yes, this crash is fully reproducible.
> All time wich I turn-on my laptopt I need kill find daemon in my Debian Etch.
> If I don't do that, my laptop hangs.

Good. Not for you, but for isolating the bug. :)

> > 2) are you sure that this is the first stacktrace you captured, there
> > might be some BUG before that which scrolled out of sight. Any chance
> > to use a serial console?
> 
> I can't use scroll, because none key/mouse work after crash.
> And, sorry I can't use a serial console. Any other idea?

netconsole might work. Documentation/networking/netconsole.txt
 
> > 3) Can you please recompile the kernel with CONFIF_DEBUG_INFO set
> > and then run the following addresses from the backtrace through
> > addr2line with the new vmlinux:
> > # addr2line -e vmlinux 0xc013dad9 0xc0107c3b
> 
> Yes, I try compile 2.6.24.3 without any patch.

Ok. If the problem persists, you might try 2.6.25-rc5 as well. I have
timer debugging infrastructure for the latter, which I want to avoid
to backport to .23/24 :)

Does it happen with straight 2.6.23.16 as well ?
 
> > 4) Looking at your .config it seems you have some more patches applied
> > aside of the .16 stable. Can you please upload a full patch queue
> > somewhere ?
> 
> I attached all patchs used in my 2.6.23.16.

Hmm, I can't see an obvious candidate.

Thanks,

	tglx
