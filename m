Return-Path: <linux-kernel-owner+w=401wt.eu-S1759971AbXISSIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759971AbXISSIB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 14:08:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754584AbXISSHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 14:07:51 -0400
Received: from mail.fieldses.org ([66.93.2.214]:41871 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753540AbXISSHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 14:07:50 -0400
Date: Wed, 19 Sep 2007 14:07:49 -0400
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@openvz.org
Subject: Re: [PATCH] Wake up mandatory locks waiter on chmod
Message-ID: <20070919180749.GD5946@fieldses.org>
References: <46E94993.3090506@openvz.org> <20070916194135.GC31801@fieldses.org> <46EE20C4.1060405@openvz.org> <20070917145934.GA4957@fieldses.org> <46EF71F0.9010606@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46EF71F0.9010606@openvz.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2007 at 10:36:32AM +0400, Pavel Emelyanov wrote:
> J. Bruce Fields wrote:
> > I would also prefer a locking scheme that didn't rely on the BKL.  That
> > said, except for this race:
> 
> I would as well :) But I don't know the locking code good enough to
> start fixing. Besides, even if I send a patch series that handles this,
> I don't think that anyone will accept it, due to "this changes too much
> code", "can you prove you fixed all the places" and so on...

Several people have expressed interest in a locking scheme for locks.c
(and probably lockd) that doesn't depend on BKL, so I don't think it
would be ignored.  But, yes, it would have to be done very carefully;
there have been at least one or two previous attempts that failed.

> >>> (For example, my impression is that a mandatory lock can be applied just
> >>> after the locks_mandatory_area() checks but before the io actually
> >>> completes.)
> > 
> > ... I'm not aware of other races in the existing file-locking code.  It
> > sounds like you might be.  Could you give specific examples?
> 
> Well, there's a long standing BUG in leases code - when we made all the
> checks in inserting lease, we call the locks_alloc_lock() and may fall
> asleep. Bu after the wakeup nobody re-checks for the things to change.

Ouch, yes, you're right.

> I suspect there are other bad places.

OK.  Thanks in advance for finding any!

--b.
