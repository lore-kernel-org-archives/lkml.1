Return-Path: <linux-kernel-owner+w=401wt.eu-S1760208AbZF2PiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760208AbZF2PiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 11:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760059AbZF2Phy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 11:37:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:57580 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760025AbZF2Phw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 11:37:52 -0400
Message-ID: <4A48DFC5.3090205@vlnb.net>
Date: Mon, 29 Jun 2009 19:37:41 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Ronald Moesbergen <intercommit@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "Alan.Brunelle@hp.com" <Alan.Brunelle@hp.com>,
       "hifumi.hisashi@oss.ntt.co.jp" <hifumi.hisashi@oss.ntt.co.jp>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [RESEND] [PATCH] readahead:add blk_run_backing_dev
References: <20090618120436.ad3196e3.akpm@linux-foundation.org> <20090620035504.GA19516@localhost> <4A3CD62B.1020407@vlnb.net> <20090629093423.GB1315@localhost> <a0272b440906290326rcd63849j2513f6ee9b9bf93e@mail.gmail.com> <4A489DAC.7000007@vlnb.net> <20090629125434.GA8416@localhost> <4A48BBF9.6050408@vlnb.net> <a0272b440906290700v7367d1c1r7237fd6593be00d2@mail.gmail.com> <20090629142124.GA28945@localhost> <20090629150109.GA3534@localhost>
In-Reply-To: <20090629150109.GA3534@localhost>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+8NBeFicpj+gu1aE3UAgpimyENZIHHnj+3DIW
 sj84/ZAMGp7rLjqeMpWTxoQ50mYDQgFr/GmYYzrIZof1GX/v25
 DXgjblSzQbyMh3//RbTDw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Wu Fengguang, on 06/29/2009 07:01 PM wrote:
> On Mon, Jun 29, 2009 at 10:21:24PM +0800, Wu Fengguang wrote:
>> On Mon, Jun 29, 2009 at 10:00:20PM +0800, Ronald Moesbergen wrote:
>>> ... tests ...
>>>
>>>> We started with 2.6.29, so why not complete with it (to save additional
>>>> Ronald's effort to move on 2.6.30)?
>>>>
>>>>>> 2. Default vanilla 2.6.29 kernel, 512 KB read-ahead, the rest is default
>>>>> How about 2MB RAID readahead size? That transforms into about 512KB
>>>>> per-disk readahead size.
>>>> OK. Ronald, can you 4 more test cases, please:
>>>>
>>>> 7. Default vanilla 2.6.29 kernel, 2MB read-ahead, the rest is default
>>>>
>>>> 8. Default vanilla 2.6.29 kernel, 2MB read-ahead, 64 KB
>>>> max_sectors_kb, the rest is default
>>>>
>>>> 9. Patched by the Fengguang's patch vanilla 2.6.29 kernel, 2MB
>>>> read-ahead, the rest is default
>>>>
>>>> 10. Patched by the Fengguang's patch vanilla 2.6.29 kernel, 2MB
>>>> read-ahead, 64 KB max_sectors_kb, the rest is default
>>> The results:
>> I made a blindless average:
>>
>> N       MB/s          IOPS      case
>>
>> 0      114.859       984.148    Unpatched, 128KB readahead, 512 max_sectors_kb
>> 1      122.960       981.213    Unpatched, 512KB readahead, 512 max_sectors_kb
>> 2      120.709       985.111    Unpatched, 2MB readahead, 512 max_sectors_kb
>> 3      158.732      1004.714    Unpatched, 512KB readahead, 64 max_sectors_kb
>> 4      159.237       979.659    Unpatched, 2MB readahead, 64 max_sectors_kb
>>
>> 5      114.583       982.998    Patched, 128KB readahead, 512 max_sectors_kb
>> 6      124.902       987.523    Patched, 512KB readahead, 512 max_sectors_kb
>> 7      127.373       984.848    Patched, 2MB readahead, 512 max_sectors_kb
>> 8      161.218       986.698    Patched, 512KB readahead, 64 max_sectors_kb
>> 9      163.908       574.651    Patched, 2MB readahead, 64 max_sectors_kb
>>
>> So before/after patch:
>>
>>         avg throughput      135.299 => 138.397  by +2.3%
>>         avg IOPS            986.969 => 903.344  by -8.5%     
>>
>> The IOPS is a bit weird.
>>
>> Summaries:
>> - this patch improves RAID throughput by +2.3% on average
>> - after this patch, 2MB readahead performs slightly better
>>   (by 1-2%) than 512KB readahead
> 
> and the most important one:
> - 64 max_sectors_kb performs much better than 256 max_sectors_kb, by ~30% !

Yes, I've just wanted to point it out ;)

> Thanks,
> Fengguang
> 
>>> Unpatched, 128KB readahead, 512 max_sectors_kb
>>> blocksize       R        R        R   R(avg,    R(std        R
>>>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>>>  67108864   5.621    5.503    5.419  185.744    2.780    2.902
>>>  33554432   6.628    5.897    6.242  164.068    7.827    5.127
>>>  16777216   7.312    7.165    7.614  139.148    3.501    8.697
>>>   8388608   8.719    8.408    8.694  119.003    1.973   14.875
>>>   4194304  11.836   12.192   12.137   84.958    1.111   21.239
>>>   2097152  13.452   13.992   14.035   74.090    1.442   37.045
>>>   1048576  12.759   11.996   12.195   83.194    2.152   83.194
>>>    524288  11.895   12.297   12.587   83.570    1.945  167.140
>>>    262144   7.325    7.285    7.444  139.304    1.272  557.214
>>>    131072   7.992    8.832    7.952  124.279    5.901  994.228
>>>     65536  10.940   10.062   10.122   98.847    3.715 1581.545
>>>     32768   9.973   10.012    9.945  102.640    0.281 3284.493
>>>     16384  11.377   10.538   10.692   94.316    3.100 6036.222
>>>
>>> Unpatched, 512KB readahead, 512 max_sectors_kb
>>> blocksize       R        R        R   R(avg,    R(std        R
>>>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>>>  67108864   5.032    4.770    5.265  204.228    8.271    3.191
>>>  33554432   5.569    5.712    5.863  179.263    3.755    5.602
>>>  16777216   6.661    6.857    6.550  153.132    2.888    9.571
>>>   8388608   8.022    8.000    7.978  127.998    0.288   16.000
>>>   4194304  10.959   11.579   12.208   88.586    3.902   22.146
>>>   2097152  13.692   12.670   12.625   78.906    2.914   39.453
>>>   1048576  11.120   11.144   10.878   92.703    1.018   92.703
>>>    524288  11.234   10.915   11.374   91.667    1.587  183.334
>>>    262144   6.848    6.678    6.795  151.191    1.594  604.763
>>>    131072   7.393    7.367    7.337  139.025    0.428 1112.202
>>>     65536  10.003   10.919   10.015   99.466    4.019 1591.462
>>>     32768  10.117   10.124   10.169  101.018    0.229 3232.574
>>>     16384  11.614   11.027   11.029   91.293    2.207 5842.771
>>>
>>> Unpatched, 2MB readahead, 512 max_sectors_kb
>>> blocksize       R        R        R   R(avg,    R(std        R
>>>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>>>  67108864   5.268    5.316    5.418  191.996    2.241    3.000
>>>  33554432   5.831    6.459    6.110  167.259    6.977    5.227
>>>  16777216   7.313    7.069    7.197  142.385    1.972    8.899
>>>   8388608   8.657    8.500    8.498  119.754    1.039   14.969
>>>   4194304  11.846   12.116   11.801   85.911    0.994   21.478
>>>   2097152  12.917   13.652   13.100   77.484    1.808   38.742
>>>   1048576   9.544   10.667   10.807   99.345    5.640   99.345
>>>    524288  11.736    7.171    6.599  128.410   29.539  256.821
>>>    262144   7.530    7.403    7.416  137.464    1.053  549.857
>>>    131072   8.741    8.002    8.022  124.256    5.029  994.051
>>>     65536  10.701   10.138   10.090   99.394    2.629 1590.311
>>>     32768   9.978    9.950    9.934  102.875    0.188 3291.994
>>>     16384  11.435   10.823   10.907   92.684    2.234 5931.749
>>>
>>> Unpatched, 512KB readahead, 64 max_sectors_kb
>>> blocksize       R        R        R   R(avg,    R(std        R
>>>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>>>  67108864   3.994    3.991    4.123  253.774    3.838    3.965
>>>  33554432   4.100    4.329    4.161  244.111    5.569    7.628
>>>  16777216   5.476    4.835    5.079  200.148   10.177   12.509
>>>   8388608   5.484    5.258    5.227  192.470    4.084   24.059
>>>   4194304   6.429    6.458    6.435  158.989    0.315   39.747
>>>   2097152   7.219    7.744    7.306  138.081    4.187   69.040
>>>   1048576   6.850    6.897    6.776  149.696    1.089  149.696
>>>    524288   6.406    6.393    6.469  159.439    0.814  318.877
>>>    262144   6.865    7.508    6.861  144.931    6.041  579.726
>>>    131072   8.435    8.482    8.307  121.792    1.076  974.334
>>>     65536   9.616    9.610   10.262  104.279    3.176 1668.462
>>>     32768   9.682    9.932   10.015  103.701    1.497 3318.428
>>>     16384  10.962   10.852   11.565   92.106    2.547 5894.813
>>>
>>> Unpatched, 2MB readahead, 64 max_sectors_kb
>>> blocksize       R        R        R   R(avg,    R(std        R
>>>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>>>  67108864   3.730    3.714    3.914  270.615    6.396    4.228
>>>  33554432   4.445    3.999    3.989  247.710   12.276    7.741
>>>  16777216   4.763    4.712    4.709  216.590    1.122   13.537
>>>   8388608   5.001    5.086    5.229  200.649    3.673   25.081
>>>   4194304   6.365    6.362    6.905  156.710    5.948   39.178
>>>   2097152   7.390    7.367    7.270  139.470    0.992   69.735
>>>   1048576   7.038    7.050    7.090  145.052    0.456  145.052
>>>    524288   6.862    7.167    7.278  144.272    3.617  288.544
>>>    262144   7.266    7.313    7.265  140.635    0.436  562.540
>>>    131072   8.677    8.735    8.821  117.108    0.790  936.865
>>>     65536  10.865   10.040   10.038   99.418    3.658 1590.685
>>>     32768  10.167   10.130   10.177  100.805    0.201 3225.749
>>>     16384  11.643   11.017   11.103   91.041    2.203 5826.629
>>>
>>> Patched, 128KB readahead, 512 max_sectors_kb
>>> blocksize       R        R        R   R(avg,    R(std        R
>>>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>>>  67108864   5.670    5.188    5.636  186.555    7.671    2.915
>>>  33554432   6.069    5.971    6.141  168.992    1.954    5.281
>>>  16777216   7.821    7.501    7.372  135.451    3.340    8.466
>>>   8388608   9.147    8.618    9.000  114.849    2.908   14.356
>>>   4194304  12.199   12.914   12.381   81.981    1.964   20.495
>>>   2097152  13.449   13.891   14.288   73.842    1.828   36.921
>>>   1048576  11.890   12.182   11.519   86.360    1.984   86.360
>>>    524288  11.899   12.706   12.135   83.678    2.287  167.357
>>>    262144   7.460    7.559    7.563  136.041    0.864  544.164
>>>    131072   7.987    8.003    8.530  125.403    3.792 1003.220
>>>     65536  10.179   10.119   10.131  100.957    0.255 1615.312
>>>     32768   9.899    9.923   10.589  101.114    3.121 3235.656
>>>     16384  10.849   10.835   10.876   94.351    0.150 6038.474
>>>
>>> Patched, 512KB readahead, 512 max_sectors_kb
>>> blocksize       R        R        R   R(avg,    R(std        R
>>>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>>>  67108864   5.062    5.111    5.083  201.358    0.795    3.146
>>>  33554432   5.589    5.713    5.657  181.165    1.625    5.661
>>>  16777216   6.337    7.220    6.457  154.002    8.690    9.625
>>>   8388608   7.952    7.880    7.527  131.588    3.192   16.448
>>>   4194304  10.695   11.224   10.736   94.119    2.047   23.530
>>>   2097152  10.898   12.072   12.358   87.215    4.839   43.607
>>>   1048576  10.890   11.347    9.290   98.166    8.664   98.166
>>>    524288  10.898   11.032   10.887   93.611    0.560  187.223
>>>    262144   6.714    7.230    6.804  148.219    4.724  592.875
>>>    131072   7.325    7.342    7.363  139.441    0.295 1115.530
>>>     65536   9.773    9.988   10.592  101.327    3.417 1621.227
>>>     32768  10.031    9.995   10.086  102.019    0.377 3264.620
>>>     16384  11.041   10.987   11.564   91.502    2.093 5856.144
>>>
>>> Patched, 2MB readahead, 512 max_sectors_kb
>>> blocksize       R        R        R   R(avg,    R(std        R
>>>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>>>  67108864   4.970    5.097    5.188  201.435    3.559    3.147
>>>  33554432   5.588    5.793    5.169  186.042    8.923    5.814
>>>  16777216   6.151    6.414    6.526  161.012    4.027   10.063
>>>   8388608   7.836    7.299    7.475  135.980    3.989   16.998
>>>   4194304  11.792   10.964   10.158   93.683    5.706   23.421
>>>   2097152  11.225   11.492   11.357   90.162    0.866   45.081
>>>   1048576  12.017   11.258   11.432   88.580    2.449   88.580
>>>    524288   5.974   10.883   11.840  117.323   38.361  234.647
>>>    262144   6.774    6.765    6.526  153.155    2.661  612.619
>>>    131072   8.036    7.324    7.341  135.579    5.766 1084.633
>>>     65536   9.964   10.595    9.999  100.608    2.806 1609.735
>>>     32768  10.132   10.036   10.190  101.197    0.637 3238.308
>>>     16384  11.133   11.568   11.036   91.093    1.850 5829.981
>>>
>>> Patched, 512KB readahead, 64 max_sectors_kb
>>> blocksize       R        R        R   R(avg,    R(std        R
>>>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>>>  67108864   3.722    3.698    3.721  275.759    0.809    4.309
>>>  33554432   4.058    3.849    3.957  259.063    5.580    8.096
>>>  16777216   4.601    4.613    4.738  220.212    2.913   13.763
>>>   8388608   5.039    5.534    5.017  197.452    8.791   24.682
>>>   4194304   6.302    6.270    6.282  162.942    0.341   40.735
>>>   2097152   7.314    7.302    7.069  141.700    2.233   70.850
>>>   1048576   6.881    7.655    6.909  143.597    6.951  143.597
>>>    524288   7.163    7.025    6.951  145.344    1.803  290.687
>>>    262144   7.315    7.233    7.299  140.621    0.689  562.482
>>>    131072   9.292    8.756    8.807  114.475    3.036  915.803
>>>     65536   9.942    9.985    9.960  102.787    0.181 1644.598
>>>     32768  10.721   10.091   10.192   99.154    2.605 3172.935
>>>     16384  11.049   11.016   11.065   92.727    0.169 5934.531
>>>
>>> Patched, 2MB readahead, 64 max_sectors_kb
>>> blocksize       R        R        R   R(avg,    R(std        R
>>>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>>>  67108864   3.697    3.819    3.741  272.931    3.661    4.265
>>>  33554432   3.951    3.905    4.038  258.320    3.586    8.073
>>>  16777216   5.595    5.182    4.864  197.044   11.236   12.315
>>>   8388608   5.267    5.156    5.116  197.725    2.431   24.716
>>>   4194304   6.411    6.335    6.290  161.389    1.267   40.347
>>>   2097152   7.329    7.663    7.462  136.860    2.502   68.430
>>>   1048576   7.225    7.077    7.215  142.784    1.352  142.784
>>>    524288   6.903    7.015    7.095  146.210    1.647  292.419
>>>    262144   7.365    7.926    7.278  136.309    5.076  545.237
>>>    131072   8.796    8.819    8.814  116.233    0.130  929.862
>>>     65536   9.998   10.609    9.995  100.464    2.786 1607.423
>>>     32768  10.161   10.124   10.246  100.623    0.505 3219.943
>>>
>>> Regards,
>>> Ronald.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
