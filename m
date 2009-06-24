Return-Path: <linux-kernel-owner+w=401wt.eu-S1756487AbZFXGty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487AbZFXGty (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 02:49:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754330AbZFXGto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 02:49:44 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54486
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753147AbZFXGtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 02:49:43 -0400
Date: Tue, 23 Jun 2009 23:49:48 -0700 (PDT)
Message-Id: <20090623.234948.121450964.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       petkovbb@gmail.com, htejun@gmail.com
Subject: Re: [patch 3/6] ide: always kill the whole request on error
From: David Miller <davem@davemloft.net>
In-Reply-To: <200906240249.33505.bzolnier@gmail.com>
References: <200906232327.27610.bzolnier@gmail.com>
	<20090623.161904.177489795.davem@davemloft.net>
	<200906240249.33505.bzolnier@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Wed, 24 Jun 2009 02:49:32 +0200

> On Wednesday 24 June 2009 01:19:04 David Miller wrote:
>> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>> Date: Tue, 23 Jun 2009 23:27:27 +0200
>> 
>> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>> > Subject: [PATCH] ide: always kill the whole request on error
>> > 
>> > * Use blk_rq_bytes() instead of obsolete ide_rq_bytes() in ide_kill_rq()
>> >   and ide_floppy_do_request() for failed requests.
>> >   [ bugfix part ]
>> > 
>> > * Use blk_rq_bytes() instead of obsolete ide_rq_bytes() in ide_do_devset()
>> >   and ide_complete_drive_reset().  Then remove ide_rq_bytes().
>> >   [ cleanup part ]
>> > 
>> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>> > ---
>> > 'cleanup part' tested, limited testing with 'bugfix part'
>> > (using simulated failures of disk fs requests)
>> 
>> Considering this alongsize patch #2, it even more begs the
>> question as to why special requests on floppy and tape were
>> handled differently.  And that 'error <= 0' test, strange.
> 
> TBH I fail to see how it relates to changes present in _this_ patch
> as no change in _this_ patch affects special tape/floppy requests..

The previous patch is a prerequesite for this one.  So we should
discuss them as a whole.  Because if we can't remove the "ide/floppy
RQ error 0 instead of -EIO" bit, then we don't make these further
consolidations either.
