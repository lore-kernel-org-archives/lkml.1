Return-Path: <linux-kernel-owner+w=401wt.eu-S1752834AbZGaScT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbZGaScT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 14:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752793AbZGaScS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 14:32:18 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63087 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbZGaScR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 14:32:17 -0400
Message-ID: <4A7338AF.8010407@vlnb.net>
Date: Fri, 31 Jul 2009 22:32:15 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ronald Moesbergen <intercommit@gmail.com>
CC: fengguang.wu@intel.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
       Alan.Brunelle@hp.com, linux-fsdevel@vger.kernel.org,
       jens.axboe@oracle.com, randy.dunlap@oracle.com,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [RESEND] [PATCH] readahead:add blk_run_backing_dev
References: <4A3CD62B.1020407@vlnb.net>	 <a0272b440907160032u482bd483s54540001aef7ac73@mail.gmail.com>	 <4A5F0293.3010206@vlnb.net>	 <a0272b440907170715q72af7bb8l53c9dbd5e553fe2c@mail.gmail.com>	 <4A60C1A8.9020504@vlnb.net> <4A641AAC.9030300@vlnb.net>	 <a0272b440907220144i159baca4u1a1f1f2d0c36193a@mail.gmail.com>	 <4A6DA77B.7080600@vlnb.net>	 <a0272b440907280251g2dd38df6ja1bf10f3fa38d333@mail.gmail.com>	 <4A6F4C81.10600@vlnb.net> <a0272b440907290548k266a975br8c6bdf4d5d992d20@mail.gmail.com>
In-Reply-To: <a0272b440907290548k266a975br8c6bdf4d5d992d20@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+h0T+BNBzrStyCiYhIv7xhxFvC4ArwbDOZ/R6
 kdDincCBH7ZIwQbXzoW+mgUF3+g0OkHNTxrIO7B/FBqAKH5te9
 bgFiTNs+vVJ4oi02XvpHA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ronald Moesbergen, on 07/29/2009 04:48 PM wrote:
> 2009/7/28 Vladislav Bolkhovitin <vst@vlnb.net>:
>> Can you perform the tests 5 and 8 the deadline? I asked for deadline..
>>
>> What I/O scheduler do you use on the initiator? Can you check if changing it
>> to deadline or noop makes any difference?
>>
> 
> client kernel: 2.6.26-15lenny3 (debian)
> server kernel: 2.6.29.5 with readahead-context, blk_run_backing_dev
> and io_context, forced_order
> 
> With one IO thread:
> 5) client: default, server: default (server deadline, client cfq)
> blocksize       R        R        R   R(avg,    R(std        R
>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>  67108864  15.739   15.339   16.511   64.613    1.959    1.010
>  33554432  15.411   12.384   15.400   71.876    7.646    2.246
>  16777216  16.564   15.569   16.279   63.498    1.667    3.969
> 
> 5) client: default, server: default (server deadline, client deadline)
> blocksize       R        R        R   R(avg,    R(std        R
>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>  67108864  17.578   20.051   18.010   55.395    3.111    0.866
>  33554432  19.247   12.607   17.930   63.846   12.390    1.995
>  16777216  14.587   19.631   18.032   59.718    7.650    3.732
> 
> 8) client: default, server: 64 max_sectors_kb, RA 2MB (server
> deadline, client deadline)
> blocksize       R        R        R   R(avg,    R(std        R
>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>  67108864  17.418   19.520   22.050   52.564    5.043    0.821
>  33554432  21.263   17.623   17.782   54.616    4.571    1.707
>  16777216  17.896   18.335   19.407   55.278    1.864    3.455
> 
> 8) client: default, server: 64 max_sectors_kb, RA 2MB (server
> deadline, client cfq)
> blocksize       R        R        R   R(avg,    R(std        R
>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>  67108864  16.639   15.216   16.035   64.233    2.365    1.004
>  33554432  15.750   16.511   16.092   63.557    1.224    1.986
>  16777216  16.390   15.866   15.331   64.604    1.763    4.038
> 
> 11) client: 2MB RA, 64 max_sectors_kb, server: 64 max_sectors_kb, RA
> 2MB (server deadline, client deadline)
> blocksize       R        R        R   R(avg,    R(std        R
>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>  67108864  14.117   13.610   13.558   74.435    1.347    1.163
>  33554432  13.450   10.344   13.556   83.555   10.918    2.611
>  16777216  13.408   13.319   13.239   76.867    0.398    4.804
> 
> With two threads:
> 5) client: default, server: default (server deadline, client cfq)
> blocksize       R        R        R   R(avg,    R(std        R
>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>  67108864  15.723   16.535   16.189   63.438    1.312    0.991
>  33554432  16.152   16.363   15.782   63.621    0.954    1.988
>  16777216  15.174   16.084   16.682   64.178    2.516    4.011
> 
> 5) client: default, server: default (server deadline, client deadline)
> blocksize       R        R        R   R(avg,    R(std        R
>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>  67108864  18.087   18.082   17.639   57.099    0.674    0.892
>  33554432  18.377   15.750   17.551   59.694    3.912    1.865
>  16777216  18.490   15.553   18.778   58.585    5.143    3.662
> 
> 8) client: default, server: 64 max_sectors_kb, RA 2MB (server
> deadline, client deadline)
> blocksize       R        R        R   R(avg,    R(std        R
>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>  67108864  18.140   19.114   17.442   56.244    2.103    0.879
>  33554432  17.183   17.233   21.367   55.646    5.461    1.739
>  16777216  19.813   17.965   18.132   55.053    2.393    3.441
> 
> 8) client: default, server: 64 max_sectors_kb, RA 2MB (server
> deadline, client cfq)
> blocksize       R        R        R   R(avg,    R(std        R
>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>  67108864  15.753   16.085   16.522   63.548    1.239    0.993
>  33554432  13.502   15.912   15.507   68.743    5.065    2.148
>  16777216  16.584   16.171   15.959   63.077    1.003    3.942
> 
> 11) client: 2MB RA, 64 max_sectors_kb, server: 64 max_sectors_kb, RA
> 2MB (server deadline, client deadline)
> blocksize       R        R        R   R(avg,    R(std        R
>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>  67108864  14.051   13.427   13.498   75.001    1.510    1.172
>  33554432  13.397   14.008   13.453   75.217    1.503    2.351
>  16777216  13.277    9.942   14.318   83.882   13.712    5.243

OK, as I expected, on the SCST level everything is clear and the forced 
ordering change didn't change anything.

But still, a single read stream must be the fastest from single thread. 
Otherwise, there's something wrong somewhere in the I/O path: block 
layer, RA, I/O scheduler. And, apparently, this is what we have and 
should find out the cause.

Can you check if noop on the target and/or initiator makes any 
difference? Case 5 with 1 and 2 threads will be sufficient.

Thanks,
Vlad

