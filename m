Return-Path: <linux-kernel-owner+w=401wt.eu-S1756825AbYJIIg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825AbYJIIg0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 04:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbYJIIgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 04:36:16 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:11105 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152AbYJIIgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 04:36:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=s691nd9uetMJI3SNd+N/uhUyDv9mRml9rVeqV0iYW0J0L9273ld/nSP1mBj8igVCCK
         GT+jPvY8e+jWqOPQp7chQNrQ/9IRmY7SprX17qMZQez9y5FNp/WalEwt1/EUUY2DkK1I
         l6WSG9fTUZvNg4dUFZeKbf/bli2hyzFjp/vyQ=
Message-ID: <58cb370e0810090136t327734cerf6eb933422b9791c@mail.gmail.com>
Date: Thu, 9 Oct 2008 10:36:14 +0200
From: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
To: "Jens Axboe" <jens.axboe@oracle.com>
Subject: Re: [PATCH 0/7] ide: locking improvements
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20081009065141.GV19428@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081008202930.19112.90371.sendpatchset@localhost.localdomain>
	 <20081009065141.GV19428@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 9, 2008 at 8:51 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Wed, Oct 08 2008, Bartlomiej Zolnierkiewicz wrote:
>>
>> Locking improvements in preparation for replacing the global ide_lock
>> spinlock by per-hwgroup spinlocks [1].
>>
>> [1] patch (which is partially based on 2005 patch from Scalex86) for this
>> is also ready but it needs some more audit and testing
>>
>> diffstat:
>>  drivers/ide/ide-cd.c     |   38 ++++++-------
>>  drivers/ide/ide-io.c     |  129 ++++++++++++++++++++---------------------------
>>  drivers/ide/ide-ioctls.c |    3 -
>>  drivers/ide/ide-lib.c    |    7 --
>>  drivers/ide/ide-proc.c   |   25 +--------
>>  drivers/ide/ide.c        |    7 --
>>  6 files changed, 80 insertions(+), 129 deletions(-)
>
> Sorry, but I just have to ask 'why'? IDE is seeing a whole lot of churn
> for something that should essentially be a stable code base in
> maintenance mode, and now scalability improvements?

It is the stable code but being in "maintenance only mode" has never
been true and as long as there are active users & developers there is
really no reason to change it.

> Just doesn't make ANY sense to me, sorry. We may end up with a cleaner
> code base, but likely also a buggier one. It's not like hardware
> coverage testing is all that great, considering some of the ancient
> stuff it supports :-)

The changes above are relatively safe/simple and are not hardware specific.

Thanks for worring about IDE but we should be fine. :)

Bart
