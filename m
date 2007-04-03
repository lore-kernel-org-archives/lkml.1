Return-Path: <linux-kernel-owner+w=401wt.eu-S933612AbXDCQb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933612AbXDCQb5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 12:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933636AbXDCQb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 12:31:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60277 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933612AbXDCQb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 12:31:56 -0400
Message-ID: <46128175.2090506@redhat.com>
Date: Tue, 03 Apr 2007 12:31:49 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (Macintosh/20070221)
MIME-Version: 1.0
To: Paa Paa <paapaa125@hotmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Lower HD transfer rate with NCQ enabled?
References: <BAY20-F50719E454DCCF2309DA1AF9670@phx.gbl>
In-Reply-To: <BAY20-F50719E454DCCF2309DA1AF9670@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paa Paa wrote:
> I'm using Linux 2.6.20.4. I noticed that I get lower SATA hard drive 
> throughput with 2.6.20.4 than with 2.6.19. The reason was that 2.6.20 
> enables NCQ by defauly (queue_depth = 31/32 instead of 0/32). Transfer 
> rate was measured using "hdparm -t":
> 
> With NCQ (queue_depth == 31): 50MB/s.
> Without NCQ (queue_depth == 0): 60MB/s.
> 
> 20% difference is quite a lot. This is with Intel ICH8R controller and 
> Western Digital WD1600YS hard disk in AHCI mode. I also used the next 
> command to cat-copy a biggish (540MB) file and time it:
> 
> rm temp && sync && time sh -c 'cat quite_big_file > temp && sync'
> 
> Here I noticed no differences at all with and without NCQ. The times 
> (real time) were basically the same in many successive runs. Around 19s.
> 
> Q: What conclusion can I make on "hdparm -t" results or can I make any 
> conclusions? Do I really have lower performance with NCQ or not? If I 
> do, is this because of my HD or because of kernel?

hdparm -t is a perfect example of a synthetic benchmark.  NCQ was 
designed to optimize real-world workloads.  The overhead gets hidden 
pretty well when there are multiple requests in flight simultaneously, 
as tends to be the case when you have a user thread reading data while a 
kernel thread is asynchronously flushing the user thread's buffered 
writes.  Given that you're breaking even with one user thread and one 
kernel thread doing I/O, you'll probably get performance improvements 
with higher thread counts.

	-- Chris
