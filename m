Return-Path: <linux-kernel-owner+w=401wt.eu-S1754793AbZFYKJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbZFYKJs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 06:09:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754764AbZFYKJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 06:09:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44283
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754319AbZFYKJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 06:09:34 -0400
Date: Thu, 25 Jun 2009 03:09:38 -0700 (PDT)
Message-Id: <20090625.030938.248206050.davem@davemloft.net>
To: petkovbb@googlemail.com
Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, htejun@gmail.com
Subject: Re: [patch 2/6] ide: fix ide_kill_rq() for special
 ide-{floppy,tape} driver requests
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090624174411.GA5729@liondog.tnic>
References: <200906241209.53891.bzolnier@gmail.com>
	<20090624.033909.147195176.davem@davemloft.net>
	<20090624174411.GA5729@liondog.tnic>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <petkovbb@googlemail.com>
Date: Wed, 24 Jun 2009 19:44:11 +0200

> On Wed, Jun 24, 2009 at 03:39:09AM -0700, David Miller wrote:
>> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>> Date: Wed, 24 Jun 2009 12:09:53 +0200
>> 
>> > The obscure reasons is just the fact that both ide-floppy and ide-tape
>> > had a they own duplicated/buggy request completion routines.
>> > 
>> > While they were being unified the whole bunch of similar class of bugs
>> > were fixed so I agree that there may still be more issues to deal with
>> > there.
>> 
>> I see, the ->pc_callback() of these things set rq->errors and then
>> ide_pc_intr() happily overrides whatever was set there, either on it's
>> own or via ide_complete_rq().
>> 
>> I'll look over this some more while I wait for the testing results
>> from Borislav.
> 
> Ok, let's see now, I did some testing but can't seem to hit that
> particular path because it is taken relatively rarely - it can be
> reached from start_request() and ide_atapi_error() via ide_error for
> ide-floppy and ide-tape.
> 
> If my code staring doesn't mislead me, the start_request()-one has to
> happen during an IDE reset operation, while we're polling for reset
> completion _and_ when drive->failures has reached drive->max_failures
> since this is the only site the drive->failures counter is increased.
> 
> The ide_atapi_error() cannot happen because (!blk_fs_request(rq))
> requests are being completed in ide_error() with the respective error
> status.
> 
> It is possible that I've missed something so feel free to correct me
> and/or suggest a different testing approach.

Ok, thanks Borislav.

My intention is to apply patches #2 and #3, thanks everyone!
