Return-Path: <linux-kernel-owner+w=401wt.eu-S1751364AbXBMWcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751364AbXBMWcW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 17:32:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbXBMWcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 17:32:22 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39307 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbXBMWcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 17:32:21 -0500
Date: Tue, 13 Feb 2007 23:32:20 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/11] ANNOUNCE: "Syslets", generic asynchronous system call support
Message-ID: <20070213223220.GK29492@one.firstfloor.org>
References: <20070213142010.GA638@elte.hu> <Pine.LNX.4.64.0702131219240.32055@alien.or.mcafeemobile.com> <20070213215724.GD22104@elte.hu> <p733b59hc81.fsf@bingen.suse.de> <20070213222626.GI22104@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070213222626.GI22104@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 13, 2007 at 11:26:26PM +0100, Ingo Molnar wrote:
> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > > really, what's the point behind aio_cancel()?
> > 
> > The main use case is when you open a file requester on a network file 
> > system where the server is down and you get tired of waiting and press 
> > "Cancel" it should abort the hanging IO immediately.
> 
> ok, that should work fine already - exit in the user context gets 

That would be a little heavy handed. I wouldn't expect my GUI
program to quit itself on cancel. And requiring it to create a new
thread just to exit on cancel would be also nasty.

And of course you cannot interrupt blocked IOs this way right now
(currently it only works with signals in some cases on NFS)

-Andi
