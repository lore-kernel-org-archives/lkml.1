Return-Path: <linux-kernel-owner+w=401wt.eu-S2992658AbXCBR2P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992658AbXCBR2P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 12:28:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992659AbXCBR2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 12:28:15 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:3060 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992658AbXCBR2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 12:28:14 -0500
X-AuthUser: davidel@xmailserver.org
Date: Fri, 2 Mar 2007 09:28:10 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
cc: Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@ucw.cz>,
       Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
In-Reply-To: <20070302110820.GA25908@2ka.mipt.ru>
Message-ID: <Pine.LNX.4.64.0703020921430.1977@alien.or.mcafeemobile.com>
References: <20070227121116.GA31597@2ka.mipt.ru> <20070228161413.GA4319@ucw.cz>
 <20070301081808.GD7217@2ka.mipt.ru> <20070301092634.GB20171@elf.ucw.cz>
 <20070301094723.GJ7217@2ka.mipt.ru> <20070301101102.GE20171@elf.ucw.cz>
 <20070301111815.GB15709@2ka.mipt.ru> <20070302102714.GB27687@elf.ucw.cz>
 <20070302103713.GB28444@2ka.mipt.ru> <20070302105618.GA18377@elte.hu>
 <20070302110820.GA25908@2ka.mipt.ru>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Mar 2007, Evgeniy Polyakov wrote:

> do we really want to have per process signalfs, timerfs and so on - each 
> simple structure must be bound to a file, which becomes too cost.

I may be old school, but if you ask me, and if you *really* want those 
events, yes. Reason? Unix's everything-is-a-file rule, and being able to 
use them with *existing* POSIX poll/select. Remember, not every app 
requires huge scalability efforts, so working with simpler and familiar 
APIs is always welcome.
The *only* thing that was not practical to have as fd, was block requests. 
But maybe threadlets/syslets will handle those just fine, and close the gap.



- Davide


