Return-Path: <linux-kernel-owner+w=401wt.eu-S932178AbXCUGyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178AbXCUGyp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 02:54:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932231AbXCUGyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 02:54:45 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:33311 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178AbXCUGyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 02:54:43 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 20 Mar 2007 23:54:22 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: AIO, FIO and Threads ...
In-Reply-To: <Pine.LNX.4.64.0703202146570.28960@alien.or.mcafeemobile.com>
Message-ID: <Pine.LNX.4.64.0703202350280.28960@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0703202146570.28960@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Mar 2007, Davide Libenzi wrote:

> 
> I was looking at Jens FIO stuff, and I decided to cook a quick patch for 
> FIO to support GUASI (Generic Userspace Asyncronous Syscall Interface):
> 
> http://www.xmailserver.org/guasi-lib.html
> 
> I then ran a few tests on my Dual Opteron 252 with SATA drives (sata_nv) 
> and 8GB of RAM.
> Mind that I'm not FIO expert, like at all, but I got some interesting 
> results when comparing GUASI with libaio at 8/1000/10000 depths.
> If I read those result correctly (Jens may help), GUASI output is more 
> then double the libaio one.
> Lots of context switches, yes. But the throughput looks like 2+ times.
> Can someone try to repeat the measures and/or spot the error?
> Or tell me which other tests to run?
> This is kinda a suprise for me ...

Tests with block sizes bigger than 4KB bring libaio performance close to 
GUASI, but not quite:

http://www.xmailserver.org/guasi-libaio-fio-results-1.txt

I dropped the last FIO+GUASI patch here:

http://www.xmailserver.org/fio-guasi-0.5.diff

And Jens FIO is here:

http://brick.kernel.dk/snaps/



- Davide


