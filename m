Return-Path: <linux-kernel-owner+w=401wt.eu-S1757225AbZKROac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757225AbZKROac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 09:30:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757172AbZKROac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 09:30:32 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:35565 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757044AbZKROab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 09:30:31 -0500
Subject: Re: [RFC] Block IO Controller V3 - some results
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1258550578.2797.15.camel@cail>
References: <1258550578.2797.15.camel@cail>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Nov 2009 09:30:35 -0500
Message-ID: <1258554635.2797.19.camel@cail>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've added in the base OS results. Haven't analyzed them fully (on
vacation :-) ) but it looks like we do lose some performance (first
table) and some oddities in apportionment proportions...

---- ---- - --------- --------- --------- --------- --------- 
Mode RdWr N   base    i1,g1,s8  i1,g0,s8  i1,g1,s0  i1,g0,s0  
---- ---- - --------- --------- --------- --------- --------- 
rnd  rd   2      37.8      33.7      33.2      33.2      33.2 
rnd  rd   4      37.1      28.6      26.8      26.7      26.7 
rnd  rd   8      39.5      20.8      17.6      17.8      17.7 

rnd  wr   2      59.9      57.4      55.8      55.9      55.8 
rnd  wr   4      59.4      52.1      47.8      47.6      47.6 
rnd  wr   8      58.3      41.6      30.8      30.7      30.7 

rnd  rdwr 2      44.6      39.0      38.3      38.3      38.5 
rnd  rdwr 4      44.6      33.2      30.5      30.4      30.7 
rnd  rdwr 8      47.8      24.0      19.0      19.2      19.5 

seq  rd   2     610.4     609.5     609.6     608.4     608.5 
seq  rd   4     612.4     612.1     612.3     613.5     613.7 
seq  rd   8     615.2     614.8     615.4     616.3     616.2 

seq  wr   2     719.1     716.2     722.7     732.2     736.9 
seq  wr   4     709.1     710.5     734.2     737.4     734.4 
seq  wr   8     696.4     700.6     714.0     720.1     715.8 

seq  rdwr 2     699.8     666.7     669.1     673.4     673.1 
seq  rdwr 4     672.5     668.1     668.5     667.5     667.9 
seq  rdwr 8     675.3     674.0     674.9     675.6     676.2 

===============================================================

----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- ----- 
Test        Mode RdWr N test0 test1 test2 test3 test4 test5 test6 test7 
----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- ----- 
base        rnd  rd   2  18.8  19.1 
base        rnd  rd   4   9.9   9.8   9.2   8.2 
base        rnd  rd   8   4.9   5.0   4.9   5.0   4.9   4.9   4.8   5.0 

base        rnd  wr   2  22.4  37.5 
base        rnd  wr   4  15.4  14.4  15.4  14.2 
base        rnd  wr   8   7.6   6.9   7.2   7.4   7.3   7.4   7.2   7.4 

base        rnd  rdwr 2  21.1  23.5 
base        rnd  rdwr 4  11.1  11.6  10.7  11.3 
base        rnd  rdwr 8   6.0   6.0   6.1   6.0   5.8   5.8   6.1   5.8 


base        seq  rd   2 306.1 304.3 
base        seq  rd   4 153.2 151.9 152.7 154.5 
base        seq  rd   8  80.7  75.6  76.7  76.0  76.8  76.1  77.8  75.4 

base        seq  wr   2 358.9 360.2 
base        seq  wr   4 179.7 176.6 175.0 177.7 
base        seq  wr   8  88.2  84.5  88.0  86.1  86.0  88.4  86.3  88.9 

base        seq  rdwr 2 350.1 349.7 
base        seq  rdwr 4 164.2 178.3 164.1 166.0 
base        seq  rdwr 8  83.4  84.9  84.0  81.2  87.4  83.5  85.1  85.8

----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- ----- 
Test        Mode RdWr N test0 test1 test2 test3 test4 test5 test6 test7 
----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- ----- 
i1,g1,s8    rnd  rd   2  11.1  22.6 
i1,g1,s8    rnd  rd   4   0.8   2.6  10.4  14.8 
i1,g1,s8    rnd  rd   8   0.4   0.7   1.0   1.4   2.0   3.2   5.3   6.8 

i1,g1,s8    rnd  wr   2  12.2  45.3 
i1,g1,s8    rnd  wr   4   0.6   1.3  16.7  33.5 
i1,g1,s8    rnd  wr   8   0.3   0.5   0.7   0.9   1.4   2.2  11.7  24.0 

i1,g1,s8    rnd  rdwr 2  12.6  26.4 
i1,g1,s8    rnd  rdwr 4   0.7   2.2  12.3  18.0 
i1,g1,s8    rnd  rdwr 8   0.3   0.5   0.8   1.2   1.8   3.5   7.1   8.7 


i1,g1,s8    seq  rd   2 234.7 374.8 
i1,g1,s8    seq  rd   4  89.7 130.1 171.8 220.4 
i1,g1,s8    seq  rd   8  34.7  59.1  65.2  74.6  85.4  89.8  97.9 108.1 

i1,g1,s8    seq  wr   2 264.4 451.9 
i1,g1,s8    seq  wr   4  98.4 151.5 203.8 256.8 
i1,g1,s8    seq  wr   8  37.7  65.0  74.3  86.5  96.0 102.8 113.7 124.6 

i1,g1,s8    seq  rdwr 2 240.0 426.7 
i1,g1,s8    seq  rdwr 4  92.3 139.5 191.0 245.3 
i1,g1,s8    seq  rdwr 8  33.7  59.7  68.0  80.2  94.1 103.2 111.9 123.3 

----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- ----- 
Test        Mode RdWr N test0 test1 test2 test3 test4 test5 test6 test7 
----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- ----- 
i1,g0,s8    rnd  rd   2  12.1  21.1 
i1,g0,s8    rnd  rd   4   2.2   5.8   8.1  10.7 
i1,g0,s8    rnd  rd   8   1.2   1.3   1.6   2.2   2.3   2.5   3.1   3.4 

i1,g0,s8    rnd  wr   2  21.1  34.7 
i1,g0,s8    rnd  wr   4  11.9  12.2  11.9  11.9 
i1,g0,s8    rnd  wr   8   4.0   4.0   4.0   3.9   3.8   3.7   3.7   3.6 

i1,g0,s8    rnd  rdwr 2  13.9  24.3 
i1,g0,s8    rnd  rdwr 4   3.1   7.5   9.3  10.5 
i1,g0,s8    rnd  rdwr 8   1.5   1.6   1.8   2.2   2.5   2.7   3.4   3.3 


i1,g0,s8    seq  rd   2 264.1 345.4 
i1,g0,s8    seq  rd   4  92.7 133.2 169.1 217.3 
i1,g0,s8    seq  rd   8  41.5  64.5  67.1  76.1  85.0  84.6  91.0 105.5 

i1,g0,s8    seq  wr   2 319.1 403.6 
i1,g0,s8    seq  wr   4 108.4 164.0 210.2 251.6 
i1,g0,s8    seq  wr   8  50.8  72.3  78.5  87.3  94.2  99.9 109.0 122.0 

i1,g0,s8    seq  rdwr 2 267.4 401.7 
i1,g0,s8    seq  rdwr 4  94.0 138.5 191.8 244.3 
i1,g0,s8    seq  rdwr 8  38.9  61.5  72.2  83.0  95.1 100.1 106.0 118.1 

----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- ----- 
Test        Mode RdWr N test0 test1 test2 test3 test4 test5 test6 test7 
----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- ----- 
i1,g0,s8    rnd  rd   2  12.1  21.1 
i1,g0,s8    rnd  rd   4   2.2   5.8   8.1  10.7 
i1,g0,s8    rnd  rd   8   1.2   1.3   1.6   2.2   2.3   2.5   3.1   3.4 

i1,g0,s8    rnd  wr   2  21.1  34.7 
i1,g0,s8    rnd  wr   4  11.9  12.2  11.9  11.9 
i1,g0,s8    rnd  wr   8   4.0   4.0   4.0   3.9   3.8   3.7   3.7   3.6 

i1,g0,s8    rnd  rdwr 2  13.9  24.3 
i1,g0,s8    rnd  rdwr 4   3.1   7.5   9.3  10.5 
i1,g0,s8    rnd  rdwr 8   1.5   1.6   1.8   2.2   2.5   2.7   3.4   3.3 


i1,g0,s8    seq  rd   2 264.1 345.4 
i1,g0,s8    seq  rd   4  92.7 133.2 169.1 217.3 
i1,g0,s8    seq  rd   8  41.5  64.5  67.1  76.1  85.0  84.6  91.0 105.5 

i1,g0,s8    seq  wr   2 319.1 403.6 
i1,g0,s8    seq  wr   4 108.4 164.0 210.2 251.6 
i1,g0,s8    seq  wr   8  50.8  72.3  78.5  87.3  94.2  99.9 109.0 122.0 

i1,g0,s8    seq  rdwr 2 267.4 401.7 
i1,g0,s8    seq  rdwr 4  94.0 138.5 191.8 244.3 
i1,g0,s8    seq  rdwr 8  38.9  61.5  72.2  83.0  95.1 100.1 106.0 118.1 

----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- ----- 
Test        Mode RdWr N test0 test1 test2 test3 test4 test5 test6 test7 
----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- ----- 
i1,g1,s0    rnd  rd   2  12.1  21.1 
i1,g1,s0    rnd  rd   4   2.4   6.3   8.4   9.5 
i1,g1,s0    rnd  rd   8   1.0   1.4   1.7   2.1   2.5   2.7   3.1   3.4 

i1,g1,s0    rnd  wr   2  21.8  34.1 
i1,g1,s0    rnd  wr   4  12.6  12.4  11.4  11.2 
i1,g1,s0    rnd  wr   8   5.0   4.5   3.9   3.7   3.5   3.4   3.4   3.3 

i1,g1,s0    rnd  rdwr 2  14.1  24.2 
i1,g1,s0    rnd  rdwr 4   3.6   7.7   9.0  10.1 
i1,g1,s0    rnd  rdwr 8   1.2   1.7   1.9   2.2   2.4   2.8   3.3   3.8 


i1,g1,s0    seq  rd   2 299.7 308.7 
i1,g1,s0    seq  rd   4 102.6 159.5 171.3 180.2 
i1,g1,s0    seq  rd   8  60.2  71.0  61.8  65.6  73.4  87.3  96.9 100.3 

i1,g1,s0    seq  wr   2 351.3 380.9 
i1,g1,s0    seq  wr   4 119.1 181.9 206.2 230.2 
i1,g1,s0    seq  wr   8  63.9  74.9  74.0  81.3  92.2 101.3 111.7 120.8 

i1,g1,s0    seq  rdwr 2 296.1 377.4 
i1,g1,s0    seq  rdwr 4  99.8 137.6 188.5 241.7 
i1,g1,s0    seq  rdwr 8  53.9  64.7  70.5  82.5  92.9  92.5 102.0 116.6 

----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- ----- 
Test        Mode RdWr N test0 test1 test2 test3 test4 test5 test6 test7 
----------- ---- ---- - ----- ----- ----- ----- ----- ----- ----- ----- 
i1,g0,s0    rnd  rd   2  12.3  20.9 
i1,g0,s0    rnd  rd   4   2.6   6.5   7.8   9.8 
i1,g0,s0    rnd  rd   8   1.0   1.4   1.7   2.1   2.4   2.7   3.2   3.4 

i1,g0,s0    rnd  wr   2  21.7  34.2 
i1,g0,s0    rnd  wr   4  13.8  11.9  11.1  10.8 
i1,g0,s0    rnd  wr   8   5.1   4.5   3.9   3.6   3.5   3.4   3.3   3.3 

i1,g0,s0    rnd  rdwr 2  14.1  24.4 
i1,g0,s0    rnd  rdwr 4   3.9   7.6   8.4  10.8 
i1,g0,s0    rnd  rdwr 8   1.1   1.6   1.9   2.3   2.6   3.0   3.3   3.6 


i1,g0,s0    seq  rd   2 300.0 308.5 
i1,g0,s0    seq  rd   4 101.8 160.1 171.4 180.4 
i1,g0,s0    seq  rd   8  61.3  71.7  61.3  65.6  73.9  85.5  96.4 100.4 

i1,g0,s0    seq  wr   2 354.1 382.8 
i1,g0,s0    seq  wr   4 117.6 182.2 206.1 228.4 
i1,g0,s0    seq  wr   8  64.5  75.1  75.7  81.3  90.3 100.4 110.0 118.5 

i1,g0,s0    seq  rdwr 2 297.8 375.3 
i1,g0,s0    seq  rdwr 4 100.1 137.8 190.6 239.3 
i1,g0,s0    seq  rdwr 8  54.4  64.1  71.1  81.9  92.7  93.0 103.2 115.9 


