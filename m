Return-Path: <linux-kernel-owner+w=401wt.eu-S932339AbXB1TEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339AbXB1TEW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 14:04:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932334AbXB1TEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 14:04:22 -0500
Received: from zcars04f.nortel.com ([47.129.242.57]:42712 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932339AbXB1TEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 14:04:21 -0500
Message-ID: <45E5D217.9060101@nortel.com>
Date: Wed, 28 Feb 2007 13:03:51 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
References: <20070221211355.GA7302@elte.hu> <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com> <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com> <20070222074044.GA4158@elte.hu> <Pine.LNX.4.64.0702221130050.1356@alien.or.mcafeemobile.com> <20070228094522.GA17716@elte.hu> <Pine.LNX.4.64.0702280740250.5935@alien.or.mcafeemobile.com> <Pine.LNX.4.64.0702280836080.12485@woody.linux-foundation.org> <Pine.LNX.4.64.0702281011220.6806@alien.or.mcafeemobile.com> <Pine.LNX.4.64.0702281040030.12485@woody.linux-foundation.org> <Pine.LNX.4.64.0702281047430.6806@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0702281047430.6806@alien.or.mcafeemobile.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Feb 2007 19:03:56.0660 (UTC) FILETIME=[3248AB40:01C75B6B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi wrote:

> struct async_syscall {
> 	unsigned long nr_sysc;
> 	unsigned long params[8];
> 	long *result;
> };
> 
> And what would async_wait() return bak? Pointers to "struct async_syscall"
> or pointers to "result"?

Either one has downsides.  Pointer to struct async_syscall requires that 
the caller keep the struct around.  Pointer to result requires that the 
caller always reserve a location for the result.

Does the kernel care about the (possibly rare) case of callers that 
don't want to pay attention to result?  If so, what about adding some 
kind of caller-specified handle to struct async_syscall, and having 
async_wait() return the handle?  In the case where the caller does care 
about the result, the handle could just be the address of result.

Chris



