Return-Path: <linux-kernel-owner+w=401wt.eu-S1762758AbXGEWMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762758AbXGEWMb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 18:12:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760953AbXGEWMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 18:12:24 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:53097 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760289AbXGEWMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 18:12:24 -0400
Message-ID: <468D6CE1.8050808@cfl.rr.com>
Date: Thu, 05 Jul 2007 18:12:49 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Michael Tokarev <mjt@tls.msk.ru>
CC: Jeff Garzik <jeff@garzik.org>, Carlo Wood <carlo@alinoe.com>,
       Tejun Heo <htejun@gmail.com>, Manoj Kasichainula <manoj@io.com>,
       linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: SATA RAID5 speed drop of 100 MB/s
References: <20070620224847.GA5488@alinoe.com> <4679B2DE.9090903@garzik.org> <20070622214859.GC6970@alinoe.com> <467CC5C5.6040201@garzik.org> <20070623125316.GB26672@alinoe.com> <467DA1F5.2060306@garzik.org> <467E5C5E.6000706@msgid.tls.msk.ru>
In-Reply-To: <467E5C5E.6000706@msgid.tls.msk.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Jul 2007 22:12:36.0385 (UTC) FILETIME=[97D3E110:01C7BF51]
X-TM-AS-Product-Ver: SMEX-7.5.0.1243-5.0.1021-15280.001
X-TM-AS-Result: No--6.829600-5.000000-3
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Tokarev wrote:
> Single Seagate 74Gb SCSI drive (10KRPM)
> 
> BlkSz Trd linRd rndRd linWr  rndWr  linR/W     rndR/W
>    4k   1  66.4   0.5   0.6   0.5   0.6/ 0.6   0.4/ 0.2
>         2         0.6         0.6              0.5/ 0.1
>         4         0.7         0.6              0.6/ 0.2
>   16k   1  84.8   2.0   2.5   1.9   2.5/ 2.5   1.6/ 0.6
>         2         2.3         2.1              2.0/ 0.6
>         4         2.7         2.5              2.3/ 0.6
>   64k   1  84.8   7.4   9.3   7.2   9.4/ 9.3   5.8/ 2.2
>         2         8.6         7.9              7.3/ 2.1
>         4         9.9         9.1              8.1/ 2.2
>  128k   1  84.8  13.6  16.7  12.9  16.9/16.6  10.6/ 3.9
>         2        15.6        14.4             13.5/ 3.2
>         4        17.9        16.4             15.7/ 2.7
>  512k   1  84.9  34.0  41.9  33.3  29.0/27.1  22.4/13.2
>         2        36.9        34.5             30.7/ 8.1
>         4        40.5        38.1             33.2/ 8.3
> 1024k   1  83.1  36.0  55.8  34.6  28.2/27.6  20.3/19.4
>         2        45.2        44.1             36.4/ 9.9
>         4        48.1        47.6             40.7/ 7.1
> 

<snip>

> The only thing I don't understand is why with larger I/O block
> size we see write speed drop with multiple threads.

Huh?  Your data table does not show larger block size dropping write 
speed.  47.6 > 38.1 > 16.4.

> And in contrast to the above, here's another test run, now
> with Seagate SATA ST3250620AS ("desktop" class) 250GB
> 7200RPM drive:
> 
> BlkSz Trd linRd rndRd linWr rndWr   linR/W    rndR/W
>    4k   1  47.5   0.3   0.5   0.3   0.3/ 0.3   0.1/ 0.1
>         2         0.3         0.3              0.2/ 0.1
>         4         0.3         0.3              0.2/ 0.2
>   16k   1  78.4   1.1   1.8   1.1   0.9/ 0.9   0.6/ 0.6
>         2         1.2         1.1              0.6/ 0.6
>         4         1.3         1.2              0.6/ 0.6
>   64k   1  78.4   4.3   6.7   4.0   3.5/ 3.5   2.1/ 2.2
>         2         4.5         4.1              2.2/ 2.3
>         4         4.7         4.2              2.3/ 2.4
>  128k   1  78.4   8.0  12.6   7.2   6.2/ 6.2   3.9/ 3.8
>         2         8.2         7.3              4.1/ 4.0
>         4         8.7         7.7              4.3/ 4.3
>  512k   1  78.5  23.1  34.0  20.3  17.1/17.1  11.3/10.7
>         2        23.5        20.6             11.3/11.4
>         4        24.7        21.3             11.6/11.8
> 1024k   1  78.4  34.1  33.5  24.6  19.6/19.5  16.0/12.7
>         2        33.3        24.6             15.4/13.8
>         4        34.3        25.0             14.7/15.0
> 
> Here, the (total) I/O speed does not depend on the number
> of threads.  From which I conclude that the drive does
> not reorder/optimize commands internally, even if NCQ is
> enabled (queue depth is 32).

While the difference does not appear to be as pronounced as with the WD 
drive, the data does show more threads give more total IO.  4.7 > 4.5 > 
4.3 in the 64k rndRd test, and the other tests show an increase with 
more threads as well.


