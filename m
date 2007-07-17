Return-Path: <linux-kernel-owner+w=401wt.eu-S933970AbXGQRue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933970AbXGQRue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 13:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756701AbXGQRu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 13:50:27 -0400
Received: from stinky.trash.net ([213.144.137.162]:49741 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349AbXGQRu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 13:50:27 -0400
Message-ID: <469D0159.1010506@trash.net>
Date: Tue, 17 Jul 2007 19:50:17 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Debian Thunderbird 1.0.7 (X11/20051019)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
CC: Alasdair G Kergon <agk@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6.23 PATCH 07/18] dm io: fix panic on large request
References: <20070711205846.GY24114@agk.fab.redhat.com> <469CC11B.2020103@trash.net> <469CF0CD.6060006@ce.jp.nec.com>
In-Reply-To: <469CF0CD.6060006@ce.jp.nec.com>
X-Enigmail-Version: 0.93.0.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jun'ichi Nomura wrote:
>>>From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
>>>
>>>bio_alloc_bioset() will return NULL if 'num_vecs' is too large.
>>>Use bio_get_nr_vecs() to get estimation of maximum number.
>>>
>>>Signed-off-by: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
>>>Signed-off-by: Alasdair G Kergon <agk@redhat.com>
>>>
>>
>>This patch reproducibly oopses my box:
> 
> 
> Thanks for the report.
> But I'm not sure how the patch is related to the oops.
> 
> The stack trace shows the oops occurred in dm-crypt,
> which doesn't use the part of the code modified by the patch
> (dm-io).


I tried reverting the individual patches until it stopped oopsing,
it may have been by luck. I'll try if I can break it again by
reverting the revert.

> Are you using other dm modules such as dm-multipath, dm-mirror
> or dm-snapshot?
> If so, can you take the output of 'dmsetup table' and 'dmsetup ls'?


No other modules.

> Do you have a reliable way to reproduce the oops which I can try?


"/etc/init.d/cryptdisk start" (debian) on a luks partition triggered
it for me.

