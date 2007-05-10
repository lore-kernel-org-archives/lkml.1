Return-Path: <linux-kernel-owner+w=401wt.eu-S1761732AbXEJONt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761732AbXEJONt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 10:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756037AbXEJONn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 10:13:43 -0400
Received: from mail.syneticon.net ([213.239.212.131]:43382 "EHLO
	mail2.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755176AbXEJONm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 10:13:42 -0400
Message-ID: <4643283B.2060203@wpkg.org>
Date: Thu, 10 May 2007 16:12:11 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061110 Mandriva/1.5.0.8-1mdv2007.1 (2007.1) Thunderbird/1.5.0.8 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       rshitrit@marvell.com, dan.j.williams@intel.com, nickpiggin@yahoo.com.au,
       Justin Piszcz <jpiszcz@lucidpixels.com>, ilmari@ilmari.org
Subject: RE: [PATCH 00/16] raid acceleration and asynchronous offload api
 for 2.6.22
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ronen Shitrit wrote:

> The resync numbers you sent, looks very promising :)
> Do you have any performance numbers that you can share for these set of
> patches, which shows the Rd/Wr IO bandwidth.

I have some simple tests made with hdparm, with the results I don't 
understand.

We see hdparm results are fine if we access the whole device:

thecus:~# hdparm -Tt /dev/sdd

/dev/sdd:
  Timing cached reads:   392 MB in  2.00 seconds = 195.71 MB/sec
  Timing buffered disk reads:  146 MB in  3.01 seconds =  48.47 MB/sec


But are 10 times worse (Timing buffered disk reads) when we access 
partitions:

thecus:/# hdparm -Tt /dev/sdc1 /dev/sdd1

/dev/sdc1:
  Timing cached reads:   396 MB in  2.01 seconds = 197.18 MB/sec
  Timing buffered disk reads:   16 MB in  3.32 seconds =   4.83 MB/sec

/dev/sdd1:
  Timing cached reads:   394 MB in  2.00 seconds = 196.89 MB/sec
  Timing buffered disk reads:   16 MB in  3.13 seconds =   5.11 MB/sec


Why is it so much worse?


I used 2.6.21-iop1 patches from http://sf.net/projects/xscaleiop; right 
now I use 2.6.17-iop1, for which the results are ~35 MB/s when accessing 
a device (/dev/sdd) or a partition (/dev/sdd1).


In kernel config, I enabled Intel DMA engines.

The device I use is Thecus n4100, it is "Platform: IQ31244 (XScale)", 
and has 600 MHz CPU.


-- 
Tomasz Chmielewski
http://wpkg.org

