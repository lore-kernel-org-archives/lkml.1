Return-Path: <linux-kernel-owner+w=401wt.eu-S1759875AbXEJPdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759875AbXEJPdv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 11:33:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756266AbXEJPde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 11:33:34 -0400
Received: from mail.syneticon.net ([213.239.212.131]:43457 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755962AbXEJPdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 11:33:32 -0400
Message-ID: <46433AF3.1040707@wpkg.org>
Date: Thu, 10 May 2007 17:32:03 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061110 Mandriva/1.5.0.8-1mdv2007.1 (2007.1) Thunderbird/1.5.0.8 Mnenhy/0.7.4.666
MIME-Version: 1.0
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       rshitrit@marvell.com, dan.j.williams@intel.com, nickpiggin@yahoo.com.au,
       Justin Piszcz <jpiszcz@lucidpixels.com>, ilmari@ilmari.org
Subject: Re: [PATCH 00/16] raid acceleration and asynchronous offload api
 for 2.6.22
References: <4643283B.2060203@wpkg.org>
In-Reply-To: <4643283B.2060203@wpkg.org>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz Chmielewski schrieb:
> Ronen Shitrit wrote:
> 
>> The resync numbers you sent, looks very promising :)
>> Do you have any performance numbers that you can share for these set of
>> patches, which shows the Rd/Wr IO bandwidth.
> 
> I have some simple tests made with hdparm, with the results I don't 
> understand.
> 
> We see hdparm results are fine if we access the whole device:
> 
> thecus:~# hdparm -Tt /dev/sdd
> 
> /dev/sdd:
>  Timing cached reads:   392 MB in  2.00 seconds = 195.71 MB/sec
>  Timing buffered disk reads:  146 MB in  3.01 seconds =  48.47 MB/sec
> 
> 
> But are 10 times worse (Timing buffered disk reads) when we access 
> partitions:

There seems to be another side effect when comparing DMA engine in 
2.6.17-iop1 to 2.6.21-iop1: network performance.


For simple network tests, I use "netperf" tool to measure network 
performance.

With 2.6.17-iop1 and all DMA offloading options enabled (selectable in 
System type ---> IOP3xx Implementation Options  --->), I get nearly 25 
MB/s throughput.

With 2.6.21-iop1 and all DMA offloading optons enabled (moved to Device 
Drivers  ---> DMA Engine support  --->), I get only about 10 MB/s 
throughput.
Additionally, on 2.6.21-iop1, I get lots of "dma_cookie < 0" printed by 
the kernel.


-- 
Tomasz Chmielewski
http://wpkg.org
