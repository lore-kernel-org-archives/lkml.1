Return-Path: <linux-kernel-owner+w=401wt.eu-S1752538AbXLDS0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538AbXLDS0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 13:26:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750937AbXLDS0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 13:26:24 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42700 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbXLDS0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 13:26:23 -0500
Date: Tue, 4 Dec 2007 10:28:51 -0800
From: Greg KH <greg@kroah.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       herton@mandriva.com.br, dvgevers@xs4all.nl
Subject: Re: [git pull] scheduler fixes
Message-ID: <20071204182851.GA18208@kroah.com>
References: <alpine.LFD.0.9999.0712032055080.2981@woody.linux-foundation.org> <20071204120715.4ea204a8@mandriva.com.br> <alpine.LFD.0.9999.0712040751170.2981@woody.linux-foundation.org> <20071204160005.GA29783@elte.hu> <20071204161827.GA491@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071204161827.GA491@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2007 at 05:18:27PM +0100, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > The problem is on SMP: if sched_rr_get_interval() gets a task from an 
> > otherwise idle runqueue, then rq->load.weight is 0. Normally 
> > sched_slice() is only used on a busy runqueue. So the correct fixup 
> > site is not in sched_slice() but in sys_sched_rr_get_interval() - i'm 
> > working on the right fix, i hope to be able to send a pull request in 
> > a few minutes.
> 
> the problem is on UP too - if there are no SCHED_OTHER tasks. I've 
> tested the fix and it solves the problem for various combinations of 
> crash.c. I've updated sched.git, please pull it from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git
> 
> It has another commit besides this fix. Thanks,

Can you make up something that I can apply for 2.6.23-stable?  or is
this not an issue on that tree?

thanks,

greg k-h
