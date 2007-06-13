Return-Path: <linux-kernel-owner+w=401wt.eu-S1758938AbXFMQMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758938AbXFMQMi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 12:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758174AbXFMQMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 12:12:30 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:32879 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757531AbXFMQM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 12:12:29 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18032.5991.475110.794691@stoffel.org>
Date: Wed, 13 Jun 2007 12:12:23 -0400
From: "John Stoffel" <john@stoffel.org>
To: Chris Mason <chris.mason@oracle.com>
Cc: John Stoffel <john@stoffel.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [ANNOUNCE] Btrfs: a copy on write, snapshotting FS
In-Reply-To: <20070613145442.GC28279@think.oraclecorp.com>
References: <20070612161029.GB28279@think.oraclecorp.com>
	<18031.26764.586958.632146@stoffel.org>
	<20070613103522.GW28279@think.oraclecorp.com>
	<18031.63640.103936.137412@stoffel.org>
	<20070613145442.GC28279@think.oraclecorp.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Chris" == Chris Mason <chris.mason@oracle.com> writes:

Chris> On Wed, Jun 13, 2007 at 10:00:56AM -0400, John Stoffel wrote:
>> >>>>> "Chris" == Chris Mason <chris.mason@oracle.com> writes:
>> >> As a user of Netapps, having quotas (if only for reporting purposes)
>> >> and some way to migrate non-used files to slower/cheaper storage would
>> >> be great.
>> 
Chris> So far, I'm not planning quotas beyond the subvolume level.
>> 
>> So let me get this straight.  Are you saying that quotas would only be
>> on the volume level, and for the initial level of sub-volumes below
>> that level?  Or would *all* sub-volumes have quota support?  And does
>> that include snapshots as well?

Chris> On disk, snapshots and subvolumes are identical...the only
Chris> difference is their starting state (sorry, it's confusing, and
Chris> it doesn't help that I interchange the terms when describing
Chris> features).

Ok, that's fine.  A sub-volume is the unit and depending on it's
state, it's either a snapshot of an existing volume, or it's a volume
on it's own, though it still has a parent (?) which it is mounted
below?  Do I have it right now?  

Chris> Every subvolume will have a quota on the number of blocks it
Chris> can consume.  I haven't yet decided on the best way to account
Chris> for blocks that are actually shared between snapshots, but
Chris> it'll be in there somehow.  So if you wanted to make a snapshot
Chris> readonly, you just set the quota to 1 block.

Ok, so you really aren't talking about Quotas here, but space
reservations instead.  

Also, I think you're wrong here when you state that making a snapshot
(sub-volume?) RO just requires you to set the quota to 1 block.  What
is to stop me from writing 1 block to a random file that already
exists?  

Chris> But, I'm not planning on adding a way to say user X in
Chris> subvolume Y has quota Z.  I'll just be: this subvolume can't
Chris> get bigger than a given size.  (at least for version 1.0).

Ok, so version 1.0 isn't as interesting to me in a production
environment, since we pretty much need quotas (or a quick way to
monitor how much space a user has been allocated on a volume.

But for a home system, it's certainly looking interesting as well,
since I could give each home directory it's own sub-volume and just
grow/shrink them as needed.  

Maybe.  :]

Thanks for your work on this.

John
