Return-Path: <linux-kernel-owner+w=401wt.eu-S1753506Ab0AKM03@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab0AKM03 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 07:26:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753417Ab0AKM0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 07:26:25 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:51010 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378Ab0AKM0Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 07:26:24 -0500
MIME-Version: 1.0
In-Reply-To: <4B4B0AA9.5020900@garzik.org>
References: <1262211768-10858-1-git-send-email-czoccolo@gmail.com>
	 <1263157461-12294-1-git-send-email-czoccolo@gmail.com>
	 <4B4B0AA9.5020900@garzik.org>
Date: Mon, 11 Jan 2010 13:26:22 +0100
Message-ID: <4e5e476b1001110426t2afa0502p7f19a9b24e48ba82@mail.gmail.com>
Subject: Re: [PATCH] cfq-iosched: NCQ SSDs do not need read queue merging
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jeff Moyer <jmoyer@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
       Shaohua Li <shaohua.li@intel.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 11, 2010 at 12:25 PM, Jeff Garzik <jeff@garzik.org> wrote:
> On 01/10/2010 04:04 PM, Corrado Zoccolo wrote:
>>
>> NCQ SSDs' performances are not affected by
>> distance of read requests, so there is no point in having
>> overhead to merge such queues.
>>
>> Non-NCQ SSDs showed regression in some special cases, so
>> they are ruled out by this patch.
>>
>> This patch intentionally doesn't affect writes, so
>> it changes the queued[] field, to be indexed by
>> READ/WRITE instead of SYNC/ASYNC, and only compute proximity
>> for queues with WRITE requests.
>>
>> Signed-off-by: Corrado Zoccolo<czoccolo@gmail.com>
>
> That's not really true.  Overhead always increases as the total number of
> ATA commands issued increases.

Jeff Moyer tested the patch on the workload that mostly benefit of
queue merging, and found that
the performance was improved by the patch.
So removing the CPU overhead helps much more than the marginal gain
given by merging on this hardware.

Corrado

>
>        Jeff
>
>
>
>
>
