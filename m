Return-Path: <linux-kernel-owner+w=401wt.eu-S932294AbXBOAJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932294AbXBOAJF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 19:09:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932577AbXBOAJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 19:09:04 -0500
Received: from gw.goop.org ([64.81.55.164]:55829 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932294AbXBOAJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 19:09:03 -0500
Message-ID: <45D3A49B.4030608@goop.org>
Date: Wed, 14 Feb 2007 16:08:59 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Ingo Molnar <mingo@elte.hu>,
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
Subject: Re: [patch 00/11] ANNOUNCE: "Syslets", generic asynchronous system
 call support
References: <20070213142010.GA638@elte.hu> <45D3768B.7010902@goop.org> <Pine.LNX.4.64.0702141321410.7796@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0702141321410.7796@alien.or.mcafeemobile.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi wrote:
>> Would this work?
>>     
>
> Hopefully the API will simplify enough so that emulation will becomes 
> easier.
>   

The big question in my mind is how all this stuff interacts with
signals.  Can a blocked syscall atom be interrupted by a signal?  If so,
what thread does it get delivered to?  How does sigprocmask affect this
(is it atomic with respect to blocking atoms)?

>> Also, an unrelated question: is there enough control structure in place
>> to allow multiple syslet streams to synchronize with each other with
>> futexes?
>>     
>
> I think the whole point of an async execution of a syscall or a syslet, is 
> that the syscall/syslet itself includes a non interlocked operations with 
> other syscalls/syslets. So that the main scheduler thread can run in a 
> lockless/singletask fashion. There are no technical obstacles that 
> prevents you to do it, bu if you start adding locks (and hence having 
> long-living syslet-threads) at that point you'll end up with a fully 
> multithreaded solution.
>   

I was thinking you'd use the futexes more like barriers than locks. 
That way you could have several streams going asynchronously, but use
futexes to gang them together at appropriate times in the stream.  A
handwavy example would be to have separate async streams for audio and
video, but use futexes to stop them from drifting too far from each other.

    J
