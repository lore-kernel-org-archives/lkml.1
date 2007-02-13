Return-Path: <linux-kernel-owner+w=401wt.eu-S1751352AbXBMWZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352AbXBMWZJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 17:25:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbXBMWZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 17:25:09 -0500
Received: from ns.suse.de ([195.135.220.2]:49621 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352AbXBMWZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 17:25:07 -0500
To: Ingo Molnar <mingo@elte.hu>
Cc: Davide Libenzi <davidel@xmailserver.org>,
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
References: <20070213142010.GA638@elte.hu>
	<Pine.LNX.4.64.0702131219240.32055@alien.or.mcafeemobile.com>
	<20070213215724.GD22104@elte.hu>
From: Andi Kleen <andi@firstfloor.org>
Date: 14 Feb 2007 00:25:18 +0100
In-Reply-To: <20070213215724.GD22104@elte.hu>
Message-ID: <p733b59hc81.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:
> 
> really, what's the point behind aio_cancel()?

The main use case is when you open a file requester on a network
file system where the server is down and you get tired of waiting
and press "Cancel" it should abort the hanging IO immediately.

At least I would appreciate such a feature sometimes.

e.g. the readdir loop could be a syslet (are they powerful
enough to allocate memory for a arbitary sized directory? Probably not) 
and then the cancel button could async_cancel() it.

-Andi

