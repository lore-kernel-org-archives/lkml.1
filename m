Return-Path: <linux-kernel-owner+w=401wt.eu-S932195AbXBNJP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195AbXBNJP6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 04:15:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932193AbXBNJP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 04:15:58 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:41035 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932195AbXBNJP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 04:15:57 -0500
Date: Wed, 14 Feb 2007 12:13:48 +0300
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
Message-ID: <20070214091348.GB4665@2ka.mipt.ru>
References: <20060529212109.GA2058@elte.hu> <20070213142035.GF638@elte.hu> <p73bqjxhcnl.fsf@bingen.suse.de> <20070213222443.GH22104@elte.hu> <20070213223017.GJ29492@one.firstfloor.org> <20070213224131.GK22104@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070213224131.GK22104@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.7.5 (2ka.mipt.ru [0.0.0.0]); Wed, 14 Feb 2007 12:13:59 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 13, 2007 at 11:41:31PM +0100, Ingo Molnar (mingo@elte.hu) wrote:
> > Then limit it to a single page and use gup
> 
> 1024 (512 on 64-bit) is alot but not ALOT. It is also certainly not 
> ALOOOOT :-) Really, people will want to have more than 512 
> disks/spindles in the same box. I have used such a beast myself. For Tux 
> workloads and benchmarks we had parallelism levels of millions of 
> pending requests (!) on a single system - networking, socket limits, 
> disk IO combined with thousands of clients do create such scenarios. I 
> really think that such 'pinned pages' are a pretty natural fit for 
> sys_mlock() and RLIMIT_MEMLOCK, and since the kernel side is careful to 
> use the _inatomic() uaccess methods, it's safe (and fast) as well.

This will end up badly - I used the same approach in the early kevent
days and was proven to have swapable memory for the ring. I think it
would be much better to have userspace allocated ring and use
copy_to_user() there.

Btw, as a bit of advertisement, the whole completion part can be done
through kevent which already has ring buffer, queue operations and
non-racy updates... :)

> 	Ingo

-- 
	Evgeniy Polyakov
