Return-Path: <linux-kernel-owner+w=401wt.eu-S1750712AbXBMO7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750712AbXBMO7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 09:59:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750713AbXBMO7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 09:59:13 -0500
Received: from kanga.kvack.org ([66.96.29.28]:36695 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712AbXBMO7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 09:59:13 -0500
Date: Tue, 13 Feb 2007 09:58:48 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: Alan <alan@lxorguk.ukuu.org.uk>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/11] ANNOUNCE: "Syslets", generic asynchronous system call support
Message-ID: <20070213145848.GS18311@kvack.org>
References: <20060529212109.GA2058@elte.hu> <20070213142010.GA638@elte.hu> <20070213150019.4b4d4827@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070213150019.4b4d4827@localhost.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 13, 2007 at 03:00:19PM +0000, Alan wrote:
> > Open issues:
> 
> Let me add some more

Also: FPU state (especially important with the FPU and SSE memory copy 
variants), segment register bases on x86-64, interaction with set_fs()...  
There is no easy way of getting around the full thread context switch and 
its associated overhead (mucking around in CR0 is one of the more expensive 
bits of the context switch code path, and at the very least, setting the FPU 
not present is mandatory).  I have looked into exactly this approach, and 
it's only cheaper if the code is incomplete.  Linux's native threads are 
pretty damned good.

		-ben
-- 
"Time is of no importance, Mr. President, only life is important."
Don't Email: <dont@kvack.org>.
