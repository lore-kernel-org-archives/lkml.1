Return-Path: <linux-kernel-owner+w=401wt.eu-S1758198AbXKGWG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198AbXKGWG6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 17:06:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755150AbXKGWGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 17:06:50 -0500
Received: from pne-smtpout2-sn1.fre.skanova.net ([81.228.11.159]:58402 "EHLO
	pne-smtpout2-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755065AbXKGWGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 17:06:49 -0500
Date: Wed, 7 Nov 2007 23:06:47 +0100 (CET)
From: Peter Osterlund <petero2@telia.com>
X-X-Sender: petero@quad.localdomain
To: Tejun Heo <htejun@gmail.com>
cc: Thomas Maier <balagi@justmail.de>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, gregkh@suse.de
Subject: Re: pktcdvd oops
In-Reply-To: <4731269B.6010509@gmail.com>
Message-ID: <Pine.LNX.4.64.0711072303080.6991@quad.localdomain>
References: <20071105092018.GD5359@kernel.dk> <Pine.LNX.4.64.0711052312410.5445@quad.localdomain>
 <47302E9F.6020708@gmail.com> <op.t1d2aurziudtyh@master>
 <Pine.LNX.4.64.0711062229490.5800@quad.localdomain> <4731269B.6010509@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Nov 2007, Tejun Heo wrote:

> Peter Osterlund wrote:
>> If the
>> __module_get() is not safe because the module code could have already
>> been unloaded, how can it possibly be made safe by adding more code to
>> the pktcdvd module? If the module is unloaded, trying to execute its
>> code can't be a good thing no matter what the code does.
>
> sysfs itself is now out of module lifespan rules.  sysfs callbacks are
> guaranteed to stay in memory while running by sysfs node removal waiting
> for completion of in-flight operations before returning.  In pktcdvd's
> case, class_destroy() call in pkt_sysfs_cleanup() will wait for all
> in-flight sysfs r/w ops to complete.
>
> So, even while sysfs callbacks are executing, the module beneath can die
> but it will stay in memory till all the callbacks return.  You need to
> test module liveness using try_module_get() (and it can fail) if you
> want to grab module reference from sysfs callbacks.

Thanks for the explanation.

Given that explanation, I think the patch is correct and it does fix the 
BUG on my computer. Can you please push it upstream?

In any case:

Acked-by: Peter Osterlund <petero2@telia.com>

-- 
Peter Osterlund - petero2@telia.com
http://web.telia.com/~u89404340
