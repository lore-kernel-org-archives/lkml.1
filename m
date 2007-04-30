Return-Path: <linux-kernel-owner+w=401wt.eu-S1161611AbXD3AdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161611AbXD3AdF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 20:33:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161625AbXD3AdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 20:33:05 -0400
Received: from bee.hiwaay.net ([216.180.54.11]:24369 "EHLO bee.hiwaay.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161611AbXD3AdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 20:33:04 -0400
Date: Sun, 29 Apr 2007 19:33:00 -0500
From: Chris Adams <cmadams@hiwaay.net>
To: linux-kernel@vger.kernel.org
Subject: Re: Why ask Sun for ZFS while we have ReiserFS4 !?
Message-ID: <20070430003300.GA836155@hiwaay.net>
References: <fa.ckqWn91jd6WlOc/jXumi8IQTAMk@ifi.uio.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070429234201.GB19937@thunk.org>
User-Agent: Mutt/1.4i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Once upon a time, Theodore Tso  <tytso@mit.edu> said:
>The people who want ZFS have in mind certain features, such as the
>ability to scale to very large sizes, and ease of use when
>administering filesystems that span multiple disks (ZFS subsumes the
>device-mapper/RAID layer in Solaris, so they get certain performance
>benefits and they are able to make it simpler to set up a filesystem
>that spans multiple disks with a single command --- the flip side is
>that they are violating an relatively well understood abstraction
>boundary, for better or for worse).   

I haven't used ZFS, but I do manage servers with Tru64 Unix AdvFS
filesystems.  Having some of the logical volume functionality merged in
the filesystem layer does seem to be a good thing.  For example,
snapshotting a filesystem can use free space in the filesystem (without
having to set aside unused logical volume space for snapshotting).
Expanding the filesystem is simple: "addvol <device> <AdvFS domain>" and
go (no adding to the volume group, extending the logical volume, and
resizing the filesystem).  Shrinking the filesystem is just as easy
(currently you can't even do that live with ext3).

I know this violates the Linux layering.  However, AdvFS has done this
for years (in a single-system-image cluster environment even), and now I
guess ZFS does it as well.  Maybe the Linux layering needs a revision to
handle something like this?

I'm just speaking as a system admin that prefers Linux everywhere, but
does like (and will miss) a few things about Tru64/TruCluster.
