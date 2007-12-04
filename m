Return-Path: <linux-kernel-owner+w=401wt.eu-S1751789AbXLDSln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789AbXLDSln (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 13:41:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750885AbXLDSlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 13:41:35 -0500
Received: from perninha.conectiva.com.br ([200.140.247.100]:37908 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbXLDSle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 13:41:34 -0500
Date: Tue, 4 Dec 2007 16:41:24 -0200
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: Greg KH <greg@kroah.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       herton@mandriva.com.br, dvgevers@xs4all.nl
Subject: Re: [git pull] scheduler fixes
Message-ID: <20071204164124.447a5c36@mandriva.com.br>
In-Reply-To: <20071204182851.GA18208@kroah.com>
References: <alpine.LFD.0.9999.0712032055080.2981@woody.linux-foundation.org>
	<20071204120715.4ea204a8@mandriva.com.br>
	<alpine.LFD.0.9999.0712040751170.2981@woody.linux-foundation.org>
	<20071204160005.GA29783@elte.hu>
	<20071204161827.GA491@elte.hu>
	<20071204182851.GA18208@kroah.com>
Organization: Mandriva
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.2; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, 4 Dec 2007 10:28:51 -0800
Greg KH <greg@kroah.com> escreveu:

| On Tue, Dec 04, 2007 at 05:18:27PM +0100, Ingo Molnar wrote:
| > 
| > * Ingo Molnar <mingo@elte.hu> wrote:
| > 
| > > The problem is on SMP: if sched_rr_get_interval() gets a task from an 
| > > otherwise idle runqueue, then rq->load.weight is 0. Normally 
| > > sched_slice() is only used on a busy runqueue. So the correct fixup 
| > > site is not in sched_slice() but in sys_sched_rr_get_interval() - i'm 
| > > working on the right fix, i hope to be able to send a pull request in 
| > > a few minutes.
| > 
| > the problem is on UP too - if there are no SCHED_OTHER tasks. I've 
| > tested the fix and it solves the problem for various combinations of 
| > crash.c. I've updated sched.git, please pull it from:
| > 
| >    git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git
| > 
| > It has another commit besides this fix. Thanks,
| 
| Can you make up something that I can apply for 2.6.23-stable?  or is
| this not an issue on that tree?

 FWIW I couldn't reproduce the problem with 2.6.23.9. sched_slice()
is quite different on that kernel and _maybe_ it won't never divide
by zero.

 My original report on vendor-sec was wrong. I've said that 2.6.23.9
had the same bug but turns out the kernel I tested had the Ingo's
CFS backport patch applied. I didn't know that, I thought it was a
vanilla kernel.

 Btw, I think it's important to release a new CFS backport patch
because maybe some distro is using it (Mandriva stable kernel is
using the CFS backport patch, but we didn't update to latest
version yet).

-- 
Luiz Fernando N. Capitulino
