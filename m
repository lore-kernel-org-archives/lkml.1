Return-Path: <linux-kernel-owner+w=401wt.eu-S932922AbXB0LQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932922AbXB0LQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 06:16:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932997AbXB0LQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 06:16:17 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:47089 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932922AbXB0LQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 06:16:17 -0500
Date: Tue, 27 Feb 2007 14:12:59 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Suparna Bhattacharya <suparna@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: A quick fio test (was Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3)
Message-ID: <20070227111258.GA19125@2ka.mipt.ru>
References: <20070223135525.GA31569@in.ibm.com> <20070223145826.GA32465@elte.hu> <20070223151515.GA12960@in.ibm.com> <20070223162508.GA16782@kernel.dk> <20070223171348.GA27838@in.ibm.com> <20070226135736.GF3822@kernel.dk> <20070226141315.GA15631@in.ibm.com> <20070226144548.GH3822@kernel.dk> <20070227043331.GA29942@in.ibm.com> <20070227094211.GR3822@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070227094211.GR3822@kernel.dk>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Tue, 27 Feb 2007 14:13:46 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

My two coins:
# cat job
[global]
bs=8k
size=1g
direct=0
ioengine=sync
iodepth=32
rw=read

[file]
filename=/home/user/test

sync: 
READ: io=1,024MiB, aggrb=39,329KiB/s, minb=39,329KiB/s,
maxb=39,329KiB/s, mint=27301msec, maxt=27301msec

libaio:
READ: io=1,024MiB, aggrb=39,435KiB/s, minb=39,435KiB/s,
maxb=39,435KiB/s, mint=27228msec, maxt=27228msec

syslet-rw:
READ: io=1,024MiB, aggrb=29,567KiB/s, minb=29,567KiB/s,
maxb=29,567KiB/s, mint=36315msec, maxt=36315msec

During syslet-rw test about 9500 async schduledes happend.
I use fio-git-20070226150114.tar.gz

P.S. Jens, fio_latest.tar.gz has wrong permissions, it can not be
opened.

-- 
	Evgeniy Polyakov
