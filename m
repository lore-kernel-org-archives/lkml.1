Return-Path: <linux-kernel-owner+w=401wt.eu-S1758594AbXE3ULK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758594AbXE3ULK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 16:11:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756088AbXE3UK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 16:10:56 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:33328 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418AbXE3UK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 16:10:56 -0400
Message-ID: <465DD97D.9010807@cosmosbay.com>
Date: Wed, 30 May 2007 22:07:25 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Mark Lord <lkml@rtr.ca>, Ingo Molnar <mingo@elte.hu>,
       Jeff Garzik <jeff@garzik.org>, Zach Brown <zach.brown@oracle.com>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
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
References: <20070529212718.GH7875@mami.zabbo.net> <465CA654.5000505@garzik.org> <20070530072055.GA3077@elte.hu> <465D43A0.8040307@garzik.org> <alpine.LFD.0.98.0705300820350.26602@woody.linux-foundation.org> <20070530160913.GA14261@elte.hu> <465DCAE4.1010206@rtr.ca> <alpine.LFD.0.98.0705301212520.26602@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705301212520.26602@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Wed, 30 May 2007 22:07:32 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds a écrit :
> 
> On Wed, 30 May 2007, Mark Lord wrote:
>> I wonder how useful it would be to reimplement sendfile()
>> using splice(), either in glibc or inside the kernel itself?
> 
> I'd like that, if only because right now we have two separate paths that 
> kind of do the same thing, and splice really is the only one that is 
> generic.
> 
> I thought Jens even had some experimental patches for it. It might be 
> worth to "just do it" - there's some internal overhead, but on the other 
> hand, it's also likely the best way to make sure any issues get sorted 
> out.
> 

Last time I played with splice(), I found a bug with readahead logic, most 
probably because nobody but me tried it before.

(corrected by Fengguang Wu in commit 9ae9d68cbf3fe0ec17c17c9ecaa2188ffb854a66 )

So yes, reimplement sendfile() should help to find last splice() bugs, and as 
a bonus it could add non blocking disk io, (O_NONBLOCK on input file -> socket)


