Return-Path: <linux-kernel-owner+w=401wt.eu-S1759034AbXE3Vh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759034AbXE3Vh3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 17:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758304AbXE3Vgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 17:36:32 -0400
Received: from gw.goop.org ([64.81.55.164]:50338 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758207AbXE3Vgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 17:36:31 -0400
Message-ID: <465DEE59.9070901@goop.org>
Date: Wed, 30 May 2007 14:36:25 -0700
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
References: <20070529212718.GH7875@mami.zabbo.net> <465CA654.5000505@garzik.org> <20070530072055.GA3077@elte.hu> <465D286E.2080807@redhat.com> <20070530084252.GA15708@elte.hu> <Pine.LNX.4.64.0705301148150.6272@alien.or.mcafeemobile.com> <alpine.LFD.0.98.0705301254210.26602@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705301254210.26602@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> Which *could* be something as simple as saying "bit 30 in the file 
> descriptor specifies a separate fd space" along with some flags to make 
> open and friends return those separate fd's. That makes them useless for 
> "select()" (which assumes a flat address space, of course), but would be 
> useful for just about anything else.
>   

Some programs - legitimately, I think - scan /proc/self/fd to close
everything.  The question is whether the glibc-private fds should appear
there.  And something like a "close-on-fork" flag might be useful,
though I guess glibc can keep track of its own fds closely enough to not
need something like that.

    J
