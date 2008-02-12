Return-Path: <linux-kernel-owner+w=401wt.eu-S1762258AbYBLNud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762258AbYBLNud (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 08:50:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757928AbYBLNuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 08:50:24 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:10409 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757800AbYBLNuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 08:50:23 -0500
From: Chris Mason <chris.mason@oracle.com>
To: David Miller <davem@davemloft.net>
Subject: Re: BTRFS partition usage...
Date: Tue, 12 Feb 2008 08:49:34 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       btrfs-devel@oss.oracle.com
References: <200802061200.14690.chris.mason@oracle.com> <20080211.232139.14959431.davem@davemloft.net> <20080212.001104.172517283.davem@davemloft.net>
In-Reply-To: <20080212.001104.172517283.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802120849.34477.chris.mason@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 February 2008, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Mon, 11 Feb 2008 23:21:39 -0800 (PST)
>
> > Filesystems like ext2 put their superblock 1 block into the partition
> > in order to avoid overwriting disk labels and other uglies.  UFS does
> > this too, as do several others.  One of the few exceptions I've been
> > able to find is XFS.
> >
> > This is a real issue on sparc where the default sun disk labels
> > created use an initial partition where block zero aliases the disk
> > label.  It took me a few iterations before I figured out why every
> > btrfs make would zero out my disk label :-/
>
> Actually it seems this is only a problem with mkfs.btrfs, it clears
> out the first 64 4K chunks of the disk for whatever reason.

It is a good idea to remove supers from other filesystems.  I also need to add 
zeroing at the end of the device as well.

Looks like I misread the e2fs zeroing code.  It zeros the whole external log 
device, and I assumed it also zero'd out the start of the main FS.

So, if Btrfs starts zeroing at 1k, will that be acceptable for you?

-chris
