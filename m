Return-Path: <linux-kernel-owner+w=401wt.eu-S1161054AbXBVLxd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161054AbXBVLxd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 06:53:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161061AbXBVLxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 06:53:33 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:47982 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161054AbXBVLxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 06:53:32 -0500
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
From: Arjan van de Ven <arjan@infradead.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Ingo Molnar <mingo@elte.hu>, Ulrich Drepper <drepper@redhat.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070222113148.GA3781@2ka.mipt.ru>
References: <20070221211355.GA7302@elte.hu>
	 <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com>
	 <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com>
	 <20070222074044.GA4158@elte.hu>  <20070222113148.GA3781@2ka.mipt.ru>
Content-Type: text/plain
Organization: Intel International BV
Date: Thu, 22 Feb 2007 12:52:39 +0100
Message-Id: <1172145159.3531.253.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> It is not a TUX anymore - you had 1024 threads, and all of them will be
> consumed by tcp_sendmsg() for slow clients - rescheduling will kill a
> machine.

I think it's time to make a split in what "context switch" or
"reschedule" means...

there are two types of context switch:

1) To a different process. This means teardown of the TLB, going to a
new MMU state, saving FPU state etc etc etc. This is obviously quite
expensive

2) To a thread of the same process. No TLB flush no new MMU state,
effectively all it does is getting a new task struct on the kernel side,
and a new ESP/EIP pair on the userspace side. If there is FPU code
involved that gets saved as well.

Number 1 is very expensive and that is what is really worrying normally;
number 2 is a LOT lighter weight, and while Linux is a bit heavy there,
it can be made lighter... there's no fundamental reason for it to be
really expensive.

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

