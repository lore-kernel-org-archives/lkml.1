Return-Path: <linux-kernel-owner+w=401wt.eu-S1752976AbZI2VWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbZI2VWg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 17:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752562AbZI2VWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 17:22:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:40780 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbZI2VWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 17:22:35 -0400
Date: Tue, 29 Sep 2009 23:22:48 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Linux 2.6.32-rc1
Message-ID: <20090929232248.735bf4df@infradead.org>
In-Reply-To: <alpine.LFD.2.01.0909291410440.6996@localhost.localdomain>
References: <alpine.LFD.2.01.0909271511190.3349@localhost.localdomain>
	<4AC060AE.1090401@gmail.com>
	<alpine.LFD.2.01.0909280829100.3349@localhost.localdomain>
	<20090928191506.40b61793@mschwide.boeblingen.de.ibm.com>
	<4AC10365.7090802@gmail.com>
	<4AC2712C.4080901@gmail.com>
	<alpine.LFD.2.01.0909291410440.6996@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Sep 2009 14:17:58 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Tue, 29 Sep 2009, Eric Dumazet wrote:
> > 
> > Checking this commit, I believe problem comes from cmpxchg(), which
> > doesnt handle 64 bit on X86_32 (no compilation error, and  null
> > operation :( )
> 
> Wow. That's broken. Very nasty silent failure.
> 
> > 1) Use cmpxchg64()
> 
> Clearly better than what we have now, although cmpxchg64 does result
> is some really disgusting code. We will use a bare CMPXCHG64 only if
> you compile for PAE right now - so even if you tell Kconfig that you
> want to compile for a modern CPU, we won't be doing that whole
> cmpxchg64b thing directly, we'll inline some really disgusting code.

can't we use alternatives() for this, to patch cmpxchg64 in ?
I mean.. it'll be commonly supported nowadays.. the fallback to it not
being supported could be a bit slower by now...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
