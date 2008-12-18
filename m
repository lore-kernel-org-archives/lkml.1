Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753823AbYLRVXD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbYLRVXD (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 16:23:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbYLRVWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 16:22:49 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:60531 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbYLRVWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 16:22:48 -0500
In-Reply-To: <49496EDE.5080101@garzik.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: adilger@sun.com, Andrew Morton <akpm@linux-foundation.org>,
        Chris Mason <chris.mason@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        sfr@canb.auug.org.au
MIME-Version: 1.0
Subject: Re: Notes on support for multiple devices for a single filesystem
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OF9024F31C.23D1F5EB-ON88257523.0072DF85-88257523.00757345@us.ibm.com>
From: Bryan Henderson <hbryan@us.ibm.com>
Date: Thu, 18 Dec 2008 13:22:47 -0800
X-MIMETrack: Serialize by Router on D01ML604/01/M/IBM(Build V85_10262008HFIGS1|October
 26, 2008) at 12/18/2008 16:22:45,
	Serialize complete at 12/18/2008 16:22:45
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Features like the very nice and useful directory-based snapshots would
>> also not be possible with simple block-based multi-devices, right?

>Snapshotting via block device has always been an incredibly dumb hack, 
>existing primarily because filesystem-based snapshots did not exist for 
>the filesystem in question.

I can see that if the filesystem driver in question could already do 
snapshots, nobody would have added snapshot function to the block device 
driver under it, but this doesn't explain why someone at some time created 
block device snapshot instead of creating it for the filesystem in 
question.

>Snapshots are better at the filesystem level because the filesystem is 
>the only entity that knows when the filesystem is quiescent and 
>snapshot-able.

You can use the same logic to say that snapshots are better at the 
application level because only the application knows when its database is 
quiescent and snapshot-able.  In fact, carrying it to the extreme, you 
could say snapshots are better done manually by the human end user with 
none of the computer knowing anything about it.

It probably minimizes engineering effort to have snapshot capability at 
every level, with the implementation at each level exploiting the function 
at the level below.  E.g. when someone tells a filesystem driver to 
snapshot a filesystem that resides on two block devices, the filesystem 
driver quiesces the filesystem, then snapshots each device (implemented in 
the block device driver), then resumes.  The new snapshot filesystem lives 
on the two new snapshot block devices.

Of course, if you want to do a form of snapshot that makes sense only in 
the context of a filesystem, like the directory snapshot mentioned above, 
then you can't get as much help from snapshot functions in the storage 
devices.

--
Bryan Henderson                     IBM Almaden Research Center
San Jose CA                         Storage Systems

