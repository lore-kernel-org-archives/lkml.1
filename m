Return-Path: <linux-kernel-owner+w=401wt.eu-S933979AbXDCQro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933979AbXDCQro (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 12:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964976AbXDCQro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 12:47:44 -0400
Received: from ottawa-hs-64-26-128-89.s-ip.magma.ca ([64.26.128.89]:1119 "EHLO
	mail.rtr.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933979AbXDCQrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 12:47:43 -0400
Message-ID: <4612852C.2030801@rtr.ca>
Date: Tue, 03 Apr 2007 12:47:40 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Chris Snook <csnook@redhat.com>
Cc: Paa Paa <paapaa125@hotmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Lower HD transfer rate with NCQ enabled?
References: <BAY20-F50719E454DCCF2309DA1AF9670@phx.gbl> <46128175.2090506@redhat.com>
In-Reply-To: <46128175.2090506@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Snook wrote:
> Paa Paa wrote:
>> I'm using Linux 2.6.20.4. I noticed that I get lower SATA hard drive 
>> throughput with 2.6.20.4 than with 2.6.19. The reason was that 2.6.20 
>> enables NCQ by defauly (queue_depth = 31/32 instead of 0/32). Transfer 
>> rate was measured using "hdparm -t":
>>
>> With NCQ (queue_depth == 31): 50MB/s.
>> Without NCQ (queue_depth == 0): 60MB/s.
>>
>> 20% difference is quite a lot. This is with Intel ICH8R controller and 
>> Western Digital WD1600YS hard disk in AHCI mode. I also used the next 
>> command to cat-copy a biggish (540MB) file and time it:
>>
>> rm temp && sync && time sh -c 'cat quite_big_file > temp && sync'
>>
>> Here I noticed no differences at all with and without NCQ. The times 
>> (real time) were basically the same in many successive runs. Around 19s.
>>
>> Q: What conclusion can I make on "hdparm -t" results or can I make any 
>> conclusions? Do I really have lower performance with NCQ or not? If I 
>> do, is this because of my HD or because of kernel?
> 
> hdparm -t is a perfect example of a synthetic benchmark.  NCQ was 
> designed to optimize real-world workloads. 

No, NCQ was designed to optimize *server* workloads:  lots of *small*,
random I/O's.

But WD drives, in particular the Raptor series, have a firmware "feature"
that disables "drive readahead" whenever NCQ is in use.

So they will perform poorly only any medium/large sequential access
if NCQ is employed.  Which is why the custom MS drivers avoid NCQ when
doing large sequential accesses.  Ours don't do this, yet.

-ml
