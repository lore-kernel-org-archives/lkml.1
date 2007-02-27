Return-Path: <linux-kernel-owner+w=401wt.eu-S1751633AbXB0N4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633AbXB0N4v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 08:56:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751639AbXB0N4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 08:56:51 -0500
Received: from il.qumranet.com ([82.166.9.18]:35375 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630AbXB0N4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 08:56:50 -0500
Message-ID: <45E43827.4000102@argo.co.il>
Date: Tue, 27 Feb 2007 15:54:47 +0200
From: Avi Kivity <avi@argo.co.il>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: suparna@in.ibm.com
CC: Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: A quick fio test (was Re: [patch 00/13] Syslets, "Threadlets",
 generic AIO support, v3)
References: <20070221211355.GA7302@elte.hu> <20070223125247.GO5737@kernel.dk> <20070223135525.GA31569@in.ibm.com> <20070223145826.GA32465@elte.hu> <20070223151515.GA12960@in.ibm.com> <20070223162508.GA16782@kernel.dk> <20070223171348.GA27838@in.ibm.com> <20070226135736.GF3822@kernel.dk> <20070226141315.GA15631@in.ibm.com> <20070226144548.GH3822@kernel.dk> <20070227043331.GA29942@in.ibm.com>
In-Reply-To: <20070227043331.GA29942@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Suparna Bhattacharya wrote:
> I tried the latest fio code with syslet v4, and my results are a little
> different - have yet to figure out why or what to make of it.
> I hope I have all the right pieces now.
>
> This is an ext2 filesystem, SCSI AIC7xxx.
>
> I used an iodepth_batch size of 8 to limit the number of ios in a single
> io_submit (thanks for adding that parameter to fio !), like we did in
> aio-stress.
>
> Engine          Depth      Batch	Bw (KiB/sec)
> ----------------------------------------------------
> libaio		64	   8		17,226
> syslet		64	   8		17,620
> libaio		20000	   8		18,552
> syslet		20000	   8		14,935
>
>
> Which is not bad, actually.
>
> If I do not specify the iodepth_batch (i.e. default to depth), then the
> difference becomes more pronounced at higher depths. However, I doubt
> whether anyone would be using such high batch sizes in practice ...
>
> Engine          Depth      Batch	Bw (KiB/sec)
> ----------------------------------------------------
> libaio		64	   default	17,429
> syslet		64	   default	16,155
> libaio		20000	   default	15,494
> syslet		20000	   default	7,971
>   

But what about cpu usage?  At these low levels, the cpu is probably 
underutilized.  It would be interesting to measure cpu time per I/O 
request (or, alternatively, use an I/O subsystem that can saturate the 
processors).


-- 
error compiling committee.c: too many arguments to function

