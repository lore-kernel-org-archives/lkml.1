Return-Path: <linux-kernel-owner+w=401wt.eu-S1757960AbZE0QQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960AbZE0QQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 12:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755262AbZE0QQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 12:16:09 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52079 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754197AbZE0QQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 12:16:07 -0400
Date: Wed, 27 May 2009 12:16:09 -0400 (EDT)
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
In-Reply-To: <1243440094.6067.10.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.44L0.0905271213040.15613-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 May 2009, James Bottomley wrote:

> Hardly ... our current refcounting is on destruction (releases).  This
> problem is an instance of visibility (the del calls) we need the
> visibility teardown to work nicely.  We currently have no refcounting on
> the visibility.  Even if we did (and we could add a ref on when the
> underlying device del calls are done), what happens if the target needs
> to become visible again.  Apparently the generic device infrastructure
> can't accept doing an add on a previously del'd device.

Definitely not.

> The most obvious way of fixing this is to have a special case for
> targets of dying hosts ... they could call del early on the
> understanding that they're never getting new underlying devices.  That
> would allow the wait to trigger on the last target del, which is what is
> optimal.

I don't understand all the subtle issues here.  In other contexts, the 
solution would be to initialize a refcount to 1 when the target is 
allocated, increment it when a device is added, and decrement it when a 
device is removed or the host is removed.  When the refcount goes to 0, 
the target is deleted.  Why wouldn't this kind of approach work?

Alan Stern

