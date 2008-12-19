Return-Path: <linux-kernel-owner+w=401wt.eu-S1752841AbYLSTEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbYLSTEQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 14:04:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751185AbYLSTD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 14:03:57 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:37950 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbYLSTD4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 14:03:56 -0500
In-Reply-To: <e1f6055f0812181336q105b4ebcy81d72edd2a35baa8@mail.gmail.com>
To: "Brad Voth" <brad@voth.name>
Cc: adilger@sun.com, "Andrew Morton" <akpm@linux-foundation.org>,
       "Chris Mason" <chris.mason@oracle.com>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Jeff Garzik" <jeff@garzik.org>, "Kay Sievers" <kay.sievers@vrfy.org>,
       linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, sfr@canb.auug.org.au
MIME-Version: 1.0
Subject: Re: Notes on support for multiple devices for a single filesystem
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OF3415C20F.793A0D3C-ON88257524.0067548F-88257524.0068BCEC@us.ibm.com>
From: Bryan Henderson <hbryan@us.ibm.com>
Date: Fri, 19 Dec 2008 11:03:56 -0800
X-MIMETrack: Serialize by Router on D01ML604/01/M/IBM(Build V85_10262008HFIGS1|October
 26, 2008) at 12/19/2008 14:03:53,
	Serialize complete at 12/19/2008 14:03:53
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Brad Voth" <brad@voth.name> wrote on 12/18/2008 01:36:12 PM:

> I can see the desire to have the snapshot at the filesystem level to
> ensure that the filesystem knows it is consistent.  However, this 
> can be a duplication of effort because of the need to have snapshots
> at the block device level for non-fs devices.  Such as raw logical 
> devices for say a database.  I would think that a viable consistent 
> solution would be to have the block device snapshot mechanism have a
> hook into the filesystem api to say, "I'm preparing to take a 
> snapshot, please quiesce and return" <take block snapshot> "You may 
> now resume, Mr. Filesystem"

But that's a layering violation.  First of all, a block device doesn't 
know what a filesystem is, so you'd have to generalize it to making these 
requests to whatever has the block device in some sense open.  I don't see 
that this sequence gains you anything over the sequence I described where 
the user makes the request of the filesystem driver and the filesystem 
driver, while it has the filesystem quiesced, issues an order to the block 
device to make a snapshot.

>In this way there is a single interface for users to take snapshots
>of the block device level whether it is a raw logical volume, or a
>filesystem sitting on a logical volume.

I don't think it makes sense to have a common means of snapshotting any of 
the various things that might reside on a block device; for some, I can't 
even think of a meaningful concept of snapshotting the information on that 
device.  E.g. where it's one of 4 disks on which some filesystem resides.

--
Bryan Henderson                     IBM Almaden Research Center
San Jose CA                         Storage Systems

