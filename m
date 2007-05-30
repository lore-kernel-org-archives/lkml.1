Return-Path: <linux-kernel-owner+w=401wt.eu-S1752308AbXE3Hl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbXE3Hl3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 03:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbXE3HlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 03:41:22 -0400
Received: from brick.kernel.dk ([80.160.20.94]:14568 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbXE3HlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 03:41:21 -0400
Date: Wed, 30 May 2007 09:40:32 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Zach Brown <zach.brown@oracle.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Syslets, Threadlets, generic AIO support, v6
Message-ID: <20070530074031.GV15559@kernel.dk>
References: <20070529212718.GH7875@mami.zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070529212718.GH7875@mami.zabbo.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29 2007, Zach Brown wrote:

Thanks for picking this up, Zach!

>  - cfq gets confused, share io_context amongst threads?

Yeah, it'll confuse CFQ a lot actually. The threads either need to share
an io context (clean approach, however will introduce locking for things
that were previously lockless), or CFQ needs to get better support for
cooperating processes. The problem is that CFQ will wait for a dependent
IO for a given process, which may arrive from a totally unrelated
process.

For the fio testing, we can make some improvements there. Right now you
don't get any concurrency of the io requests if you set eg iodepth=32,
as the 32 requests will be submitted as a linked chain of atoms. For io
saturation, that's not really what you want.

I'll take a stab at improving both of the above.

-- 
Jens Axboe

