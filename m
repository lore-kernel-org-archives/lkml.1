Return-Path: <linux-kernel-owner+w=401wt.eu-S1759927AbZFWXEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759927AbZFWXEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 19:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755723AbZFWXEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 19:04:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57856
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755247AbZFWXEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 19:04:35 -0400
Date: Tue, 23 Jun 2009 16:04:40 -0700 (PDT)
Message-Id: <20090623.160440.243068553.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: elendil@planet.nl, sparclinux@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: cmd64x: irq 14: nobody cared - system is dreadfully slow
From: David Miller <davem@davemloft.net>
In-Reply-To: <200906231813.09570.bzolnier@gmail.com>
References: <20090623.031506.214747802.davem@davemloft.net>
	<200906231658.56489.elendil@planet.nl>
	<200906231813.09570.bzolnier@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Tue, 23 Jun 2009 18:13:08 +0200

> On Tuesday 23 June 2009 16:58:54 Frans Pop wrote:
>> So it seems to me that in 2.6.26 something was broken in the way these ID 
>> fields were handled, at least in this check. This is now fixed (possibly 
> 
> Great debugging work, thanks!

Indeed, thanks for all of that work Frans!

>> by the changes around 5b90e990..48fb2688) and *that* causes the 
>> regression. Note that the hard disks are also affected.
> 
> I see it now -- in commit c419993 ("ide-iops: only clear DMA words
> on setting DMA mode") we fixed a bug in ide_config_drive_speed()..
> 
> [ It was a real bug resulting in incorrect data being passed to
>   the user-space through HDIO_GET_IDENTITY ioctl ('hdparm -i'). ]

Given all of this I also agree that we should apply Bart's patch to
remove the debugging check altogether, and I will thus do that right
now.
