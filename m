Return-Path: <linux-kernel-owner+w=401wt.eu-S1758906AbXIRPUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906AbXIRPUP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 11:20:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756763AbXIRPUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 11:20:04 -0400
Received: from mail.fieldses.org ([66.93.2.214]:46136 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756046AbXIRPUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 11:20:03 -0400
Date: Tue, 18 Sep 2007 11:19:57 -0400
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: Re: [PATCH] Wake up mandatory locks waiter on chmod (v2)
Message-ID: <20070918151957.GA18476@fieldses.org>
References: <46EE3724.80200@openvz.org> <1190037331.6700.14.camel@heimdal.trondhjem.org> <46EE8C52.80503@openvz.org> <1190044850.6700.81.camel@heimdal.trondhjem.org> <46EF7136.7080308@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46EF7136.7080308@openvz.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2007 at 10:33:26AM +0400, Pavel Emelyanov wrote:
> Trond Myklebust wrote:
> > IOW: the process that is waiting in locks_mandatory_area() will be
> > released as soon as the advisory lock is dropped. If that theory is
> > broken in practice, then that is the bug that we need to fix. We neither
> > want to add a load of locking crap to notify_change(), nor should we
> > need to.
> 
> We have this for inotify already. Adding wakeup for mandatory lock
> is not that bad.
> 
> Anyway - I noticed, that the system state can become not consistent
> and proposed the way to fix it. If this inconsistency is not a big
> deal, and nobody cares, than I'm fine with forgetting this patch, 
> since I have no other arguments to protect it, but "this is just not
> very nice without this patch".

Maybe this should be documented, e.g. in fcntl(2).  I'm not sure exactly
what we'd say--we probably don't want to commit to the current behavior.
Maybe something like "behavior is undefined when setting or clearing
mandatory locking on a file while it is locked".

--b.
