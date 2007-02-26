Return-Path: <linux-kernel-owner+w=401wt.eu-S1030247AbXBZN7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030247AbXBZN7l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 08:59:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030246AbXBZN7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 08:59:41 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:41449 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030247AbXBZN7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 08:59:39 -0500
Date: Mon, 26 Feb 2007 14:57:36 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Suparna Bhattacharya <suparna@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: A quick fio test (was Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3)
Message-ID: <20070226135736.GF3822@kernel.dk>
References: <20070221211355.GA7302@elte.hu> <20070223125247.GO5737@kernel.dk> <20070223135525.GA31569@in.ibm.com> <20070223145826.GA32465@elte.hu> <20070223151515.GA12960@in.ibm.com> <20070223162508.GA16782@kernel.dk> <20070223171348.GA27838@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070223171348.GA27838@in.ibm.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Some more results, using a larger number of processes and io depths. A
repeat of the tests from friday, with added depth 20000 for syslet and
libaio:

Engine          Depth   Processes       Bw (MiB/sec)
----------------------------------------------------
libaio            1         1            602
syslet            1         1            759
sync              1         1            776
libaio           32         1            832
syslet           32         1            898
libaio        20000         1            581
syslet        20000         1            609

syslet still on top. Measuring O_DIRECT reads (of 4kb size) on ramfs
with 100 processes each with a depth of 200, reading a per-process
private file of 10mb (need to fit in my ram...) 10 times each. IOW,
doing 10,000MiB of IO in total:

Engine          Depth   Processes       Bw (MiB/sec)
----------------------------------------------------
libaio           200       100            1488
syslet           200       100            1714

Results are stable to within approx +/- 10MiB/sec. The syslet case
completes a whole second faster than libaio (~6 vs ~7 seconds). Testing
was done with fio HEAD eb7c8ae27bc301b77490b3586dd5ccab7c95880a, and it
uses the v4 patch series.

Engine          Depth   Processes       Bw (MiB/sec)
----------------------------------------------------
libaio            200       100            1488
syslet            200       100            1714
sync              200       100            1843

-- 
Jens Axboe

