Return-Path: <linux-kernel-owner+w=401wt.eu-S1753157AbXF2IoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157AbXF2IoR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 04:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753758AbXF2IoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 04:44:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:45091 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157AbXF2IoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 04:44:04 -0400
To: "Kent Overstreet" <kent.overstreet@gmail.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] LVM/RAID/FS integration
References: <6f703f960706271609m6fdfb9c1ha3555a68fe1d9d55@mail.gmail.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 29 Jun 2007 11:39:44 +0200
In-Reply-To: <6f703f960706271609m6fdfb9c1ha3555a68fe1d9d55@mail.gmail.com>
Message-ID: <p73myyj3xr3.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Kent Overstreet" <kent.overstreet@gmail.com> writes:
> 
> Basically, the order we want is fs -> raid -> lvm. Given a set of
> identical drives, we want LVM to handle them separately and divide
> them up into LVs identically; then corresponding LVs are raided
> together. We might have a raid5 volume and a raid1 volume, each of
> which can be resized independently. The FS then makes use of both of
> them, putting metadata and frequently used data on the raid1 and
> everything else on the raid5 (btrfs, as I understand it, will be able
> to do this sort of thing eventually).

XFS can do it already using its realtime volume feature. It keeps the
metadata on the original device and puts the data on another device.
The log can be also on another device (but other file systems support
that too)

People often complain about the code size and complexity
of XFS, but it actually implements a lot of functionality
other file systems don't have in there.

Arguably it's all not too easy to configure and a little awkward to
have upto 3 LVs per fs.

And there is no concept of "frequently used data" (which would be
probably hard anyways; how would you move data if it becomes
frequently used) Out of tree XFS actually supports that using DMAPI
and an external manager for automatic swapping of files to tape
robots, but you probably don't want to go this way. DMAPI is pretty
ugly. 

> The trouble is it's completely impractical with current tools; we need
> tighter integration between md and LVM. 

The current direction seems to be to slowly duplicate all MD
functionality in DM, but then there were also some movements
to add a little volume manager to MD. We'll see who wins.
They both move relatively slowly.

> throw out my ideas before I get too far in. Thoughts?

Some nicer high level userland utilities who know how to integrate all
this would be probably a good idea. 

That seems to be the main appeal of ZFS anyways --
simpler user interfaces.

-Andi
