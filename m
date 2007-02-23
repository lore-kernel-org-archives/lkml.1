Return-Path: <linux-kernel-owner+w=401wt.eu-S932627AbXBWS4H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932627AbXBWS4H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 13:56:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932619AbXBWS4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 13:56:07 -0500
Received: from brick.kernel.dk ([62.242.22.158]:7953 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933177AbXBWS4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 13:56:04 -0500
Date: Fri, 23 Feb 2007 19:35:40 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Suparna Bhattacharya <suparna@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: A quick fio test (was Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3)
Message-ID: <20070223183540.GB22586@kernel.dk>
References: <20070221211355.GA7302@elte.hu> <20070223125247.GO5737@kernel.dk> <20070223135525.GA31569@in.ibm.com> <20070223145826.GA32465@elte.hu> <20070223151515.GA12960@in.ibm.com> <20070223162508.GA16782@kernel.dk> <20070223171348.GA27838@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070223171348.GA27838@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 23 2007, Suparna Bhattacharya wrote:
> On Fri, Feb 23, 2007 at 05:25:08PM +0100, Jens Axboe wrote:
> > On Fri, Feb 23 2007, Suparna Bhattacharya wrote:
> > > On Fri, Feb 23, 2007 at 03:58:26PM +0100, Ingo Molnar wrote:
> > > > 
> > > > * Suparna Bhattacharya <suparna@in.ibm.com> wrote:
> > > > 
> > > > > As a really crude (and not very realistic) example of the potential 
> > > > > impact of large numbers of outstanding IOs, I tried some quick direct 
> > > > > IO comparisons using fio:
> > > > > 
> > > > > [global]
> > > > > ioengine=syslet-rw
> > > > > buffered=0
> > > > > rw=randread
> > > > > bs=64k
> > > > > size=1024m
> > > > > iodepth=64
> > > > 
> > > > could you please try those iodepth=20000 tests with the latest 
> > > > fio-testing branch of fio as well? Jens wrote a new, smarter syslet 
> > > > plugin for FIO. You'll need the v3 syslet kernel plus:
> > > > 
> > > >  git-clone git://git.kernel.dk/data/git/fio.git
> > > >  cd fio
> > > >  git-checkout syslet-testing
> > > > 
> > > > my expectation is that it should behave better with iodepth=20000 
> > > > (although i havent tried that yet).
> > > 
> > > I picked up the fio snapshot from 22nd Feb (fio-git-20070222212513.tar.gz)
> > > and used the v3 syslet patches from your web-site.
> > > 
> > > Do I still need to get something more recent ?
> > 
> > Yes, you need to test the syslet+testing branch that Ingo referenced.
> > Your test above is not totally fair right now, since you are doing
> > significantly less system calls with libaio. So to compare apples with
> > apples, try the syslet-testing branch. If you can't get it because of
> > firewall problems, check http://brick.kernel.dk/snaps/ for the latest
> > fio snapshot. If it has the syslet-testing branch, then that is
> > recent enough.
> 
> I have a feeling this is getting to be a little more bleeding edge than
> I had anticipated :), so will just hold off for a bit until this
> crystallizes a bit.

Fair enough, I'll try your test with a huge number of pending requests
and see how it fares.

-- 
Jens Axboe

