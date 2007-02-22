Return-Path: <linux-kernel-owner+w=401wt.eu-S1751443AbXBVG4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443AbXBVG4d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 01:56:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932997AbXBVG4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 01:56:33 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46980 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431AbXBVG4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 01:56:32 -0500
Date: Thu, 22 Feb 2007 07:51:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Michael K. Edwards" <medwards.linux@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070222065125.GA862@elte.hu>
References: <20070221211355.GA7302@elte.hu> <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com> <20070221225711.GB32031@elte.hu> <f2b55d220702211653x69718ef4o2dd62ed3156465b0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2b55d220702211653x69718ef4o2dd62ed3156465b0@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -3.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-3.8 required=5.9 tests=ALL_TRUSTED,BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Michael K. Edwards <medwards.linux@gmail.com> wrote:

> [...] As for threadlets, making them kernel threads is not such a good 
> design feature, O(1) scheduler or not.  You take the full hit of 
> kernel task creation, on the spot, for every threadlet that blocks. 
> [...]

this is very much not how they work. Threadlets share the same basic 
infrastructure with syslets and they do /not/ take a 'full hit of kernel 
thread creation' when they block. Please read the announcements, past 
discussions on lkml and the code about how it works.

about your other point:

> > threadlets, when they block, are regular kernel threads, so the 
> > regular O(1) scheduler takes care of them. If MMU trashing is of any 
> > concern then syslets should be used to implement the most 
> > performance-critical events: under Linux a kernel thread that does 
> > not exit out to user-space does not do any TLB switching at all. 
> > (even if there are multiple processes active and their syslets 
> > intermix)
> 
> As far as I am concerned syslets by themselves are a dead letter, 
> because you can't do any of the things that potential application 
> coders need to do with them. [...]

syslets are not meant to be directly exposed to application coders. 
Syslets (like many of my previous mails stated) are meant as building 
blocks to higher-level AIO interfaces such as in glibc or libaio. Then 
user-space can build its state-machine based on syslet-implemented 
glibc/libaio. In that specific role they are a very fast and scalable 
mechanism.

	Ingo
