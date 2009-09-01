Return-Path: <linux-kernel-owner+w=401wt.eu-S1755205AbZIAUb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbZIAUb6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 16:31:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755181AbZIAUb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 16:31:57 -0400
Received: from ppp-145-226.adsl.restena.lu ([158.64.145.226]:44734 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754943AbZIAUb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 16:31:56 -0400
Date: Tue, 1 Sep 2009 22:31:28 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Ed Cashin <ecashin@coraid.com>
Cc: apw@canonical.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] aoe: ensure we initialise the request_queue
 correctly
Message-ID: <20090901223128.4bf1bf53@neptune.home>
In-Reply-To: <6309cc7d77486e24aca5130ec5802dfb@coraid.com>
References: <1250872904-10993-1-git-send-email-apw@canonical.com>
	<9ab0e087296715d764071d4d39542985@coraid.com>
	<20090829154305.723fd86c@neptune.home>
	<6309cc7d77486e24aca5130ec5802dfb@coraid.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 September 2009 Ed Cashin <ecashin@coraid.com> wrote:

> On Sat Aug 29 09:43:54 EDT 2009, bonbons@linux-vserver.org wrote:
> ...
> > I finished bisecting the NULL object and ended up at this commit:
> >   cd43e26f071524647e660706b784ebcbefbd2e44
> > 
> >   block: Expose stacked device queues in sysfs
> > 
> >   Currently stacking devices do not have a queue directory in sysfs.
> >   However, many of the I/O characteristics like sector size, maximum
> >   request size, etc. are queue properties.
> > 
> >   This patch enables the queue directory for MD/DM devices.  The
> > elevator code has been modified to deal with queues that do not
> > have an I/O scheduler.
> > 
> >   Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> >   Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> > 
> > 
> > This seems to generate /sys/block/$device/queue and its contents for
> > everyone who is using queues, not just for those queues that have a
> > non-NULL queue->request_fn.
> 
> Thanks much for doing that.  It makes sense that this change would
> have caused it to suddenly matter whether the unused queue is
> initialized.
> 
> The patch looks fine to me.

Would it make sense to fine-tune the values reported by sys-fs in the
queue details so they match with the AoE device (as a separate
enhancement patch)?

Sure the queue itself won't use them, but some user-space tools might
be interested in this data.

I've not checked what information is provided by AoE protocol or can
be deducted from interface MTU.

Bruno
