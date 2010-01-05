Return-Path: <linux-kernel-owner+w=401wt.eu-S1755444Ab0AEVTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab0AEVTY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 16:19:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755323Ab0AEVTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 16:19:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50763 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755318Ab0AEVTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 16:19:21 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>, Corrado Zoccolo <czoccolo@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH] cfq-iosched: non-rot devices do not need read queue merging
References: <20091230213439.GQ4489@kernel.dk>
	<1262211768-10858-1-git-send-email-czoccolo@gmail.com>
	<20100104144711.GA7968@redhat.com>
	<4e5e476b1001040836p2c8d7486x807a1a89b61c2458@mail.gmail.com>
	<x49wrzxak5n.fsf@segfault.boston.devel.redhat.com>
	<4e5e476b1001041037x6aa63be6ncfa523a7df78bb0d@mail.gmail.com>
	<20100104185100.GF7968@redhat.com>
	<x49fx6ladzk.fsf@segfault.boston.devel.redhat.com>
	<4e5e476b1001041237v71952c8ewaaef3778353f7521@mail.gmail.com>
	<x49zl4s8uoj.fsf@segfault.boston.devel.redhat.com>
	<20100105151353.GA4631@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 05 Jan 2010 16:19:08 -0500
In-Reply-To: <20100105151353.GA4631@redhat.com> (Vivek Goyal's message of
	"Tue, 5 Jan 2010 10:13:53 -0500")
Message-ID: <x49y6kc6yib.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> Thanks Jeff, one thing comes to mind. Now with recent changes, we drive deeper
> depths on SSD with NCQ and there are not many pending cfqq on service tree
> until and unless number of parallel threads exceed NCQ depth (32). If
> that's the case, then I think we might not be seeing lot of queue merging
> happening in this test case until and unless dump utility is creating more
> than 32 threads.
>
> If time permits, it might also be interesting to run the same test with queue
> depth 1 and see if SSDs without NCQ will suffer or not.

Corrado, I think what Vivek is getting at is that you should check for
both blk_queue_nonrot and cfqd->hw_tag (like in cfq_arm_slice_timer).
Do you agree?

Cheers,
Jeff
