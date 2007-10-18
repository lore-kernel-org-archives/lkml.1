Return-Path: <linux-kernel-owner+w=401wt.eu-S1764138AbXJRUwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764138AbXJRUwd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 16:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762451AbXJRUwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 16:52:23 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:43063 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762485AbXJRUwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 16:52:22 -0400
Message-ID: <4717C776.5020809@garzik.org>
Date: Thu, 18 Oct 2007 16:52:06 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, Mark Lord <lkml@rtr.ca>
Subject: Re: libata crash
References: <20071018164745.GD10674@kernel.dk> <20071018192839.GA17247@elte.hu> <20071018193236.GJ10674@kernel.dk> <20071018195903.GA29567@elte.hu> <20071018204111.GN10674@kernel.dk>
In-Reply-To: <20071018204111.GN10674@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Thu, Oct 18 2007, Ingo Molnar wrote:
>> * Jens Axboe <jens.axboe@oracle.com> wrote:
>>
>>> I'll see if I can spend some time tonight chopping the patch into 
>>> digestable pieces, unfortunately I'll be away the next three days. And 
>>> it would be nice to get this thing merged asap.
>> and make sure it builds:
>>
>> drivers/scsi/fd_mcs.c: In function 'fd_mcs_intr':
>> drivers/scsi/fd_mcs.c:976: error: 'struct scatterlist' has no member named 'page'
>> drivers/scsi/fd_mcs.c:1009: error: 'struct scatterlist' has no member named 'page'
>> drivers/scsi/fd_mcs.c: In function 'fd_mcs_queue':
>> drivers/scsi/fd_mcs.c:1112: error: 'struct scatterlist' has no member named 'page'
>> drivers/scsi/in2000.c: In function 'in2000_queuecommand':
>> drivers/scsi/in2000.c:375: error: 'struct scatterlist' has no member named 'page'
>> drivers/scsi/in2000.c: In function 'transfer_bytes':
>> drivers/scsi/in2000.c:767: error: 'struct scatterlist' has no member named 'page'
> 
> Oops, wonder why they were missed in the allyes/modconfig. Fixed now,
> thanks!

Building on x86-64, I'm betting?  :)

I fell victim to the same thing a few days ago, missing some compile 
breakage that only appeared with

     make ARCH=i386 allmodconfig && make ARCH=i386 -sj9

Though am I alone in dreaming of a kernel.org service that would permit 
all-arch build testing of a git URL?

Regards,

	Jeff



