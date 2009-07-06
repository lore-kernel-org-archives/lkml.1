Return-Path: <linux-kernel-owner+w=401wt.eu-S1754958AbZGFLNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958AbZGFLNP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 07:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753195AbZGFLNC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 07:13:02 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:63145 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716AbZGFLNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 07:13:00 -0400
Message-ID: <4A51DC0A.10302@vlnb.net>
Date: Mon, 06 Jul 2009 15:12:10 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ronald Moesbergen <intercommit@gmail.com>
CC: Wu Fengguang <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
       Alan.Brunelle@hp.com, hifumi.hisashi@oss.ntt.co.jp,
       linux-fsdevel@vger.kernel.org, jens.axboe@oracle.com,
       randy.dunlap@oracle.com, Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [RESEND] [PATCH] readahead:add blk_run_backing_dev
References: <4A3CD62B.1020407@vlnb.net> <4A48BBF9.6050408@vlnb.net>	 <a0272b440906290700v7367d1c1r7237fd6593be00d2@mail.gmail.com>	 <20090629142124.GA28945@localhost> <20090629150109.GA3534@localhost>	 <4A48DFC5.3090205@vlnb.net> <20090630010414.GB31418@localhost>	 <4A49EEF9.6010205@vlnb.net>	 <a0272b440907030214l4016422bxbc98fd003bfe1b3d@mail.gmail.com>	 <4A4DE3C1.5080307@vlnb.net> <a0272b440907040819l5289483cp44b37d967440ef73@mail.gmail.com>
In-Reply-To: <a0272b440907040819l5289483cp44b37d967440ef73@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+FWRNm7v6s9s104bWBKSGNA8pjT9cV1rKryr1
 n7UoYV15fsvLzsSgKZFVw8tXn9Rv/lUVmxaomSwx0YGW0ViXht
 ZPuzJo5egdWDn4uSQglng==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Restored the original list of recipients in this thread as I was asked.)

Hi Ronald,

Ronald Moesbergen, on 07/04/2009 07:19 PM wrote:
> 2009/7/3 Vladislav Bolkhovitin <vst@vlnb.net>:
>> Ronald Moesbergen, on 07/03/2009 01:14 PM wrote:
>>>>> OK, now I tend to agree on decreasing max_sectors_kb and increasing
>>>>> read_ahead_kb. But before actually trying to push that idea I'd like
>>>>> to
>>>>> - do more benchmarks
>>>>> - figure out why context readahead didn't help SCST performance
>>>>>  (previous traces show that context readahead is submitting perfect
>>>>>  large io requests, so I wonder if it's some io scheduler bug)
>>>> Because, as we found out, without your http://lkml.org/lkml/2009/5/21/319
>>>> patch read-ahead was nearly disabled, hence there were no difference
>>>> which
>>>> algorithm was used?
>>>>
>>>> Ronald, can you run the following tests, please? This time with 2 hosts,
>>>> initiator (client) and target (server) connected using 1 Gbps iSCSI. It
>>>> would be the best if on the client vanilla 2.6.29 will be ran, but any
>>>> other
>>>> kernel will be fine as well, only specify which. Blockdev-perftest should
>>>> be
>>>> ran as before in buffered mode, i.e. with "-a" switch.
>>>>
>>>> 1. All defaults on the client, on the server vanilla 2.6.29 with
>>>> Fengguang's
>>>> http://lkml.org/lkml/2009/5/21/319 patch with all default settings.
>>>>
>>>> 2. All defaults on the client, on the server vanilla 2.6.29 with
>>>> Fengguang's
>>>> http://lkml.org/lkml/2009/5/21/319 patch with default RA size and 64KB
>>>> max_sectors_kb.
>>>>
>>>> 3. All defaults on the client, on the server vanilla 2.6.29 with
>>>> Fengguang's
>>>> http://lkml.org/lkml/2009/5/21/319 patch with 2MB RA size and default
>>>> max_sectors_kb.
>>>>
>>>> 4. All defaults on the client, on the server vanilla 2.6.29 with
>>>> Fengguang's
>>>> http://lkml.org/lkml/2009/5/21/319 patch with 2MB RA size and 64KB
>>>> max_sectors_kb.
>>>>
>>>> 5. All defaults on the client, on the server vanilla 2.6.29 with
>>>> Fengguang's
>>>> http://lkml.org/lkml/2009/5/21/319 patch and with context RA patch. RA
>>>> size
>>>> and max_sectors_kb are default. For your convenience I committed the
>>>> backported context RA patches into the SCST SVN repository.
>>>>
>>>> 6. All defaults on the client, on the server vanilla 2.6.29 with
>>>> Fengguang's
>>>> http://lkml.org/lkml/2009/5/21/319 and context RA patches with default RA
>>>> size and 64KB max_sectors_kb.
>>>>
>>>> 7. All defaults on the client, on the server vanilla 2.6.29 with
>>>> Fengguang's
>>>> http://lkml.org/lkml/2009/5/21/319 and context RA patches with 2MB RA
>>>> size
>>>> and default max_sectors_kb.
>>>>
>>>> 8. All defaults on the client, on the server vanilla 2.6.29 with
>>>> Fengguang's
>>>> http://lkml.org/lkml/2009/5/21/319 and context RA patches with 2MB RA
>>>> size
>>>> and 64KB max_sectors_kb.
>>>>
>>>> 9. On the client default RA size and 64KB max_sectors_kb. On the server
>>>> vanilla 2.6.29 with Fengguang's http://lkml.org/lkml/2009/5/21/319 and
>>>> context RA patches with 2MB RA size and 64KB max_sectors_kb.
>>>>
>>>> 10. On the client 2MB RA size and default max_sectors_kb. On the server
>>>> vanilla 2.6.29 with Fengguang's http://lkml.org/lkml/2009/5/21/319 and
>>>> context RA patches with 2MB RA size and 64KB max_sectors_kb.
>>>>
>>>> 11. On the client 2MB RA size and 64KB max_sectors_kb. On the server
>>>> vanilla
>>>> 2.6.29 with Fengguang's http://lkml.org/lkml/2009/5/21/319 and context RA
>>>> patches with 2MB RA size and 64KB max_sectors_kb.
>>> Ok, done. Performance is pretty bad overall :(
>>>
>>> The kernels I used:
>>> client kernel: 2.6.26-15lenny3 (debian)
>>> server kernel: 2.6.29.5 with blk_dev_run patch
>>>
>>> And I adjusted the blockdev-perftest script to drop caches on both the
>>> server (via ssh) and the client.
>>>
>>> The results:
>>>
> 
> ... previous results ...
> 
>> Those are on the server without io_context-2.6.29 and readahead-2.6.29
>> patches applied and with CFQ scheduler, correct?
>>
>> Then we see how reorder of requests caused by many I/O threads submitting
>> I/O in separate I/O contexts badly affect performance and no RA, especially
>> with default 128KB RA size, can solve it. Less max_sectors_kb on the client
>> => more requests it sends at once => more reorder on the server => worse
>> throughput. Although, Fengguang, in theory, context RA with 2MB RA size
>> should considerably help it, no?
>>
>> Ronald, can you perform those tests again with both io_context-2.6.29 and
>> readahead-2.6.29 patches applied on the server, please?
> 
> Hi Vlad,
> 
> I have retested with the patches you requested (and got access to the
> systems today :) ) The results are better, but still not great.
>
> client kernel: 2.6.26-15lenny3 (debian)
> server kernel: 2.6.29.5 with io_context and readahead patch
> 
> 5) client: default, server: default
> blocksize       R        R        R   R(avg,    R(std        R
>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>  67108864  18.303   19.867   18.481   54.299    1.961    0.848
>  33554432  18.321   17.681   18.708   56.181    1.314    1.756
>  16777216  17.816   17.406   19.257   56.494    2.410    3.531
>   8388608  18.077   17.727   19.338   55.789    2.056    6.974
>   4194304  17.918   16.601   18.287   58.276    2.454   14.569
>   2097152  17.426   17.334   17.610   58.661    0.384   29.331
>   1048576  19.358   18.764   17.253   55.607    2.734   55.607
>    524288  17.951   18.163   17.440   57.379    0.983  114.757
>    262144  18.196   17.724   17.520   57.499    0.907  229.995
>    131072  18.342   18.259   17.551   56.751    1.131  454.010
>     65536  17.733   18.572   17.134   57.548    1.893  920.766
>     32768  19.081   19.321   17.364   55.213    2.673 1766.818
>     16384  17.181   18.729   17.731   57.343    2.033 3669.932
> 
> 6) client: default, server: 64 max_sectors_kb, RA default
> blocksize       R        R        R   R(avg,    R(std        R
>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>  67108864  21.790   20.062   19.534   50.153    2.304    0.784
>  33554432  20.212   19.744   19.564   51.623    0.706    1.613
>  16777216  20.404   19.329   19.738   51.680    1.148    3.230
>   8388608  20.170   20.772   19.509   50.852    1.304    6.356
>   4194304  19.334   18.742   18.522   54.296    0.978   13.574
>   2097152  19.413   18.858   18.884   53.758    0.715   26.879
>   1048576  20.472   18.755   18.476   53.347    2.377   53.347
>    524288  19.120   20.104   18.404   53.378    1.925  106.756
>    262144  20.337   19.213   18.636   52.866    1.901  211.464
>    131072  19.199   18.312   19.970   53.510    1.900  428.083
>     65536  19.855   20.114   19.592   51.584    0.555  825.342
>     32768  20.586   18.724   20.340   51.592    2.204 1650.941
>     16384  21.119   19.834   19.594   50.792    1.651 3250.669
> 
> 7) client: default, server: default max_sectors_kb, RA 2MB
> blocksize       R        R        R   R(avg,    R(std        R
>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>  67108864  17.767   16.489   16.949   60.050    1.842    0.938
>  33554432  16.777   17.034   17.102   60.341    0.500    1.886
>  16777216  18.509   16.784   16.971   58.891    2.537    3.681
>   8388608  18.058   17.949   17.599   57.313    0.632    7.164
>   4194304  18.286   17.648   17.026   58.055    1.692   14.514
>   2097152  17.387   18.451   17.875   57.226    1.388   28.613
>   1048576  18.270   17.698   17.570   57.397    0.969   57.397
>    524288  16.708   17.900   17.233   59.306    1.668  118.611
>    262144  18.041   17.381   18.035   57.484    1.011  229.934
>    131072  17.994   17.777   18.146   56.981    0.481  455.844
>     65536  17.097   18.597   17.737   57.563    1.975  921.011
>     32768  17.167   17.035   19.693   57.254    3.721 1832.127
>     16384  17.144   16.664   17.623   59.762    1.367 3824.774
> 
> 8) client: default, server: 64 max_sectors_kb, RA 2MB
> blocksize       R        R        R   R(avg,    R(std        R
>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>  67108864  20.003   21.133   19.308   50.894    1.881    0.795
>  33554432  19.448   20.015   18.908   52.657    1.222    1.646
>  16777216  19.964   19.350   19.106   52.603    0.967    3.288
>   8388608  18.961   19.213   19.318   53.437    0.419    6.680
>   4194304  18.135   19.508   19.361   53.948    1.788   13.487
>   2097152  18.753   19.471   18.367   54.315    1.306   27.158
>   1048576  19.189   18.586   18.867   54.244    0.707   54.244
>    524288  18.985   19.199   18.840   53.874    0.417  107.749
>    262144  19.064   21.143   19.674   51.398    2.204  205.592
>    131072  18.691   18.664   19.116   54.406    0.594  435.245
>     65536  18.468   20.673   18.554   53.389    2.729  854.229
>     32768  20.401   21.156   19.552   50.323    1.623 1610.331
>     16384  19.532   20.028   20.466   51.196    0.977 3276.567
> 
> 9) client: 64 max_sectors_kb, default RA. server: 64 max_sectors_kb, RA 2MB
> blocksize       R        R        R   R(avg,    R(std        R
>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>  67108864  16.458   16.649   17.346   60.919    1.364    0.952
>  33554432  16.479   16.744   17.069   61.096    0.878    1.909
>  16777216  17.128   16.585   17.112   60.456    0.910    3.778
>   8388608  17.322   16.780   16.885   60.262    0.824    7.533
>   4194304  17.530   16.725   16.756   60.250    1.299   15.063
>   2097152  16.580   17.875   16.619   60.221    2.076   30.110
>   1048576  17.550   17.406   17.075   59.049    0.681   59.049
>    524288  16.492   18.211   16.832   59.718    2.519  119.436
>    262144  17.241   17.115   17.365   59.397    0.352  237.588
>    131072  17.430   16.902   17.511   59.271    0.936  474.167
>     65536  16.726   16.894   17.246   60.404    0.768  966.461
>     32768  16.662   17.517   17.052   59.989    1.224 1919.658
>     16384  17.429   16.793   16.753   60.285    1.085 3858.268
> 
> 10) client: default max_sectors_kb, 2MB RA. server: 64 max_sectors_kb, RA 2MB
> blocksize       R        R        R   R(avg,    R(std        R
>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>  67108864  17.601   18.334   17.379   57.650    1.307    0.901
>  33554432  18.281   18.128   17.169   57.381    1.610    1.793
>  16777216  17.660   17.875   17.356   58.091    0.703    3.631
>   8388608  17.724   17.810   18.383   56.992    0.918    7.124
>   4194304  17.475   17.770   19.003   56.704    2.031   14.176
>   2097152  17.287   17.674   18.492   57.516    1.604   28.758
>   1048576  17.972   17.460   18.777   56.721    1.689   56.721
>    524288  18.680   18.952   19.445   53.837    0.890  107.673
>    262144  18.070   18.337   18.639   55.817    0.707  223.270
>    131072  16.990   16.651   16.862   60.832    0.507  486.657
>     65536  17.707   16.972   17.520   58.870    1.066  941.924
>     32768  17.767   17.208   17.205   58.887    0.885 1884.399
>     16384  18.258   17.252   18.035   57.407    1.407 3674.059
> 
> 11) client: 64 max_sectors_kb, 2MB. RA server: 64 max_sectors_kb, RA 2MB
> blocksize       R        R        R   R(avg,    R(std        R
>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>  67108864  17.993   18.307   18.718   55.850    0.902    0.873
>  33554432  19.554   18.485   17.902   54.988    1.993    1.718
>  16777216  18.829   18.236   18.748   55.052    0.785    3.441
>   8388608  21.152   19.065   18.738   52.257    2.745    6.532
>   4194304  19.131   19.703   17.850   54.288    2.268   13.572
>   2097152  19.093   19.152   19.509   53.196    0.504   26.598
>   1048576  19.371   18.775   18.804   53.953    0.772   53.953
>    524288  20.003   17.911   18.602   54.470    2.476  108.940
>    262144  19.182   19.460   18.476   53.809    1.183  215.236
>    131072  19.403   19.192   18.907   53.429    0.567  427.435
>     65536  19.502   19.656   18.599   53.219    1.309  851.509
>     32768  18.746   18.747   18.250   55.119    0.701 1763.817
>     16384  20.977   19.437   18.840   51.951    2.319 3324.862

The results look inconsistently with what you had previously (89.7 
MB/s). How can you explain it?

I think, most likely, there was some confusion between the tested and 
patched versions of the kernel or you forgot to apply the io_context 
patch. Please recheck.

> Ronald.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
