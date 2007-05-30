Return-Path: <linux-kernel-owner+w=401wt.eu-S1757043AbXE3Re4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043AbXE3Re4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 13:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753330AbXE3Ret
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 13:34:49 -0400
Received: from brick.kernel.dk ([80.160.20.94]:10306 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118AbXE3Ret (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 13:34:49 -0400
Date: Wed, 30 May 2007 19:33:55 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Zach Brown <zach.brown@oracle.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Syslets, Threadlets, generic AIO support, v6
Message-ID: <20070530173353.GO15559@kernel.dk>
References: <20070529212718.GH7875@mami.zabbo.net> <20070530074031.GV15559@kernel.dk> <20070530165511.GB5488@mami.zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070530165511.GB5488@mami.zabbo.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30 2007, Zach Brown wrote:
> > Yeah, it'll confuse CFQ a lot actually. The threads either need to share
> > an io context (clean approach, however will introduce locking for things
> > that were previously lockless), or CFQ needs to get better support for
> > cooperating processes.
> 
> Do let me know if I can be of any help in this.

Thanks, it should not be a lot of work though.

> > For the fio testing, we can make some improvements there. Right now you
> > don't get any concurrency of the io requests if you set eg iodepth=32,
> > as the 32 requests will be submitted as a linked chain of atoms. For io
> > saturation, that's not really what you want.
> 
> Just to be clear: I'm currently focusing on supporting sys_io_*() so I'm
> using fio's libaio engine.  I'm not testing the syslet syscall interface
> yet.

Ah ok, then there's no issue from that end!

-- 
Jens Axboe

