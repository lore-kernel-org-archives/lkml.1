Return-Path: <linux-kernel-owner+w=401wt.eu-S964825AbXBOCHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964825AbXBOCHe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 21:07:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964829AbXBOCHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 21:07:34 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:3925 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964825AbXBOCHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 21:07:33 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 14 Feb 2007 18:07:30 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Ingo Molnar <mingo@elte.hu>,
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
In-Reply-To: <45D3A49B.4030608@goop.org>
Message-ID: <Pine.LNX.4.64.0702141756450.7796@alien.or.mcafeemobile.com>
References: <20070213142010.GA638@elte.hu> <45D3768B.7010902@goop.org>
 <Pine.LNX.4.64.0702141321410.7796@alien.or.mcafeemobile.com>
 <45D3A49B.4030608@goop.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Feb 2007, Jeremy Fitzhardinge wrote:

> Davide Libenzi wrote:
> >> Would this work?
> >>     
> >
> > Hopefully the API will simplify enough so that emulation will becomes 
> > easier.
> >   
> 
> The big question in my mind is how all this stuff interacts with
> signals.  Can a blocked syscall atom be interrupted by a signal?  If so,
> what thread does it get delivered to?  How does sigprocmask affect this
> (is it atomic with respect to blocking atoms)?

Signal context is another thing that we need to transfer to the 
return-to-userspace task, in case we switch. Async threads inherit that 
from the "main" task once they're created, but from there to the 
sys_async_exec syscall, userspace might have changed the signal context, 
and re-emerging with a different one is not an option ;)
We should setup service-threds signal context, so that we can cancel them, 
but the implementation should be hidden to userspace (that will use 
sys_async_cancel - or whatever name -  to do that).



- Davide


