Return-Path: <linux-kernel-owner+w=401wt.eu-S1761784AbXEJVCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761784AbXEJVCX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 17:02:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761837AbXEJVCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 17:02:06 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:52230 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762038AbXEJVCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 17:02:03 -0400
Subject: Re: post 2.6.21 regression in F_GETLK
From: Doug Chapman <doug.chapman@hp.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
       Marc Eshel <eshel@almaden.ibm.com>
In-Reply-To: <20070510202313.GV13719@fieldses.org>
References: <1178823375.7247.11.camel@dchapman.boston.redhat.com>
	 <20070510193050.GQ13719@fieldses.org> <20070510193859.GR13719@fieldses.org>
	 <20070510202313.GV13719@fieldses.org>
Content-Type: text/plain
Date: Thu, 10 May 2007 17:01:05 -0400
Message-Id: <1178830865.7247.26.camel@dchapman.boston.redhat.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-34.el4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-10 at 16:23 -0400, J. Bruce Fields wrote:
> On Thu, May 10, 2007 at 03:38:59PM -0400, bfields wrote:
> > On Thu, May 10, 2007 at 03:30:50PM -0400, bfields wrote:
> > > On Thu, May 10, 2007 at 02:56:15PM -0400, Doug Chapman wrote:
> > > > A recent regression (introduced after 2.6.21) was caught by the LTP test
> > > > fcntl11.  It appears that F_GETLK is not properly checking for existing
> > > > F_RDLCK and allows taking out a write lock.
> 
> Hm, actually, could you double-check the test results?  Looking at your
> test case, it appears that it fails when the lock returned from the
> fcntl(.,F_GETLK,.) has an l_type != F_RDLCK.  That doesn't necessarily
> mean the F_GETLK is reporting no conflict.  I believe the bug is
> actually that it's reporting the wrong kind of conflict--so it's
> returning l_type == F_WRLCK, not F_UNLCK.


You are partly right on the test however note that it is using a start
and len that are specific to the RDLCK so that should _only_ conflict
with that lock.  I did notice that the LTP test is taking a new lock on
the entire file which should be blocked by eithe rthe RDLCK or the WRLCK
and it doesn't check both, I plan on fixing that once this is resolved.

But, much more importantly F_GETLK is returning F_UNLCK saying that
there was no conflict at all.

> Also, this affects only F_GETLK, not F_SETLK, so you're not actually
> managing to acquire a conflicting lock, right?
> 

True, this doesn't actually acquire the lock.  I have not tested to see
if trying a conflicting F_SETLK blocks as it should.  I will test that
later.  I missed lunch today so I won't get back to this until later
tonight or tomorrow....

- Doug



