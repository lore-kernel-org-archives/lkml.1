Return-Path: <linux-kernel-owner+w=401wt.eu-S964814AbXBPNdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964814AbXBPNdU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 08:33:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964834AbXBPNdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 08:33:20 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:38230 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964814AbXBPNdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 08:33:19 -0500
Date: Fri, 16 Feb 2007 16:28:58 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 05/11] syslets: core code
Message-ID: <20070216132857.GA19820@2ka.mipt.ru>
References: <20070215133550.GA29274@2ka.mipt.ru> <Pine.LNX.4.64.0702150757520.20368@woody.linux-foundation.org> <20070215163704.GA32609@2ka.mipt.ru> <Pine.LNX.4.64.0702150920130.20368@woody.linux-foundation.org> <20070215181059.GC20997@2ka.mipt.ru> <Pine.LNX.4.64.0702151019210.20368@woody.linux-foundation.org> <20070215190413.GA23953@2ka.mipt.ru> <Pine.LNX.4.64.0702151120260.20368@woody.linux-foundation.org> <Pine.LNX.4.64.0702151159410.20368@woody.linux-foundation.org> <20070216122806.GA27455@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070216122806.GA27455@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Fri, 16 Feb 2007 16:29:01 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 16, 2007 at 01:28:06PM +0100, Ingo Molnar (mingo@elte.hu) wrote:
> OTOH, the syslet concept right now already looks very ubiquitous, and 
> the main problem with AIO use in applications wasnt just even its broken 
> API or its broken performance, but the fundamental lack of all Linux IO 
> disciplines supporting AIO, and the lack of significantly parallel 
> hardware. We have kaio that is centered around block drivers - then we 
> have epoll that works best with networking, and inotify that deals with 
> some (but not all) VFS events - but neither supports every IO and event 
> disciple well, at once. My feeling is that /this/ is the main 
> fundamental problem with AIO in general, not just its programmability 
> limitations.

That is quite dissapointing to hear when weekely released kevent can
solve that problem already more than year ago - it was designed specially to
support every possible notification types and does support file
descriptor ones, VFS (dropped in current releases to reduce size) and
tons of other including POSIX times, signals, own high-performance AIO
(which was created as a a bit complex state machine over internals of
page population code) and essentially everything one can ever imagine 
with quite a bit of code needed for new type.

I was requested to add waiting for futex through kevent queue - that is
quite simple task, but having complete lack of feedback and ignorance of
the project even from people who asked about its features, it looks like
there is no need for that at all.

-- 
	Evgeniy Polyakov
