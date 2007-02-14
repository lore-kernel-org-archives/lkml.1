Return-Path: <linux-kernel-owner+w=401wt.eu-S1751533AbXBNKMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533AbXBNKMQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 05:12:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751534AbXBNKMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 05:12:16 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:43169 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521AbXBNKMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 05:12:15 -0500
Date: Wed, 14 Feb 2007 13:09:56 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
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
Message-ID: <20070214100955.GA23702@2ka.mipt.ru>
References: <20060529212109.GA2058@elte.hu> <20070213142035.GF638@elte.hu> <p73bqjxhcnl.fsf@bingen.suse.de> <20070213222443.GH22104@elte.hu> <20070213223017.GJ29492@one.firstfloor.org> <20070213224131.GK22104@elte.hu> <20070214091348.GB4665@2ka.mipt.ru> <20070214094629.GA6801@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070214094629.GA6801@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.7.5 (2ka.mipt.ru [0.0.0.0]); Wed, 14 Feb 2007 13:10:26 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 14, 2007 at 10:46:29AM +0100, Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> 
> > This will end up badly - I used the same approach in the early kevent 
> > days and was proven to have swapable memory for the ring. I think it 
> > would be much better to have userspace allocated ring and use 
> > copy_to_user() there.
> 
> it is a userspace allocated ring - but pinned down by the kernel.

That's a problem - 1000/512 pages per 'usual' thread ends up with the
whole memory locked by malicious/stupid application (at least on Debian
and Mandrake there is no locked memory limit by default). And if such 
a limit exists, this will hurt big-iron applications, which want to used
high-order rings legitimely.

> 	Ingo

-- 
	Evgeniy Polyakov
