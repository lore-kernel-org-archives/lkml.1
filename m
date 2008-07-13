Return-Path: <linux-kernel-owner+w=401wt.eu-S1754307AbYGMNvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307AbYGMNvS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 09:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753277AbYGMNvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 09:51:05 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42458 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbYGMNvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 09:51:04 -0400
Message-ID: <487A083F.9010301@firstfloor.org>
Date: Sun, 13 Jul 2008 15:50:55 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Mikulas Patocka <mpatocka@redhat.com>
CC: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [SUGGESTION]: drop virtual merge accounting in I/O requests
References: <Pine.LNX.4.64.0807101702090.19775@engineering.redhat.com> <87iqvb2skz.fsf@basil.nowhere.org> <Pine.LNX.4.64.0807130933120.24489@devserv.devel.redhat.com>
In-Reply-To: <Pine.LNX.4.64.0807130933120.24489@devserv.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikulas Patocka wrote:
>> Mikulas Patocka <mpatocka@redhat.com> writes:
>>
>>> I'm getting crashes with InitIO A100u2w controller on Sparc64 (I had
>>> to fix the endianity issues in the driver, but that's unrelated).
>>
>> x86-64 (and powerpc) solved this a long time ago by only doing
>> opportunistic merging: as in don't announce to the block layer
>> that you can merge, but try to merge anyways. This way SG lists
>> are not necessarily filled completely, but it's still better
>> than overflowing them in some rare cases.
>>
>> -Andi
> 
> There's option "biomerge" that enables that feature. I'm wondering, if
> there's some situation when it should be used.

It would only help if your SG hardware is slower at processing merges
than the IOMMU.

We found some long ago that was (old MPT Fusion) that gained
a few percent on some benchmarks, but that might be quite different
depending on the particular IO controller and chipset.

Also biomerge was used for the AMD K8 GART "IOMMU" which is
relatively slow, the situation on more modern x86 IOMMUs might be
different. Also the GART IOMMU is small and fragmentation is more
likely.

The situation on the more modern real x86 IOMMU (like in newer Intel or IBM
chipsets) might be also different.

Still I would expect that modern IO controllers are typically fast
enough at processing SG lists that it shouldn't matter much.

-Andi
