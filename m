Return-Path: <linux-kernel-owner+w=401wt.eu-S1751395AbXBMWrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395AbXBMWrj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 17:47:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbXBMWrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 17:47:39 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44047 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbXBMWri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 17:47:38 -0500
Date: Tue, 13 Feb 2007 23:47:35 +0100
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
Message-ID: <20070213224735.GL29492@one.firstfloor.org>
References: <20070213142010.GA638@elte.hu> <Pine.LNX.4.64.0702131219240.32055@alien.or.mcafeemobile.com> <20070213215724.GD22104@elte.hu> <p733b59hc81.fsf@bingen.suse.de> <20070213222626.GI22104@elte.hu> <20070213223220.GK29492@one.firstfloor.org> <20070213224322.GL22104@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070213224322.GL22104@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> ok. The TID+signal approach i mentioned in the other reply should work. 

Not sure if a signal is good for this. It might conflict with existing
strange historical semantics.

> If it's frequent enough we could make this an explicit 
> sys_async_cancel(TID) API.

Ideally there should be a new function like signal_pending() that checks for
this. Then the network fs could check those in their blocking loops
and error out.

Then it would even work on non intr NFS mounts.

-Andi
