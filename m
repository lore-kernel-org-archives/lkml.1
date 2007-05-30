Return-Path: <linux-kernel-owner+w=401wt.eu-S1759743AbXE3Vyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759743AbXE3Vyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 17:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758088AbXE3Vyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 17:54:38 -0400
Received: from gw.goop.org ([64.81.55.164]:54449 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757694AbXE3Vyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 17:54:37 -0400
Message-ID: <465DF299.6030208@goop.org>
Date: Wed, 30 May 2007 14:54:33 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Ulrich Drepper <drepper@redhat.com>, Jeff Garzik <jeff@garzik.org>,
       Zach Brown <zach.brown@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Syslets, Threadlets, generic AIO support, v6
References: <20070529212718.GH7875@mami.zabbo.net> <465CA654.5000505@garzik.org> <20070530072055.GA3077@elte.hu> <465D286E.2080807@redhat.com> <20070530084252.GA15708@elte.hu> <Pine.LNX.4.64.0705301148150.6272@alien.or.mcafeemobile.com> <alpine.LFD.0.98.0705301254210.26602@woody.linux-foundation.org> <465DEE59.9070901@goop.org> <alpine.LFD.0.98.0705301442000.26602@woody.linux-foundation.org> <alpine.LFD.0.98.0705301446070.26602@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705301446070.26602@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> Side note: it might not even be a "close-on-exec by default" thing: it 
> might well be a *always* close-on-exec.
>
> That COE is pretty horrid to do, we need to scan a bitmap of those things 
> on each exec. So it migth be totally sensible to just declare that the 
> non-linear fd's would simply always be "local", and never bleed across an 
> execve).

Hm, I wouldn't limit the mechanism prematurely.  Using Valgrind as an
example of an alternate user of this mechanism, it would be useful to
use a pipe to transmit out-of-band information from an exec-er to an
exec-ee process.  At the moment there's a lot mucking around with
execve() to transmit enough information from the parent valgrind to its
successor.

    J
