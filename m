Return-Path: <linux-kernel-owner+w=401wt.eu-S1758117AbXFSKaB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117AbXFSKaB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 06:30:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755739AbXFSK3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 06:29:54 -0400
Received: from smtp.nokia.com ([131.228.20.171]:33583 "EHLO
	mgw-ext12.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457AbXFSK3x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 06:29:53 -0400
Subject: Re: [PATCH/RFC] oops and panic message logging to MTD
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Richard Purdie <rpurdie@openedhand.com>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1182247254.5760.17.camel@localhost.localdomain>
References: <1182184301.6074.62.camel@localhost.localdomain>
	 <1182239749.4403.48.camel@sauron>
	 <1182247254.5760.17.camel@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Date: Tue, 19 Jun 2007 13:29:22 +0300
Message-Id: <1182248962.4403.60.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 19 Jun 2007 10:29:22.0696 (UTC) FILETIME=[B3D1E080:01C7B25C]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-19 at 11:00 +0100, Richard Purdie wrote:
> On Tue, 2007-06-19 at 10:55 +0300, Artem Bityutskiy wrote:
> > On Mon, 2007-06-18 at 17:31 +0100, Richard Purdie wrote:
> > > +	if (mtd->erasesize < OOPS_PAGE_SIZE)
> > > +		erase.len = OOPS_PAGE_SIZE;
> > 
> > It seems to me that your code won't work if mtd->erasesize <
> > OOPS_PAGE_SIZE anyway, so this check should not be here I guess.
> 
> Its just a sanity check...

Then do this once in the "add" notifier.

> > Well, mtd->block_isbad() may return error, unlikely, bu still. You also
> > ignore the error at other places.
> 
> Ignoring that is deliberate since it doesn't really matter if the block
> is bad or we can't read from it, the action is the same...

No, bad EB is a perfectly legal thing and you should deal with it. Error
code means that something very bad and sever is going on and you have to
just refuse working with this device.

> > Also, do not ignore error code of mtd->block_markbad()
> 
> All we can do is print a warning, the action will be the same...

No, the action should be returning an error and refuse doing more work.

> > Also, could you please use wait_event_interruptible() instead of
> > set_current_state() which looks better (indeed, you have wait queue, 
> > so use wq calls).
> 
> That piece of code is in keeping with the rest of the mtd erase handling
> code. Looking through the various wq macros, I don't see any which help
> particularly in this case...

Well, it is matter of taste so I do not insist. But I think
wait_event_interruptible() is much nicer. Glance at drivers/ubi/io.c how
it looks.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

