Return-Path: <linux-kernel-owner+w=401wt.eu-S1756315AbXE3TRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315AbXE3TRb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 15:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753731AbXE3TRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 15:17:20 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44155 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753529AbXE3TRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 15:17:19 -0400
Date: Wed, 30 May 2007 12:15:35 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mark Lord <lkml@rtr.ca>
cc: Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jeff@garzik.org>,
       Zach Brown <zach.brown@oracle.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Syslets, Threadlets, generic AIO support, v6
In-Reply-To: <465DCAE4.1010206@rtr.ca>
Message-ID: <alpine.LFD.0.98.0705301212520.26602@woody.linux-foundation.org>
References: <20070529212718.GH7875@mami.zabbo.net> <465CA654.5000505@garzik.org>
 <20070530072055.GA3077@elte.hu> <465D43A0.8040307@garzik.org>
 <alpine.LFD.0.98.0705300820350.26602@woody.linux-foundation.org>
 <20070530160913.GA14261@elte.hu> <465DCAE4.1010206@rtr.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 May 2007, Mark Lord wrote:
>
> I wonder how useful it would be to reimplement sendfile()
> using splice(), either in glibc or inside the kernel itself?

I'd like that, if only because right now we have two separate paths that 
kind of do the same thing, and splice really is the only one that is 
generic.

I thought Jens even had some experimental patches for it. It might be 
worth to "just do it" - there's some internal overhead, but on the other 
hand, it's also likely the best way to make sure any issues get sorted 
out.

		Linus
