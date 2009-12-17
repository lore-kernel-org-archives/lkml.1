Return-Path: <linux-kernel-owner+w=401wt.eu-S964798AbZLQKHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964798AbZLQKHZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 05:07:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764282AbZLQKHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 05:07:24 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.122]:54493 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764275AbZLQKHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 05:07:22 -0500
X-Authority-Analysis: v=1.0 c=1 a=OQTQEGK7ctAA:10 a=kNzghBICnV1Dk5q4yq8A:9 a=loyIBOlsRrV-A8SkNt8A:7 a=uUXpRZrquxoMJmzbhFFndRsz1d8A:4
X-Cloudmark-Score: 0
X-Originating-IP: 97.102.92.77
Message-ID: <4B2A02D8.2020208@cfl.rr.com>
Date: Thu, 17 Dec 2009 05:07:20 -0500
From: Mark Hounschell <dmarkh@cfl.rr.com>
Reply-To: dmarkh@cfl.rr.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: markh@compro.net, Alain Knaff <alain@knaff.lu>, fdutils@fdutils.linux.lu
Subject: Re: Unable to format or use floppies since 2.6.28
References: <4B215007.4030703@compro.net>
In-Reply-To: <4B215007.4030703@compro.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2009 02:46 PM, Mark Hounschell wrote:
> I have many boxes. They all do the same thing. Running different versions of SuSE, 10.3-11.2. Any kernel at or above 2.6.28 fails to fdformat a floppy. These same machines, using the same floppies and drives, running kernels older than 2.6.28 work just fine. I googled and found other such reports but no solution. I know better than to just assume it's a kernel bug but it sure looks like it could be so I'm inquiring about it here. 
> 
> 
> # fdformat /dev/fd0u1440
> Double-sided, 80 tracks, 18 sec/track. Total capacity 1440 kB.
> Formatting ... done
> Verifying ... Problem reading cylinder 1, expected 18432, read 2048
> 
> 
> dmesg from 2.6.32:
> 
> Dec 10 14:24:21 harley kernel: end_request: I/O error, dev fd0, sector 45
> Dec 10 14:24:21 harley kernel: Buffer I/O error on device fd0, logical block 5
> Dec 10 14:24:23 harley kernel: end_request: I/O error, dev fd0, sector 72
> Dec 10 14:24:23 harley kernel: Buffer I/O error on device fd0, logical block 9
> Dec 10 14:24:26 harley kernel: end_request: I/O error, dev fd0, sector 117
> Dec 10 14:24:26 harley kernel: Buffer I/O error on device fd0, logical block 14
> Dec 10 14:24:28 harley kernel: end_request: I/O error, dev fd0, sector 127
> Dec 10 14:24:28 harley kernel: Buffer I/O error on device fd0, logical block 15
> Dec 10 14:24:30 harley kernel: end_request: I/O error, dev fd0, sector 45
> Dec 10 14:24:30 harley kernel: Buffer I/O error on device fd0, logical block 5
> Dec 10 14:24:32 harley kernel: end_request: I/O error, dev fd0, sector 144
> Dec 10 14:24:32 harley kernel: Buffer I/O error on device fd0, logical block 18
> Dec 10 14:24:34 harley kernel: end_request: I/O error, dev fd0, sector 189
> Dec 10 14:24:34 harley kernel: Buffer I/O error on device fd0, logical block 23
> Dec 10 14:24:36 harley kernel: end_request: I/O error, dev fd0, sector 216
> Dec 10 14:24:36 harley kernel: Buffer I/O error on device fd0, logical block 27
> Dec 10 14:24:39 harley kernel: end_request: I/O error, dev fd0, sector 261
> Dec 10 14:24:39 harley kernel: Buffer I/O error on device fd0, logical block 32
> Dec 10 14:24:41 harley kernel: end_request: I/O error, dev fd0, sector 288
> Dec 10 14:24:41 harley kernel: Buffer I/O error on device fd0, logical block 36
> Dec 10 14:24:43 harley kernel: end_request: I/O error, dev fd0, sector 333
> Dec 10 14:24:43 harley kernel: Buffer I/O error on device fd0, logical block 41
> Dec 10 14:24:45 harley kernel: end_request: I/O error, dev fd0, sector 360
> Dec 10 14:24:45 harley kernel: Buffer I/O error on device fd0, logical block 45
> 
> 
> # rpm -qf /usr/sbin/fdformat
> util-linux-2.16-4.5.1.i586
> 
> Again, on this very machine, running 2.6.27.41 all is fine....
> 


The last known working kernel here is 2.6.27.41. 2.6.28 fails. How many from
changes 2.7.27 to 2.6.28?

There has been some development on this problem on the fdutils list. It turns
out that if dma is disabled, (floppy=nodma) fdformat works just fine on kernels
from 2.6.28 to current. So Alain Knaff is trying to help sort it out over on the
fdutils list.

Dan, I'm adding Alain Knaff and the fdutils list to the CC list and quoting your
response in this email so he will see it there. I don't thinkAlain has been
monitoring this list for this problem and it might help.

> On 12/17/2009 03:30 AM, Dan Carpenter wrote:
> I don't know if this is related to your bug, but it's a weirdness in
> floppy.c (from 2.6.32-rc8 sorry I suck for being up to date).
>
> drivers/block/floppy.c
>   2532          size = blk_rq_cur_bytes(current_req);
>   2533
>   2534          rq_for_each_segment(bv, current_req, iter) {
>   2535                  if (!remaining)
>   2536                          break;
>   2537
>   2538                  size = bv->bv_len;
>
> We never use the first size = blk_rq_cur_bytes() assignment.


What we have been able to see when dma is enabled appears to be corruption of
the track label buffer while in transit (dma) to the FDC. It seems that starting
with track 1 and then every 4 tracks or so after that, the track number in the
label for sector 0x0a is 1 less than it should be. We see the buffer (via
printks) is correct before and after transit but does not get transmitted
correctly when DMA is used.

The thread on the fdutils list is getting long but progress is being made.
Please CC that list if anyone can help further.

Thanks and regards
Mark
