Return-Path: <linux-kernel-owner+w=401wt.eu-S1751442AbXBMXYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751442AbXBMXYq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 18:24:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751452AbXBMXYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 18:24:46 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:4612 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbXBMXYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 18:24:45 -0500
X-AuthUser: davidel@xmailserver.org
Date: Tue, 13 Feb 2007 15:24:43 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
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
Subject: Re: [patch 00/11] ANNOUNCE: "Syslets", generic asynchronous system
 call support
In-Reply-To: <20070213215724.GD22104@elte.hu>
Message-ID: <Pine.LNX.4.64.0702131522120.32055@alien.or.mcafeemobile.com>
References: <20070213142010.GA638@elte.hu> <Pine.LNX.4.64.0702131219240.32055@alien.or.mcafeemobile.com>
 <20070213215724.GD22104@elte.hu>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Feb 2007, Ingo Molnar wrote:

> 
> * Davide Libenzi <davidel@xmailserver.org> wrote:
> 
> > > Open issues:
> 
> > If this is going to be a generic AIO subsystem:
> > 
> > - Cancellation of pending request
> 
> How about implementing aio_cancel() as a NOP. Can anyone prove that the 
> kernel didnt actually attempt to cancel that IO? [but unfortunately 
> failed at doing so, because the platters were being written already.]
> 
> really, what's the point behind aio_cancel()?

You need cancel. If you scheduled an async syscall, and the "session" 
linked with that chain is going away, you better have that canceled before 
cleaning up buffers to where the chain is going to read/write.
If you keep and hash or a tree indexed by atom-ptr, than become a matter 
of a lookup and sending a signal.



- Davide


