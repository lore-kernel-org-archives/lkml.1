Return-Path: <linux-kernel-owner+w=401wt.eu-S1758123AbXFMOCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758123AbXFMOCd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 10:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756269AbXFMOCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 10:02:23 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:63842 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755787AbXFMOCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 10:02:22 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18031.63640.103936.137412@stoffel.org>
Date: Wed, 13 Jun 2007 10:00:56 -0400
From: "John Stoffel" <john@stoffel.org>
To: Chris Mason <chris.mason@oracle.com>
Cc: John Stoffel <john@stoffel.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [ANNOUNCE] Btrfs: a copy on write, snapshotting FS
In-Reply-To: <20070613103522.GW28279@think.oraclecorp.com>
References: <20070612161029.GB28279@think.oraclecorp.com>
	<18031.26764.586958.632146@stoffel.org>
	<20070613103522.GW28279@think.oraclecorp.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Chris" == Chris Mason <chris.mason@oracle.com> writes:

>> So, can you resize a filesystem both bigger and smaller?  Or is that
>> implicit in the Object level mirroring and striping?  

Chris> Growing the FS is just either extending or adding a new extent
Chris> tree.  Shrinking is more complex.  The extent trees do have
Chris> back pointers to the objectids that own the extent, but
Chris> snapshotting makes that a little non-deterministic.  The good
Chris> news is there are no fixed locations for any of the metadata.
Chris> So it is at least possible to shrink and pop out arbitrary
Chris> chunks.

That's good to know.  Being able to grow (online of course!) is great,
but so would shrinking as well.   It makes life so much more flexible
for the SysAdmins, which is my particular focus... since it's my day
job. 

>> As a user of Netapps, having quotas (if only for reporting purposes)
>> and some way to migrate non-used files to slower/cheaper storage would
>> be great.

Chris> So far, I'm not planning quotas beyond the subvolume level.

So let me get this straight.  Are you saying that quotas would only be
on the volume level, and for the initial level of sub-volumes below
that level?  Or would *all* sub-volumes have quota support?  And does
that include snapshots as well?

>> Ie. being able to setup two pools, one being RAID6, the other being
>> RAID1, where all currently accessed files are in the RAID1 setup, but
>> if un-used get migrated to the RAID6 area.  

Chris> HSM in general is definitely interesting.  I'm afraid it is a
Chris> long ways off, but it could be integrated into the scrubber
Chris> that wanders the trees in the background.

Neat.  As long as the idea is kept around a bit, that would be nice
for an eventual addition.  Or maybe someone needs to come up with a
stackable filesystems to take care of this...

John

