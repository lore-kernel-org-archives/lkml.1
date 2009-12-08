Return-Path: <linux-kernel-owner+w=401wt.eu-S1755977AbZLHPRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbZLHPRs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 10:17:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755781AbZLHPRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 10:17:47 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:13756 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440AbZLHPRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 10:17:46 -0500
Subject: Re: Block IO Controller V4
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       s-uchida@ap.jp.nec.com, taka@valinux.co.jp, guijianfeng@cn.fujitsu.com,
       jmoyer@redhat.com, righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com
In-Reply-To: <20091130225640.GO11670@redhat.com>
References: <1259549968-10369-1-git-send-email-vgoyal@redhat.com>
	 <4e5e476b0911300734h34a22c88oa5d7d4e5642ead50@mail.gmail.com>
	 <20091130160024.GD11670@redhat.com>
	 <4e5e476b0911301334o2440ea8fi7444aa7d5a688ed1@mail.gmail.com>
	 <1259618433.2701.31.camel@cail>  <20091130225640.GO11670@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Dec 2009 10:17:48 -0500
Message-ID: <1260285468.6686.12.camel@cail>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek - 

Sorry, I've been off doing other work and haven't had time to follow up
on this (until recently). I have runs based upon Jens' for-2.6.33 tree
as of commit 0d99519efef15fd0cf84a849492c7b1deee1e4b7 and your V4 patch
sequence (the refresh patch you sent me on 3 December 2009). I _think_
things look pretty darn good. There are three modes compared:

(1) base - just Jens' for-2.6.33 tree, not patched.
(2) i1,s8 - Your patches added and slice_idle set to 8 (default)
(3) i1,s0 - Your patched added and slice_idle set to 0

I did both synchronous and asynchronous runs, direct I/Os in both case,
random and sequential, with reads, writes and 80%/20% read/write cases.
The results are in throughput (as reported by fio). The first table
shows overall test results, the other tables show breakdowns per cgroup
(disk).

Regards,
Alan

---- ---- - --------- --------- --------- --------- --------- ---------
Mode RdWr N  as,base  as,i1,s8  as,i1,s0   sy,base  sy,i1,s8  sy,i1,s0
---- ---- - --------- --------- --------- --------- --------- ---------
rnd  rd   2      39.7      39.1      43.7      20.5      20.5      20.4
rnd  rd   4      33.9      33.3      41.2      28.5      28.5      28.5
rnd  rd   8      23.7      25.0      36.7      34.4      34.5      34.6

rnd  wr   2      66.1      67.8      68.9      71.8      71.8      71.9
rnd  wr   4      57.8      62.9      66.1      64.1      64.2      64.3
rnd  wr   8      39.5      47.4      60.6      54.7      54.6      54.9

rnd  rdwr 2      50.2      49.1      54.5      31.1      31.1      31.1
rnd  rdwr 4      41.4      41.3      50.9      38.9      39.1      39.6
rnd  rdwr 8      28.1      30.5      46.3      42.5      42.6      43.8

seq  rd   2     612.3     605.7     611.2     509.6     528.3     608.6
seq  rd   4     614.1     606.9     606.2     493.0     490.6     615.4
seq  rd   8     613.6     603.8     605.9     453.0     461.8     617.6

seq  wr   2     694.6     726.1     701.2     685.8     661.8     314.2
seq  wr   4     687.6     715.3     628.3     702.9     702.3     317.8
seq  wr   8     695.0     710.0     629.8     704.0     708.3     339.4

seq  rdwr 2     692.3     664.9     693.8     508.4     504.0     642.8
seq  rdwr 4     664.5     657.1     639.3     484.5     481.0     694.3
seq  rdwr 8     659.0     648.0     634.4     458.1     460.4     709.6

===============================================================

----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- -----
Test        Mode RdWr N test0 test1 test2 test3 test4 test5 test6 test7
----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- -----
as,base     rnd  rd   2  20.0  19.7
as,base     rnd  rd   4   8.8   8.5   8.3   8.3
as,base     rnd  rd   8   3.3   3.1   3.3   3.2   2.7   2.7   2.8   2.6

as,base     rnd  wr   2  33.2  32.9
as,base     rnd  wr   4  15.9  15.2  14.5  12.3
as,base     rnd  wr   8   5.8   3.4   7.8   8.7   3.5   3.4   3.8   3.1

as,base     rnd  rdwr 2  25.0  25.2
as,base     rnd  rdwr 4  10.6  10.4  10.2  10.2
as,base     rnd  rdwr 8   3.7   3.6   4.0   4.1   3.2   3.4   3.3   2.9


as,base     seq  rd   2 305.9 306.4
as,base     seq  rd   4 159.4 160.5 147.3 146.9
as,base     seq  rd   8  79.7  80.0  77.3  78.4  73.0  70.0  77.5  77.7

as,base     seq  wr   2 348.6 346.0
as,base     seq  wr   4 189.9 187.6 154.7 155.3
as,base     seq  wr   8  87.9  88.3  84.7  85.3  84.5  85.1  90.4  88.8

as,base     seq  rdwr 2 347.2 345.1
as,base     seq  rdwr 4 181.6 181.8 150.8 150.2
as,base     seq  rdwr 8  83.6  82.1  82.1  82.7  80.6  82.7  82.2  82.9

----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- -----
Test        Mode RdWr N test0 test1 test2 test3 test4 test5 test6 test7
----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- -----
as,i1,s8    rnd  rd   2  12.7  26.3
as,i1,s8    rnd  rd   4   1.2   3.7  12.2  16.3
as,i1,s8    rnd  rd   8   0.5   0.8   1.2   1.7   2.1   3.5   6.7   8.4

as,i1,s8    rnd  wr   2  18.5  49.3
as,i1,s8    rnd  wr   4   1.0   1.6  20.7  39.6
as,i1,s8    rnd  wr   8   0.5   0.7   0.9   1.2   1.7   2.5  15.5  24.5

as,i1,s8    rnd  rdwr 2  16.2  32.9
as,i1,s8    rnd  rdwr 4   1.2   4.7  15.6  19.9
as,i1,s8    rnd  rdwr 8   0.6   0.8   1.1   1.7   2.1   3.4   9.4  11.5

as,i1,s8    seq  rd   2 202.7 403.0
as,i1,s8    seq  rd   4  92.1 114.7 182.4 217.6
as,i1,s8    seq  rd   8  38.7  76.2  74.0  73.9  74.5  74.7  84.7 107.0

as,i1,s8    seq  wr   2 243.8 482.3
as,i1,s8    seq  wr   4 107.7 155.5 200.4 251.7
as,i1,s8    seq  wr   8  52.1  77.2  81.9  80.8  89.6  99.9 109.8 118.7

as,i1,s8    seq  rdwr 2 225.8 439.1
as,i1,s8    seq  rdwr 4 103.2 140.2 186.5 227.2
as,i1,s8    seq  rdwr 8  50.3  77.4  77.5  78.9  80.5  83.9  94.3 105.2

----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- -----
Test        Mode RdWr N test0 test1 test2 test3 test4 test5 test6 test7
----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- -----
as,i1,s0    rnd  rd   2  21.9  21.8
as,i1,s0    rnd  rd   4  11.4  12.0   9.1   8.7
as,i1,s0    rnd  rd   8   3.2   3.2   6.7   6.7   4.7   4.0   4.7   3.5

as,i1,s0    rnd  wr   2  34.5  34.4
as,i1,s0    rnd  wr   4  21.6  20.5  12.6  11.4
as,i1,s0    rnd  wr   8   5.1   4.8  18.2  16.9   4.1   4.0   4.0   3.3

as,i1,s0    rnd  rdwr 2  27.5  27.0
as,i1,s0    rnd  rdwr 4  16.1  15.4  10.2   9.2
as,i1,s0    rnd  rdwr 8   5.3   4.6   9.9   9.7   4.6   4.0   4.4   3.8

as,i1,s0    seq  rd   2 305.5 305.6
as,i1,s0    seq  rd   4 159.5 157.3 144.1 145.3
as,i1,s0    seq  rd   8  74.1  74.6  76.7  76.4  74.6  76.7  75.5  77.4

as,i1,s0    seq  wr   2 350.3 350.9
as,i1,s0    seq  wr   4 160.3 161.7 153.1 153.2
as,i1,s0    seq  wr   8  79.5  80.9  78.2  78.7  79.7  78.3  77.8  76.7

as,i1,s0    seq  rdwr 2 346.8 347.0
as,i1,s0    seq  rdwr 4 163.3 163.5 156.7 155.8
as,i1,s0    seq  rdwr 8  79.1  79.4  80.1  80.3  79.1  78.9  79.6  77.8

----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- -----
Test        Mode RdWr N test0 test1 test2 test3 test4 test5 test6 test7
----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- -----
sy,base     rnd  rd   2  10.2  10.2
sy,base     rnd  rd   4   7.2   7.2   7.1   7.0
sy,base     rnd  rd   8   4.1   4.1   4.5   4.5   4.3   4.3   4.4   4.1

sy,base     rnd  wr   2  36.1  35.7
sy,base     rnd  wr   4  16.7  16.5  15.6  15.3
sy,base     rnd  wr   8   5.7   5.4   9.0   8.6   6.6   6.5   6.8   6.0

sy,base     rnd  rdwr 2  15.5  15.5
sy,base     rnd  rdwr 4   9.9   9.8   9.7   9.6
sy,base     rnd  rdwr 8   4.8   4.9   5.8   5.8   5.4   5.4   5.4   4.9

sy,base     seq  rd   2 254.7 254.8
sy,base     seq  rd   4 124.2 123.6 121.8 123.4
sy,base     seq  rd   8  56.9  56.5  56.1  56.8  56.6  56.7  56.5  56.9

sy,base     seq  wr   2 343.1 342.8
sy,base     seq  wr   4 177.4 177.9 173.1 174.7
sy,base     seq  wr   8  86.2  87.5  87.6  89.5  86.8  89.6  88.0  88.7

sy,base     seq  rdwr 2 254.0 254.4
sy,base     seq  rdwr 4 124.2 124.5 118.0 117.8
sy,base     seq  rdwr 8  57.2  56.8  57.0  58.8  56.8  56.3  57.5  57.8

----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- -----
Test        Mode RdWr N test0 test1 test2 test3 test4 test5 test6 test7
----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- -----
sy,i1,s8    rnd  rd   2  10.2  10.2
sy,i1,s8    rnd  rd   4   7.2   7.2   7.1   7.1
sy,i1,s8    rnd  rd   8   4.1   4.1   4.5   4.5   4.4   4.4   4.4   4.2

sy,i1,s8    rnd  wr   2  36.2  35.5
sy,i1,s8    rnd  wr   4  16.9  17.0  15.3  15.0
sy,i1,s8    rnd  wr   8   5.7   5.6   8.5   8.7   6.7   6.5   6.6   6.3

sy,i1,s8    rnd  rdwr 2  15.5  15.5
sy,i1,s8    rnd  rdwr 4   9.8   9.8   9.7   9.6
sy,i1,s8    rnd  rdwr 8   4.9   4.9   5.9   5.8   5.4   5.4   5.4   5.0

sy,i1,s8    seq  rd   2 165.9 362.3
sy,i1,s8    seq  rd   4  54.0  97.2 145.5 193.9
sy,i1,s8    seq  rd   8  14.9  31.4  41.8  52.8  62.8  73.2  85.9  98.8

sy,i1,s8    seq  wr   2 220.7 441.1
sy,i1,s8    seq  wr   4  77.6 141.9 208.6 274.3
sy,i1,s8    seq  wr   8  24.9  47.3  63.8  79.1  97.8 114.8 132.1 148.6

sy,i1,s8    seq  rdwr 2 167.7 336.4
sy,i1,s8    seq  rdwr 4  54.5  98.2 141.1 187.2
sy,i1,s8    seq  rdwr 8  16.7  31.8  41.4  52.3  63.1  73.9  84.6  96.7

----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- -----
Test        Mode RdWr N test0 test1 test2 test3 test4 test5 test6 test7
----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- -----
sy,i1,s0    rnd  rd   2  10.2  10.2
sy,i1,s0    rnd  rd   4   7.2   7.2   7.1   7.1
sy,i1,s0    rnd  rd   8   4.1   4.1   4.6   4.6   4.4   4.4   4.4   4.2

sy,i1,s0    rnd  wr   2  36.3  35.6
sy,i1,s0    rnd  wr   4  16.9  17.0  15.3  15.2
sy,i1,s0    rnd  wr   8   6.0   6.0   8.9   8.8   6.5   6.2   6.5   5.9

sy,i1,s0    rnd  rdwr 2  15.6  15.6
sy,i1,s0    rnd  rdwr 4  10.0  10.0   9.8   9.8
sy,i1,s0    rnd  rdwr 8   5.0   5.0   6.0   6.0   5.5   5.5   5.6   5.1

sy,i1,s0    seq  rd   2 304.2 304.3
sy,i1,s0    seq  rd   4 154.2 154.2 153.4 153.7
sy,i1,s0    seq  rd   8  76.9  76.8  77.3  76.9  77.1  77.2  77.4  78.0

sy,i1,s0    seq  wr   2 156.8 157.4
sy,i1,s0    seq  wr   4  80.7  79.6  78.5  79.0
sy,i1,s0    seq  wr   8  43.2  41.7  41.7  42.6  42.1  42.6  42.8  42.7

sy,i1,s0    seq  rdwr 2 321.1 321.7
sy,i1,s0    seq  rdwr 4 174.2 174.0 172.6 173.6
sy,i1,s0    seq  rdwr 8  86.6  86.3  88.6  88.9  90.2  89.8  90.1  89.0





