Return-Path: <linux-kernel-owner+w=401wt.eu-S1761669AbZE1Rvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761669AbZE1Rvu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 13:51:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754624AbZE1Rvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 13:51:39 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35595 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751966AbZE1Rvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 13:51:39 -0400
Date: Thu, 28 May 2009 13:51:39 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Hannes Reinecke <hare@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       SCSI development list <linux-scsi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       <linux-fsdevel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 25/20] sysfs: Only support removing emtpy sysfs  directories.
In-Reply-To: <m18wkhw7s3.fsf@fess.ebiederm.org>
Message-ID: <Pine.LNX.4.44L0.0905281349490.4059-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 May 2009, Eric W. Biederman wrote:

> Alan Stern <stern@rowland.harvard.edu> writes:
> 
> > There's another point to consider.  If you do accept my argument that 
> > empty targets can be removed from visibility regardless of the host's 
> > state, then this removal races with addition of a new child.  Since 
> > removal involves calling device_del(), it can't be protected by the 
> > host lock.  Instead we'd have to use a mutex to protect both target 
> > addition and target removal.
> 
> Careful.  Holding a lock over device_del is an easy and hidden way
> to trigger a rare deadlocks.

Your point is well taken.  In addition, I don't really like the idea of 
forcing device removal to wait for some other device to be added.

I'll work around the problem somehow...  A short polling loop shoud do 
the job.

Alan Stern

