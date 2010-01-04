Return-Path: <linux-kernel-owner+w=401wt.eu-S1753640Ab0ADQvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab0ADQvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 11:51:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429Ab0ADQvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 11:51:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290Ab0ADQvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 11:51:14 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [PATCH] cfq-iosched: non-rot devices do not need read queue  merging
References: <20091230213439.GQ4489@kernel.dk>
	<1262211768-10858-1-git-send-email-czoccolo@gmail.com>
	<20100104144711.GA7968@redhat.com>
	<4e5e476b1001040836p2c8d7486x807a1a89b61c2458@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 04 Jan 2010 11:51:00 -0500
In-Reply-To: <4e5e476b1001040836p2c8d7486x807a1a89b61c2458@mail.gmail.com>
	(Corrado Zoccolo's message of "Mon, 4 Jan 2010 17:36:21 +0100")
Message-ID: <x49wrzxak5n.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Corrado Zoccolo <czoccolo@gmail.com> writes:

> Hi Vivkek,
>
> On Mon, Jan 4, 2010 at 3:47 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> On Wed, Dec 30, 2009 at 11:22:47PM +0100, Corrado Zoccolo wrote:
>>> Non rotational devices' performances are not affected by
>>> distance of read requests, so there is no point in having
>>> overhead to merge such queues.
>>> This doesn't apply to writes, so this patch changes the
>>> queued[] field, to be indexed by READ/WRITE instead of
>>> SYNC/ASYNC, and only compute proximity for queues with
>>> WRITE requests.
>>>
>>
>> Hi Corrado,
>>
>> What's the reason that reads don't benefit from merging queues and hence
>> merging requests and only writes do on SSD?
>
> On SSDs, reads are just limited by the maximum transfer rate, and
> larger (i.e. merged) reads will just take proportionally longer.

This is simply not true.  You can get more bandwidth from an SSD (I just
checked numbers for 2 vendors' devices) by issuing larger read requests,
no matter whether the access pattern is sequential or random.

Cheers,
Jeff
