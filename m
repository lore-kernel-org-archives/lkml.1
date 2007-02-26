Return-Path: <linux-kernel-owner+w=401wt.eu-S1030413AbXBZSlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030413AbXBZSlc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 13:41:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030420AbXBZSlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 13:41:31 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:49127 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030413AbXBZSlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 13:41:31 -0500
Date: Mon, 26 Feb 2007 21:38:56 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070226183856.GF22454@2ka.mipt.ru>
References: <20070221211355.GA7302@elte.hu> <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com> <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com> <20070222074044.GA4158@elte.hu> <20070222113148.GA3781@2ka.mipt.ru> <Pine.LNX.4.64.0702251428490.12485@woody.linux-foundation.org> <20070226131133.GA11777@elte.hu> <20070226173701.GD22454@2ka.mipt.ru> <1172513950.3280.388.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <1172513950.3280.388.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Mon, 26 Feb 2007 21:39:12 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 26, 2007 at 10:19:03AM -0800, Arjan van de Ven (arjan@infradead.org) wrote:
> On Mon, 2007-02-26 at 20:37 +0300, Evgeniy Polyakov wrote:
> 
> > I tend to agree.
> > Yes, some loads require event driven model, other can be done using
> > threads.
> 
> event driven model is really complex though. For event driven to work
> well you basically can't tolerate blocking calls at all ...
> open() blocks on files. read() may block on metadata reads (say indirect
> blockgroups) not just on datareads etc etc. It gets really hairy really
> quick that way.

I never ever tried to say _everything_ must be driven by events.
IO must be driven, it is a must IMO.
Some (and a lot of) things can easily be programmed by threads.
Threads are essentially for those tasks which can not be easily
programmed with events.
But have in mind that fact, that thread execution _is_ an event itself, 
its completion is an event.

> -- 
> if you want to mail me at work (you don't), use arjan (at) linux.intel.com
> Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

-- 
	Evgeniy Polyakov
