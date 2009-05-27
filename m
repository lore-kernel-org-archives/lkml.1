Return-Path: <linux-kernel-owner+w=401wt.eu-S933239AbZE0SQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933239AbZE0SQq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 14:16:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933143AbZE0SP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 14:15:56 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53257 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933112AbZE0SPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 14:15:44 -0400
Date: Wed, 27 May 2009 14:15:42 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Kay Sievers <kay.sievers@vrfy.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       SCSI development list <linux-scsi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       <linux-fsdevel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 25/20] sysfs: Only support removing emtpy sysfs  directories.
In-Reply-To: <m1ljoi1l5a.fsf@fess.ebiederm.org>
Message-ID: <Pine.LNX.4.44L0.0905271410410.15690-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 May 2009, Eric W. Biederman wrote:

> Alan Stern <stern@rowland.harvard.edu> writes:
> 
> > On Wed, 27 May 2009, Kay Sievers wrote:
> >
> >> On Wed, May 27, 2009 at 01:49, James Bottomley
> >> <James.Bottomley@hansenpartnership.com> wrote:
> >> 
> >> > OK ... perhaps we have to wait a little harder: try this; it waits until
> >> > all the targets have disappeared from visibility via an event.
> >> 
> >> That seems to work fine here.
> >
> > It's good for a short-term fix.  For the longer term, I still think 
> > it's a mistake to wait for the sdevs to be released before deleting the 
> > target.  It gives user programs the ability to block the host-removal 
> > thread indefinitely.
> 
> How can user programs block removal indefinitely today?

As fas as I know, they can't.  Instead, they can cause the SCSI layer 
to unregister a sysfs directory containing a child directory.  :-)

Basically, a user program can delay removal of the child (i.e., the
target) directory indefinitely, because currently the target isn't
unregistered when all its children are removed -- it's unregistered
when all its children are _released_.

Alan Stern

