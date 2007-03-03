Return-Path: <linux-kernel-owner+w=401wt.eu-S1751564AbXCCKbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564AbXCCKbQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 05:31:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751546AbXCCKbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 05:31:16 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:34398 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495AbXCCKbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 05:31:15 -0500
Date: Sat, 3 Mar 2007 13:27:45 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@ucw.cz>,
       Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070303102744.GB22557@2ka.mipt.ru>
References: <20070301081808.GD7217@2ka.mipt.ru> <20070301092634.GB20171@elf.ucw.cz> <20070301094723.GJ7217@2ka.mipt.ru> <20070301101102.GE20171@elf.ucw.cz> <20070301111815.GB15709@2ka.mipt.ru> <20070302102714.GB27687@elf.ucw.cz> <20070302103713.GB28444@2ka.mipt.ru> <20070302105618.GA18377@elte.hu> <20070302110820.GA25908@2ka.mipt.ru> <Pine.LNX.4.64.0703020921430.1977@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703020921430.1977@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Sat, 03 Mar 2007 13:28:26 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2007 at 09:28:10AM -0800, Davide Libenzi (davidel@xmailserver.org) wrote:
> On Fri, 2 Mar 2007, Evgeniy Polyakov wrote:
> 
> > do we really want to have per process signalfs, timerfs and so on - each 
> > simple structure must be bound to a file, which becomes too cost.
> 
> I may be old school, but if you ask me, and if you *really* want those 
> events, yes. Reason? Unix's everything-is-a-file rule, and being able to 
> use them with *existing* POSIX poll/select. Remember, not every app 
> requires huge scalability efforts, so working with simpler and familiar 
> APIs is always welcome.
> The *only* thing that was not practical to have as fd, was block requests. 
> But maybe threadlets/syslets will handle those just fine, and close the gap.
 
That means that we bind very small object like timer or signal to the
whoe file structure - yes, as I stated - it is doable, but do we really
have to create a file each time create_timer() or signal() is called?
Signals as a filesystem are limited in that regard that we need to
create additional structures to have signal number<->private data
relations.
I designed kevent to be as small as possible, so I removed file binding
idea first. I do not say it is wrong or epoll (and threadlets) are broken 
(fsck, I hope people do understand that), but as is it can not handle
that scenario, so it must be extended and/or a lot of other stuff
written to be compatible with epoll design. Kevent has different design
(which allows to work with old one though - there is a patch to
implement epoll over kevent).
 
> - Davide
> 

-- 
	Evgeniy Polyakov
