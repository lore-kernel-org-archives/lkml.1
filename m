Return-Path: <linux-kernel-owner+w=401wt.eu-S1754991Ab0ARDEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab0ARDEU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 22:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492Ab0ARDES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 22:04:18 -0500
Received: from mga10.intel.com ([192.55.52.92]:64193 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932091Ab0ARDER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 22:04:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,292,1262592000"; 
   d="scan'208";a="765019904"
Subject: Re: fio mmap randread 64k more than 40% regression with 2.6.33-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: "jmoyer@redhat.com" <jmoyer@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Shaohua Li <shaohua.li@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4e5e476b1001160827n6dc73b35vee8b46e541134c2@mail.gmail.com>
References: <1262250960.1819.68.camel@localhost>
	 <4e5e476b0912310234mf9ccaadm771c637a3d107d18@mail.gmail.com>
	 <1262340730.19773.47.camel@localhost>
	 <4e5e476b1001010832o24f6a0efudbfc36598bfc7c5e@mail.gmail.com>
	 <1262435612.19773.80.camel@localhost>
	 <4e5e476b1001021052u51a90a91qb2fbb4089498a3ca@mail.gmail.com>
	 <1262593090.29897.14.camel@localhost>
	 <4e5e476b1001041028v1f204834r1fa97e732a094210@mail.gmail.com>
	 <4e5e476b1001160827n6dc73b35vee8b46e541134c2@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Mon, 18 Jan 2010 11:06:38 +0800
Message-Id: <1263783999.12893.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-01-16 at 17:27 +0100, Corrado Zoccolo wrote:
> Hi Yanmin
> On Mon, Jan 4, 2010 at 7:28 PM, Corrado Zoccolo <czoccolo@gmail.com> wrote:
> > Hi Yanmin,
> >> When low_latency=1, we get the biggest number with kernel 2.6.32.
> >> Comparing with low_latency=0's result, the prior one is about 4% better.
> > Ok, so 2.6.33 + corrado (with low_latency =0) is comparable with
> > fastest 2.6.32, so we can consider the first part of the problem
> > solved.
> >
> I think we can return now to your full script with queue merging.
> I'm wondering if (in arm_slice_timer):
> -       if (cfqq->dispatched)
> +      if (cfqq->dispatched || (cfqq->new_cfqq && rq_in_driver(cfqd)))
>                return;
> gives the same improvement you were experiencing just reverting to rq_in_driver.
I did a quick testing against 2.6.33-rc1. With the new method, fio mmap randread 46k
has about 20% improvement. With just checking rq_in_driver(cfqd), it has
about 33% improvement.


> 
> We saw that cfqq->dispatched worked fine when there was no queue
> merging happening, so it must be something concerning merging,
> probably dispatched is not accurate when we set up for a merging, but
> the merging was not yet done.


