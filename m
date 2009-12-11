Return-Path: <linux-kernel-owner+w=401wt.eu-S1758560AbZLKRus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758560AbZLKRus (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 12:50:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753632AbZLKRum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 12:50:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753053AbZLKRul convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 12:50:41 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] cfq-iosched: reduce write depth only if sync was delayed
References: <4b1a3d84.0d0db80a.39d0.ffff814a@mx.google.com>
	<4e5e476b0912050313k280caa8bjf7c2cf1c5d19c88c@mail.gmail.com>
	<4e5e476b0912060245x4d64300hb9689243bd712f2c@mail.gmail.com>
	<x49ein6nx9k.fsf@segfault.boston.devel.redhat.com>
	<4e5e476b0912081243ra071947if9a3edae77fb3861@mail.gmail.com>
	<x49ocm8nhn6.fsf@segfault.boston.devel.redhat.com>
	<4e5e476b0912110915u209b8923m359d9147cc229fea@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 11 Dec 2009 12:50:42 -0500
In-Reply-To: <4e5e476b0912110915u209b8923m359d9147cc229fea@mail.gmail.com>
	(Corrado Zoccolo's message of "Fri, 11 Dec 2009 18:15:20 +0100")
Message-ID: <x49y6l9csct.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrado Zoccolo <czoccolo@gmail.com> writes:

> Hi Jeff,
> On Wed, Dec 9, 2009 at 7:09 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
>> Corrado Zoccolo <czoccolo@gmail.com> writes:
>>
>>> The numbers look good. Now, there is no penalty in having low_latency
>>> set for sequential writes, and just a small penalty for random ones.
>>> The fact that random reads are faster with low_latency set is interesting.
>>> Is the test is running with your patched tiobench (so that the number
>>> of random operations is comparable with sequential ones)?
>>
>> No, I forgot all about that.  The number of random operations defaults
>> to 4000, which is pretty low.  I'll re-run the tests with a number
>> comparable to the sequential runs.  Sorry about that.
>>
> N.P.

low_latency=1

Random Reads
                              File  Blk   Num                   Avg      Maximum      Lat%     Lat%    CPU
Identifier                    Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s    Eff
---------------------------- ------ ----- ---  ------ ------ --------- -----------  -------- -------- -----
2.6.32                        8192  65536   8   19.35 26.10%    74.639     3278.74   0.00000  0.00000    74
2.6.32                        8192  65536  16   20.40 53.07%   135.695     3705.55   0.00000  0.00000    38

Random Writes
                              File  Blk   Num                   Avg      Maximum      Lat%     Lat%    CPU
Identifier                    Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s    Eff
---------------------------- ------ ----- ---  ------ ------ --------- -----------  -------- -------- -----
2.6.32                        8192  65536   8   64.64 342.2%    22.708     5960.22   0.00153  0.00000    19
2.6.32                        8192  65536  16   61.19 663.7%    47.648    11294.56   0.16098  0.00000     9


low_latency=0

Random Reads
                              File  Blk   Num                   Avg      Maximum      Lat%     Lat%    CPU
Identifier                    Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s    Eff
---------------------------- ------ ----- ---  ------ ------ --------- -----------  -------- -------- -----
2.6.32                        8192  65536   8   19.71 25.32%    70.891     4340.92   0.00000  0.00000    78
2.6.32                        8192  65536  16   22.67 58.94%   121.669     6180.49   0.00229  0.00000    38

Random Writes
                              File  Blk   Num                   Avg      Maximum      Lat%     Lat%    CPU
Identifier                    Size  Size  Thr   Rate  (CPU%)  Latency    Latency      >2s      >10s    Eff
---------------------------- ------ ----- ---  ------ ------ --------- -----------  -------- -------- -----
2.6.32                        8192  65536   8   64.69 339.5%    22.651     6770.99   0.00152  0.00000    19
2.6.32                        8192  65536  16   61.94 663.0%    46.962    10719.13   0.12741  0.00000     9


> if you have time, can you also re-run the test changing:
> iosched/fifo_expire_async to 8 ?

Sure.

Cheers,
Jeff
