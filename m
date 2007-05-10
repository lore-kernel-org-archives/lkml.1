Return-Path: <linux-kernel-owner+w=401wt.eu-S1760588AbXEJUXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760588AbXEJUXX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 16:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757438AbXEJUXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 16:23:16 -0400
Received: from mail.fieldses.org ([66.93.2.214]:40454 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757943AbXEJUXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 16:23:15 -0400
Date: Thu, 10 May 2007 16:23:13 -0400
To: Doug Chapman <doug.chapman@hp.com>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
       Marc Eshel <eshel@almaden.ibm.com>
Subject: Re: post 2.6.21 regression in F_GETLK
Message-ID: <20070510202313.GV13719@fieldses.org>
References: <1178823375.7247.11.camel@dchapman.boston.redhat.com> <20070510193050.GQ13719@fieldses.org> <20070510193859.GR13719@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070510193859.GR13719@fieldses.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 03:38:59PM -0400, bfields wrote:
> On Thu, May 10, 2007 at 03:30:50PM -0400, bfields wrote:
> > On Thu, May 10, 2007 at 02:56:15PM -0400, Doug Chapman wrote:
> > > A recent regression (introduced after 2.6.21) was caught by the LTP test
> > > fcntl11.  It appears that F_GETLK is not properly checking for existing
> > > F_RDLCK and allows taking out a write lock.

Hm, actually, could you double-check the test results?  Looking at your
test case, it appears that it fails when the lock returned from the
fcntl(.,F_GETLK,.) has an l_type != F_RDLCK.  That doesn't necessarily
mean the F_GETLK is reporting no conflict.  I believe the bug is
actually that it's reporting the wrong kind of conflict--so it's
returning l_type == F_WRLCK, not F_UNLCK.

Also, this affects only F_GETLK, not F_SETLK, so you're not actually
managing to acquire a conflicting lock, right?

--b.
