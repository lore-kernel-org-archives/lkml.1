Return-Path: <linux-kernel-owner+w=401wt.eu-S1030254AbXBZOHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030254AbXBZOHr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 09:07:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030241AbXBZOHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 09:07:47 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:43306 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030254AbXBZOHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 09:07:46 -0500
Date: Mon, 26 Feb 2007 19:43:15 +0530
From: Suparna Bhattacharya <suparna@in.ibm.com>
To: Jens Axboe <jens.axboe@oracle.com>
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
Message-ID: <20070226141315.GA15631@in.ibm.com>
Reply-To: suparna@in.ibm.com
References: <20070221211355.GA7302@elte.hu> <20070223125247.GO5737@kernel.dk> <20070223135525.GA31569@in.ibm.com> <20070223145826.GA32465@elte.hu> <20070223151515.GA12960@in.ibm.com> <20070223162508.GA16782@kernel.dk> <20070223171348.GA27838@in.ibm.com> <20070226135736.GF3822@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070226135736.GF3822@kernel.dk>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 26, 2007 at 02:57:36PM +0100, Jens Axboe wrote:
> 
> Some more results, using a larger number of processes and io depths. A
> repeat of the tests from friday, with added depth 20000 for syslet and
> libaio:
> 
> Engine          Depth   Processes       Bw (MiB/sec)
> ----------------------------------------------------
> libaio            1         1            602
> syslet            1         1            759
> sync              1         1            776
> libaio           32         1            832
> syslet           32         1            898
> libaio        20000         1            581
> syslet        20000         1            609
> 
> syslet still on top. Measuring O_DIRECT reads (of 4kb size) on ramfs
> with 100 processes each with a depth of 200, reading a per-process
> private file of 10mb (need to fit in my ram...) 10 times each. IOW,
> doing 10,000MiB of IO in total:

But, why ramfs ? Don't we want to exercise the case where O_DIRECT actually
blocks ? Or am I missing something here ?

Regards
Suparna

> 
> Engine          Depth   Processes       Bw (MiB/sec)
> ----------------------------------------------------
> libaio           200       100            1488
> syslet           200       100            1714
> 
> Results are stable to within approx +/- 10MiB/sec. The syslet case
> completes a whole second faster than libaio (~6 vs ~7 seconds). Testing
> was done with fio HEAD eb7c8ae27bc301b77490b3586dd5ccab7c95880a, and it
> uses the v4 patch series.
> 
> Engine          Depth   Processes       Bw (MiB/sec)
> ----------------------------------------------------
> libaio            200       100            1488
> syslet            200       100            1714
> sync              200       100            1843
> 
> -- 
> Jens Axboe

-- 
Suparna Bhattacharya (suparna@in.ibm.com)
Linux Technology Center
IBM Software Lab, India

