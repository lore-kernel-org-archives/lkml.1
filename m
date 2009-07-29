Return-Path: <linux-kernel-owner+w=401wt.eu-S1754750AbZG2MsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbZG2MsN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 08:48:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbZG2MsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 08:48:12 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:11514 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754668AbZG2MsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 08:48:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JNah+d6Zeu2NkExDXHIMAegfN8zROl4Gl5itJn01tnpAjnVO26L0aVfs7LEwDVGSuD
         KXXiEXXZ0XXonEp+iVlEYJonYI6Use4OQQTWlcD5GLzx54gTShguNxOIEF7NKTjvr3y5
         xLJJupyROUvAb8DPbjQE+IQM0emryQ8s0xLiE=
MIME-Version: 1.0
In-Reply-To: <4A6F4C81.10600@vlnb.net>
References: <4A3CD62B.1020407@vlnb.net>
	 <a0272b440907160032u482bd483s54540001aef7ac73@mail.gmail.com>
	 <4A5F0293.3010206@vlnb.net>
	 <a0272b440907170715q72af7bb8l53c9dbd5e553fe2c@mail.gmail.com>
	 <4A60C1A8.9020504@vlnb.net> <4A641AAC.9030300@vlnb.net>
	 <a0272b440907220144i159baca4u1a1f1f2d0c36193a@mail.gmail.com>
	 <4A6DA77B.7080600@vlnb.net>
	 <a0272b440907280251g2dd38df6ja1bf10f3fa38d333@mail.gmail.com>
	 <4A6F4C81.10600@vlnb.net>
Date: Wed, 29 Jul 2009 14:48:09 +0200
Message-ID: <a0272b440907290548k266a975br8c6bdf4d5d992d20@mail.gmail.com>
Subject: Re: [RESEND] [PATCH] readahead:add blk_run_backing_dev
From: Ronald Moesbergen <intercommit@gmail.com>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: fengguang.wu@intel.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
       Alan.Brunelle@hp.com, linux-fsdevel@vger.kernel.org,
       jens.axboe@oracle.com, randy.dunlap@oracle.com,
       Bart Van Assche <bart.vanassche@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/28 Vladislav Bolkhovitin <vst@vlnb.net>:
>
> Can you perform the tests 5 and 8 the deadline? I asked for deadline..
>
> What I/O scheduler do you use on the initiator? Can you check if changing it
> to deadline or noop makes any difference?
>

client kernel: 2.6.26-15lenny3 (debian)
server kernel: 2.6.29.5 with readahead-context, blk_run_backing_dev
and io_context, forced_order

With one IO thread:
5) client: default, server: default (server deadline, client cfq)
blocksize       R        R        R   R(avg,    R(std        R
  (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
 67108864  15.739   15.339   16.511   64.613    1.959    1.010
 33554432  15.411   12.384   15.400   71.876    7.646    2.246
 16777216  16.564   15.569   16.279   63.498    1.667    3.969

5) client: default, server: default (server deadline, client deadline)
blocksize       R        R        R   R(avg,    R(std        R
  (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
 67108864  17.578   20.051   18.010   55.395    3.111    0.866
 33554432  19.247   12.607   17.930   63.846   12.390    1.995
 16777216  14.587   19.631   18.032   59.718    7.650    3.732

8) client: default, server: 64 max_sectors_kb, RA 2MB (server
deadline, client deadline)
blocksize       R        R        R   R(avg,    R(std        R
  (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
 67108864  17.418   19.520   22.050   52.564    5.043    0.821
 33554432  21.263   17.623   17.782   54.616    4.571    1.707
 16777216  17.896   18.335   19.407   55.278    1.864    3.455

8) client: default, server: 64 max_sectors_kb, RA 2MB (server
deadline, client cfq)
blocksize       R        R        R   R(avg,    R(std        R
  (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
 67108864  16.639   15.216   16.035   64.233    2.365    1.004
 33554432  15.750   16.511   16.092   63.557    1.224    1.986
 16777216  16.390   15.866   15.331   64.604    1.763    4.038

11) client: 2MB RA, 64 max_sectors_kb, server: 64 max_sectors_kb, RA
2MB (server deadline, client deadline)
blocksize       R        R        R   R(avg,    R(std        R
  (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
 67108864  14.117   13.610   13.558   74.435    1.347    1.163
 33554432  13.450   10.344   13.556   83.555   10.918    2.611
 16777216  13.408   13.319   13.239   76.867    0.398    4.804

With two threads:
5) client: default, server: default (server deadline, client cfq)
blocksize       R        R        R   R(avg,    R(std        R
  (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
 67108864  15.723   16.535   16.189   63.438    1.312    0.991
 33554432  16.152   16.363   15.782   63.621    0.954    1.988
 16777216  15.174   16.084   16.682   64.178    2.516    4.011

5) client: default, server: default (server deadline, client deadline)
blocksize       R        R        R   R(avg,    R(std        R
  (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
 67108864  18.087   18.082   17.639   57.099    0.674    0.892
 33554432  18.377   15.750   17.551   59.694    3.912    1.865
 16777216  18.490   15.553   18.778   58.585    5.143    3.662

8) client: default, server: 64 max_sectors_kb, RA 2MB (server
deadline, client deadline)
blocksize       R        R        R   R(avg,    R(std        R
  (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
 67108864  18.140   19.114   17.442   56.244    2.103    0.879
 33554432  17.183   17.233   21.367   55.646    5.461    1.739
 16777216  19.813   17.965   18.132   55.053    2.393    3.441

8) client: default, server: 64 max_sectors_kb, RA 2MB (server
deadline, client cfq)
blocksize       R        R        R   R(avg,    R(std        R
  (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
 67108864  15.753   16.085   16.522   63.548    1.239    0.993
 33554432  13.502   15.912   15.507   68.743    5.065    2.148
 16777216  16.584   16.171   15.959   63.077    1.003    3.942

11) client: 2MB RA, 64 max_sectors_kb, server: 64 max_sectors_kb, RA
2MB (server deadline, client deadline)
blocksize       R        R        R   R(avg,    R(std        R
  (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
 67108864  14.051   13.427   13.498   75.001    1.510    1.172
 33554432  13.397   14.008   13.453   75.217    1.503    2.351
 16777216  13.277    9.942   14.318   83.882   13.712    5.243


Ronald.
