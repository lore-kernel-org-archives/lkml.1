Return-Path: <linux-kernel-owner+w=401wt.eu-S1760107AbYBYXXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760107AbYBYXXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 18:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753753AbYBYXXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 18:23:11 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:56449 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753788AbYBYXXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 18:23:09 -0500
Date: Mon, 25 Feb 2008 15:20:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Anders Henke <anders.henke@1und1.de>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com
Subject: Re: device mapper not reporting no-barrier-support?
Message-Id: <20080225152050.94788622.akpm@linux-foundation.org>
In-Reply-To: <20080225132615.GA21990@1und1.de>
References: <20080225132615.GA21990@1und1.de>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Feb 2008 14:26:15 +0100 Anders Henke <anders.henke@1und1.de> wrote:

> Hi,
> 
> I'm currently stuck between Kernel LVM and DRBD, as I'm using Kernel
> 2.6.24.2 with DRBD 8.2.5 on top of an LVM2 device (LV).
> 
> -LVM2/device mapper doesn't support write barriers
> -DRBD uses blkdev_issue_flush() to flush its metadata to disk.
>  On a no-barrier-device, DRBD should receive EOPNOTSUPP, but
>  it really does receive an EIO. Promptly, DRBD gives the
>  error message "drbd0: local disk flush failed with status -5".
> 
> The physical disk (in LVM speak) is a RAID1 on a 3ware 9650SE-2LP
> controller; the driver 3w-9xxx supports barriers and after moving my D
> RBD device from the LV to a single partition on the same RAID1, the 
> error messages from DRBD vanished.
> 
> I've posted a lengty summary of my findings to
> 
> http://lists.linbit.com/pipermail/drbd-user/2008-February/008665.html
> 
> ... where Lars Ellenberg from DRBD basically responded in
> 
> http://lists.linbit.com/pipermail/drbd-user/2008-February/008666.html
> 
> ... that DRBD does catch the EOPNOTSUPP for blkdev_issue_flush and
> BIO_RW_BARRIER, but the lvm implementation of blkdev_issue_flush in
> 2.6.24.2 aparently does return EIO for blkdev_issue_flush.
> 
> So simply the question: how should a top-layer driver check wether a lower
> device does support barriers? md-raid does check this way differently than
> e.g. XFS does, while DRBD also adds a third way to check this.
> Or is this "merely" a bug in drivers/md/dm.c?
> 

(cc dm-devel)

I'd say it's a DM bug.  Probably a hard-to-fix one though.
