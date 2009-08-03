Return-Path: <linux-kernel-owner+w=401wt.eu-S1754602AbZHCJPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbZHCJPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 05:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754492AbZHCJPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 05:15:33 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:58006 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459AbZHCJPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 05:15:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VQMW0Q3ORTzZxdcgyLQEVgfFR9LhwAbrX94onNjZJDF1v5VszysbgJeANVUSaSUNZv
         BhC4cKd+qIQ6MlNyLsmP1EelsUi2iYdi4TEg6gtYFauBNPe/aanhUYTAZXocigyaG++n
         rjZGODhRGTHAZhXZW1iqZ+EliN+9GGcZAufFo=
MIME-Version: 1.0
In-Reply-To: <4A7338AF.8010407@vlnb.net>
References: <4A3CD62B.1020407@vlnb.net>
	 <a0272b440907170715q72af7bb8l53c9dbd5e553fe2c@mail.gmail.com>
	 <4A60C1A8.9020504@vlnb.net> <4A641AAC.9030300@vlnb.net>
	 <a0272b440907220144i159baca4u1a1f1f2d0c36193a@mail.gmail.com>
	 <4A6DA77B.7080600@vlnb.net>
	 <a0272b440907280251g2dd38df6ja1bf10f3fa38d333@mail.gmail.com>
	 <4A6F4C81.10600@vlnb.net>
	 <a0272b440907290548k266a975br8c6bdf4d5d992d20@mail.gmail.com>
	 <4A7338AF.8010407@vlnb.net>
Date: Mon, 3 Aug 2009 11:15:32 +0200
Message-ID: <a0272b440908030215t66309c1fo9a0894bdae4dec17@mail.gmail.com>
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

2009/7/31 Vladislav Bolkhovitin <vst@vlnb.net>:
>
> OK, as I expected, on the SCST level everything is clear and the forced
> ordering change didn't change anything.
>
> But still, a single read stream must be the fastest from single thread.
> Otherwise, there's something wrong somewhere in the I/O path: block layer,
> RA, I/O scheduler. And, apparently, this is what we have and should find out
> the cause.
>
> Can you check if noop on the target and/or initiator makes any difference?
> Case 5 with 1 and 2 threads will be sufficient.

That doesn't seem to help:

client kernel: 2.6.26-15lenny3 (debian)
server kernel: 2.6.29.5 with readahead-context, blk_run_backing_dev
and io_context, forced_order

With one IO thread:
5) client: default, server: default (server noop, client noop)
blocksize       R        R        R   R(avg,    R(std        R
  (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
 67108864  17.612   21.113   21.355   51.532    4.680    0.805
 33554432  18.329   18.523   19.049   54.969    0.891    1.718
 16777216  18.497   18.219   17.042   57.217    2.059    3.576

With two threads:
5) client: default, server: default (server noop, client noop)
blocksize       R        R        R   R(avg,    R(std        R
  (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
 67108864  17.436   18.376   20.493   54.807    3.634    0.856
 33554432  17.466   16.980   18.261   58.337    1.740    1.823
 16777216  18.222   17.567   18.077   57.045    0.901    3.565

Ronald.
