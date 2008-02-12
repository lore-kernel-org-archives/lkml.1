Return-Path: <linux-kernel-owner+w=401wt.eu-S1762875AbYBLOKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762875AbYBLOKE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 09:10:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760014AbYBLOJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 09:09:51 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:18068 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759772AbYBLOJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 09:09:50 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: BTRFS partition usage...
Date: Tue, 12 Feb 2008 09:08:59 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, btrfs-devel@oss.oracle.com
References: <200802061200.14690.chris.mason@oracle.com> <200802120849.34477.chris.mason@oracle.com> <Pine.LNX.4.64.0802121458420.21102@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0802121458420.21102@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802120908.59602.chris.mason@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 February 2008, Jan Engelhardt wrote:
> On Feb 12 2008 08:49, Chris Mason wrote:
> >> > This is a real issue on sparc where the default sun disk labels
> >> > created use an initial partition where block zero aliases the disk
> >> > label.  It took me a few iterations before I figured out why every
> >> > btrfs make would zero out my disk label :-/
> >>
> >> Actually it seems this is only a problem with mkfs.btrfs, it clears
> >> out the first 64 4K chunks of the disk for whatever reason.
> >
> >It is a good idea to remove supers from other filesystems.  I also need to
> > add zeroing at the end of the device as well.
> >
> >Looks like I misread the e2fs zeroing code.  It zeros the whole external
> > log device, and I assumed it also zero'd out the start of the main FS.
> >
> >So, if Btrfs starts zeroing at 1k, will that be acceptable for you?
>
> Something looks wrong here. Why would btrfs need to zero at all?
> Superblock at 0, and done. Just like xfs.
> (Yes, I had xfs on sparc before, so it's not like you NEED the
> whitespace at the start of a partition.)

I've had requests to move the super down to 64k to make room for bootloaders, 
which may not matter for sparc, but I don't really plan on different 
locations for different arches.

4k aligned is important given that sector sizes are growing.

-chris
