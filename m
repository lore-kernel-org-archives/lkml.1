Return-Path: <linux-kernel-owner+w=401wt.eu-S1764363AbZE1VFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764363AbZE1VFP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 17:05:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760865AbZE1VFA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 17:05:00 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56658 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758511AbZE1VE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 17:04:59 -0400
Date: Thu, 28 May 2009 17:04:59 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Hannes Reinecke <hare@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       SCSI development list <linux-scsi@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       <linux-fsdevel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 25/20] sysfs: Only support removing emtpy sysfs  directories.
In-Reply-To: <1243541439.2830.21.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.44L0.0905281656590.4059-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 May 2009, James Bottomley wrote:

> > How so?  Why not unlink the target from the host's list when the 
> > device_del() call returns?  A new target can be created any time after 
> > that, since the old one is now completely invisible.
> 
> The answer to that one is several emails back: we need the target in the
> host list for the lifetime of the devices ... it's alterable, but even
> more auditing.

I don't recall you mentioning that the target had to be linked into the 
host's list for the lifetime of the devices; I thought you said merely 
that the target had to _exist_ for the lifetime of the devices.

Does it really need to be linked, or is existence of the structure 
sufficient?

Likewise, after a device is removed from visibility, does it need to 
remain linked into the host's and target's lists?

> > P.S.: Does scsi_target_reap() really ever get called in non-process
> > context?  I couldn't find any place where that might happen.
> 
> From the device release, which is done by last put, which could be I/O
> context.

But scsi_target_reap() isn't called directly from the device release.  
It's called from scsi_device_dev_release_usercontext().

And besides, in the patch I'm working on it isn't called from either of 
those places -- it's called from __scsi_remove_device().  So I'll go 
ahead and get rid of scsi_target_reap_usercontext().

Alan Stern

