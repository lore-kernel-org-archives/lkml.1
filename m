Return-Path: <linux-kernel-owner+w=401wt.eu-S1756666AbZGCK4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666AbZGCK4R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 06:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754115AbZGCK4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 06:56:03 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64279 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754016AbZGCK4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 06:56:02 -0400
Message-ID: <4A4DE3C1.5080307@vlnb.net>
Date: Fri, 03 Jul 2009 14:56:01 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ronald Moesbergen <intercommit@gmail.com>
CC: Wu Fengguang <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [RESEND] [PATCH] readahead:add blk_run_backing_dev
References: <4A3CD62B.1020407@vlnb.net> <4A489DAC.7000007@vlnb.net>	 <20090629125434.GA8416@localhost> <4A48BBF9.6050408@vlnb.net>	 <a0272b440906290700v7367d1c1r7237fd6593be00d2@mail.gmail.com>	 <20090629142124.GA28945@localhost> <20090629150109.GA3534@localhost>	 <4A48DFC5.3090205@vlnb.net> <20090630010414.GB31418@localhost>	 <4A49EEF9.6010205@vlnb.net> <a0272b440907030214l4016422bxbc98fd003bfe1b3d@mail.gmail.com>
In-Reply-To: <a0272b440907030214l4016422bxbc98fd003bfe1b3d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+Lj9QuiUYqss8VLcm8tn92LvxKWWkUE8lWi6z
 pmQA3g1xtnMgDpHwHvZXK8Do9oca4P0cgfeMfK5xY9jdoMidtA
 DwsnP5Y0vaxxFaszlE6AQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ronald Moesbergen, on 07/03/2009 01:14 PM wrote:
>>> OK, now I tend to agree on decreasing max_sectors_kb and increasing
>>> read_ahead_kb. But before actually trying to push that idea I'd like
>>> to
>>> - do more benchmarks
>>> - figure out why context readahead didn't help SCST performance
>>>  (previous traces show that context readahead is submitting perfect
>>>   large io requests, so I wonder if it's some io scheduler bug)
>> Because, as we found out, without your http://lkml.org/lkml/2009/5/21/319
>> patch read-ahead was nearly disabled, hence there were no difference which
>> algorithm was used?
>>
>> Ronald, can you run the following tests, please? This time with 2 hosts,
>> initiator (client) and target (server) connected using 1 Gbps iSCSI. It
>> would be the best if on the client vanilla 2.6.29 will be ran, but any other
>> kernel will be fine as well, only specify which. Blockdev-perftest should be
>> ran as before in buffered mode, i.e. with "-a" switch.
>>
>> 1. All defaults on the client, on the server vanilla 2.6.29 with Fengguang's
>> http://lkml.org/lkml/2009/5/21/319 patch with all default settings.
>>
>> 2. All defaults on the client, on the server vanilla 2.6.29 with Fengguang's
>> http://lkml.org/lkml/2009/5/21/319 patch with default RA size and 64KB
>> max_sectors_kb.
>>
>> 3. All defaults on the client, on the server vanilla 2.6.29 with Fengguang's
>> http://lkml.org/lkml/2009/5/21/319 patch with 2MB RA size and default
>> max_sectors_kb.
>>
>> 4. All defaults on the client, on the server vanilla 2.6.29 with Fengguang's
>> http://lkml.org/lkml/2009/5/21/319 patch with 2MB RA size and 64KB
>> max_sectors_kb.
>>
>> 5. All defaults on the client, on the server vanilla 2.6.29 with Fengguang's
>> http://lkml.org/lkml/2009/5/21/319 patch and with context RA patch. RA size
>> and max_sectors_kb are default. For your convenience I committed the
>> backported context RA patches into the SCST SVN repository.
>>
>> 6. All defaults on the client, on the server vanilla 2.6.29 with Fengguang's
>> http://lkml.org/lkml/2009/5/21/319 and context RA patches with default RA
>> size and 64KB max_sectors_kb.
>>
>> 7. All defaults on the client, on the server vanilla 2.6.29 with Fengguang's
>> http://lkml.org/lkml/2009/5/21/319 and context RA patches with 2MB RA size
>> and default max_sectors_kb.
>>
>> 8. All defaults on the client, on the server vanilla 2.6.29 with Fengguang's
>> http://lkml.org/lkml/2009/5/21/319 and context RA patches with 2MB RA size
>> and 64KB max_sectors_kb.
>>
>> 9. On the client default RA size and 64KB max_sectors_kb. On the server
>> vanilla 2.6.29 with Fengguang's http://lkml.org/lkml/2009/5/21/319 and
>> context RA patches with 2MB RA size and 64KB max_sectors_kb.
>>
>> 10. On the client 2MB RA size and default max_sectors_kb. On the server
>> vanilla 2.6.29 with Fengguang's http://lkml.org/lkml/2009/5/21/319 and
>> context RA patches with 2MB RA size and 64KB max_sectors_kb.
>>
>> 11. On the client 2MB RA size and 64KB max_sectors_kb. On the server vanilla
>> 2.6.29 with Fengguang's http://lkml.org/lkml/2009/5/21/319 and context RA
>> patches with 2MB RA size and 64KB max_sectors_kb.
> 
> Ok, done. Performance is pretty bad overall :(
> 
> The kernels I used:
> client kernel: 2.6.26-15lenny3 (debian)
> server kernel: 2.6.29.5 with blk_dev_run patch
> 
> And I adjusted the blockdev-perftest script to drop caches on both the
> server (via ssh) and the client.
> 
> The results:
> 
> 1) client: default, server: default
> blocksize       R        R        R   R(avg,    R(std        R
>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>  67108864  19.808   20.078   20.180   51.147    0.402    0.799
>  33554432  19.162   19.952   20.375   51.673    1.322    1.615
>  16777216  19.714   20.331   19.948   51.214    0.649    3.201
>   8388608  18.572   20.126   20.345   52.116    2.149    6.515
>   4194304  18.711   19.663   19.811   52.831    1.350   13.208
>   2097152  19.112   19.927   19.130   52.832    1.022   26.416
>   1048576  19.771   19.686   20.010   51.661    0.356   51.661
>    524288  19.585   19.940   19.483   52.065    0.515  104.131
>    262144  19.168   20.794   19.605   51.634    1.757  206.535
>    131072  19.077   20.776   20.271   51.160    1.849  409.282
>     65536  19.643   21.230   19.144   51.284    2.227  820.549
>     32768  19.702   20.869   19.686   51.020    1.380 1632.635
>     16384  21.218   20.222   20.221   49.846    1.121 3190.174
> 
> 2) client: default, server: 64 max_sectors_kb
> blocksize       R        R        R   R(avg,    R(std        R
>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>  67108864  20.881   20.102   21.689   49.065    1.522    0.767
>  33554432  20.329   19.938   20.522   50.543    0.609    1.579
>  16777216  20.247   19.744   20.912   50.468    1.185    3.154
>   8388608  19.739   20.184   21.032   50.433    1.318    6.304
>   4194304  19.968   18.748   20.230   52.174    1.750   13.043
>   2097152  19.633   20.068   19.858   51.584    0.462   25.792
>   1048576  20.552   20.618   20.974   49.437    0.440   49.437
>    524288  21.595   20.830   20.454   48.881    1.098   97.762
>    262144  21.720   20.602   20.176   49.201    1.515  196.805
>    131072  20.976   19.089   20.712   50.634    2.144  405.072
>     65536  20.661   19.952   19.312   51.303    1.414  820.854
>     32768  21.155   18.464   20.640   51.159    3.081 1637.090
>     16384  22.023   19.944   20.629   49.159    2.008 3146.205
> 
> 3) client: default, server: default max_sectors_kb, RA 2MB
> blocksize       R        R        R   R(avg,    R(std        R
>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>  67108864  21.709   19.315   18.319   52.028    3.631    0.813
>  33554432  20.745   19.209   19.048   52.142    1.976    1.629
>  16777216  19.762   19.175   19.485   52.591    0.649    3.287
>   8388608  19.812   19.142   19.574   52.498    0.749    6.562
>   4194304  19.931   19.786   19.505   51.877    0.466   12.969
>   2097152  19.473   19.208   19.438   52.859    0.322   26.430
>   1048576  19.524   19.033   19.477   52.941    0.610   52.941
>    524288  20.115   20.402   19.542   51.166    0.920  102.333
>    262144  19.291   19.715   21.016   51.249    1.844  204.996
>    131072  18.782   19.130   20.334   52.802    1.775  422.419
>     65536  19.030   19.233   20.328   52.475    1.504  839.599
>     32768  19.147   19.326   19.411   53.074    0.303 1698.357
>     16384  19.573   19.596   20.417   51.575    1.005 3300.788
> 
> 4) client: default, server: 64 max_sectors_kb, RA 2MB
> blocksize       R        R        R   R(avg,    R(std        R
>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>  67108864  22.604   21.707   20.721   47.298    1.683    0.739
>  33554432  21.654   20.812   21.162   48.293    0.784    1.509
>  16777216  20.461   19.782   21.160   50.068    1.377    3.129
>   8388608  20.886   20.434   21.512   48.914    1.028    6.114
>   4194304  22.154   20.512   21.433   47.974    1.517   11.993
>   2097152  22.258   20.971   20.738   48.071    1.478   24.035
>   1048576  19.953   21.294   19.662   50.497    1.731   50.497
>    524288  21.577   20.884   20.883   48.509    0.743   97.019
>    262144  20.959   20.749   20.256   49.587    0.712  198.347
>    131072  19.926   21.542   19.634   50.360    2.022  402.877
>     65536  20.973   22.546   20.840   47.793    1.685  764.690
>     32768  20.695   21.031   21.182   48.837    0.476 1562.791
>     16384  20.163   21.112   20.037   50.133    1.159 3208.481
> 
> 5) Server RA-context Patched, client: default, server: default
> blocksize       R        R        R   R(avg,    R(std        R
>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>  67108864  19.756   23.647   18.852   49.818    4.717    0.778
>  33554432  18.892   19.727   18.857   53.472    1.106    1.671
>  16777216  18.943   19.255   18.949   53.760    0.409    3.360
>   8388608  18.766   19.105   18.847   54.165    0.413    6.771
>   4194304  19.177   19.609   20.191   52.111    1.097   13.028
>   2097152  18.968   19.517   18.862   53.581    0.797   26.790
>   1048576  18.833   19.912   18.626   53.592    1.551   53.592
>    524288  19.128   19.379   19.134   53.298    0.324  106.596
>    262144  18.955   19.328   18.879   53.748    0.550  214.992
>    131072  18.401   19.642   18.928   53.961    1.439  431.691
>     65536  19.366   19.822   18.615   53.182    1.384  850.908
>     32768  19.252   19.229   18.752   53.683    0.653 1717.857
>     16384  21.373   19.507   19.162   51.282    2.415 3282.039
> 
> 6) Server RA-context Patched, client: default, server: 64
> max_sectors_kb, RA default
> blocksize       R        R        R   R(avg,    R(std        R
>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>  67108864  22.753   21.071   20.532   47.825    2.061    0.747
>  33554432  20.404   19.239   20.722   50.943    1.644    1.592
>  16777216  20.914   20.114   21.854   48.910    1.655    3.057
>   8388608  19.524   21.932   21.465   48.949    2.510    6.119
>   4194304  20.306   20.809   20.000   50.279    0.820   12.570
>   2097152  20.133   20.194   20.181   50.770    0.066   25.385
>   1048576  19.515   21.593   20.052   50.321    2.128   50.321
>    524288  20.231   20.502   20.299   50.335    0.284  100.670
>    262144  19.620   19.737   19.911   51.834    0.313  207.336
>    131072  20.486   21.138   22.339   48.089    1.711  384.714
>     65536  20.113   18.322   22.247   50.943    4.025  815.088
>     32768  23.341   23.328   20.809   45.659    2.511 1461.089
>     16384  20.962   21.839   23.405   46.496    2.100 2975.773
> 
> 7) Server RA-context Patched, client: default, server: default
> max_sectors_kb, RA 2MB
> blocksize       R        R        R   R(avg,    R(std        R
>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>  67108864  19.565   19.028   19.164   53.196    0.627    0.831
>  33554432  19.048   18.401   18.940   54.491    0.828    1.703
>  16777216  18.728   19.330   19.076   53.778    0.699    3.361
>   8388608  19.174   18.710   19.922   53.179    1.368    6.647
>   4194304  19.133   18.514   19.672   53.628    1.331   13.407
>   2097152  18.903   18.547   20.070   53.468    1.782   26.734
>   1048576  19.210   19.204   18.994   53.513    0.282   53.513
>    524288  18.978   18.723   20.839   52.596    2.464  105.192
>    262144  18.912   18.590   18.635   54.726    0.415  218.905
>    131072  18.732   18.578   19.797   53.837    1.505  430.694
>     65536  19.046   18.872   19.318   53.678    0.516  858.852
>     32768  18.490   18.582   20.374   53.583    2.353 1714.661
>     16384  19.138   19.215   20.602   52.167    1.744 3338.700
> 
>  8) Server RA-context Patched, client: default, server: 64
> max_sectors_kb, RA 2MB
> blocksize       R        R        R   R(avg,    R(std        R
>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>  67108864  21.029   21.654   21.093   48.177    0.630    0.753
>  33554432  21.174   19.759   20.659   49.918    1.435    1.560
>  16777216  20.385   20.235   22.145   49.026    1.976    3.064
>   8388608  19.053   20.162   20.158   51.778    1.391    6.472
>   4194304  20.123   23.173   20.073   48.696    3.188   12.174
>   2097152  19.401   20.824   20.326   50.778    1.500   25.389
>   1048576  21.821   21.401   21.026   47.825    0.724   47.825
>    524288  21.478   20.742   21.355   48.332    0.742   96.664
>    262144  20.290   20.183   20.980   50.004    0.853  200.015
>    131072  20.299   21.501   20.766   49.127    1.158  393.020
>     65536  21.087   19.340   20.867   50.193    1.959  803.092
>     32768  21.597   21.223   23.504   46.410    2.039 1485.132
>     16384  21.681   21.709   22.944   46.343    1.212 2965.967
> 
> 9) Server RA-context Patched, client: 64 max_sectors_kb, default RA.
> server: 64 max_sectors_kb, RA 2MB
> blocksize       R        R        R   R(avg,    R(std        R
>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>  67108864  42.767   40.615   41.188   24.672    0.535    0.386
>  33554432  41.204   42.294   40.514   24.780    0.437    0.774
>  16777216  39.774   42.809   41.804   24.720    0.762    1.545
>   8388608  42.292   41.799   40.386   24.689    0.486    3.086
>   4194304  41.784   39.037   41.830   25.073    0.819    6.268
>   2097152  41.983   41.145   44.115   24.164    0.703   12.082
>   1048576  41.468   43.495   41.640   24.276    0.520   24.276
>    524288  42.631   42.724   41.267   24.267    0.387   48.535
>    262144  41.930   41.954   41.975   24.408    0.011   97.634
>    131072  42.511   41.266   42.835   24.269    0.393  194.154
>     65536  41.307   41.544   40.746   24.857    0.203  397.704
>     32768  42.270   42.728   40.822   24.425    0.478  781.607
>     16384  39.307   40.044   40.259   25.686    0.264 1643.908
>      8192  41.258   40.879   40.969   24.955    0.098 3194.183
> 
> 10) Server RA-context Patched, client: default max_sectors_kb, 2MB RA.
> server: 64 max_sectors_kb, RA 2MB
> blocksize       R        R        R   R(avg,    R(std        R
>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>  67108864  26.160   26.878   25.790   38.982    0.666    0.609
>  33554432  25.832   25.362   25.695   39.956    0.309    1.249
>  16777216  26.119   24.769   25.526   40.221    0.876    2.514
>   8388608  25.660   26.257   25.106   39.898    0.730    4.987
>   4194304  26.603   25.404   25.271   39.773    0.910    9.943
>   2097152  26.012   24.815   26.064   39.973    0.914   19.986
>   1048576  25.256   27.073   25.153   39.693    1.323   39.693
>    524288  29.452   28.883   29.146   35.118    0.280   70.236
>    262144  26.559   27.315   26.837   38.067    0.440  152.268
>    131072  25.259   25.794   25.992   39.879    0.483  319.030
>     65536  26.417   25.205   26.177   39.503    0.808  632.047
>     32768  26.453   26.401   25.759   39.083    0.474 1250.669
>     16384  24.701   24.609   25.143   41.265    0.385 2640.945
> 
> 11) Server RA-context Patched, client: 64 max_sectors_kb, 2MB. RA
> server: 64 max_sectors_kb, RA 2MB
> blocksize       R        R        R   R(avg,    R(std        R
>   (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>  67108864  29.629   31.703   30.407   33.513    0.930    0.524
>  33554432  29.768   29.598   30.717   34.111    0.553    1.066
>  16777216  30.054   30.640   30.102   33.837    0.295    2.115
>   8388608  29.906   29.744   31.394   33.762    0.813    4.220
>   4194304  30.708   30.797   30.418   33.420    0.177    8.355
>   2097152  31.364   29.646   30.712   33.511    0.781   16.755
>   1048576  30.757   30.600   30.470   33.455    0.128   33.455
>    524288  29.715   31.176   29.977   33.822    0.701   67.644
>    262144  30.533   30.218   30.259   33.755    0.155  135.021
>    131072  30.403   32.609   30.651   32.831    1.016  262.645
>     65536  30.846   30.208   32.116   32.993    0.835  527.889
>     32768  30.526   29.794   30.556   33.809    0.397 1081.878
>     16384  31.560   31.532   30.938   32.673    0.301 2091.092

Those are on the server without io_context-2.6.29 and readahead-2.6.29 
patches applied and with CFQ scheduler, correct?

Then we see how reorder of requests caused by many I/O threads 
submitting I/O in separate I/O contexts badly affect performance and no 
RA, especially with default 128KB RA size, can solve it. Less 
max_sectors_kb on the client => more requests it sends at once => more 
reorder on the server => worse throughput. Although, Fengguang, in 
theory, context RA with 2MB RA size should considerably help it, no?

Ronald, can you perform those tests again with both io_context-2.6.29 
and readahead-2.6.29 patches applied on the server, please?

Thanks,
Vlad
