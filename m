Return-Path: <linux-kernel-owner+w=401wt.eu-S1758833AbZKKUeD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758833AbZKKUeD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 15:34:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757358AbZKKUeC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 15:34:02 -0500
Received: from mail.vyatta.com ([76.74.103.46]:37716 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757349AbZKKUeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 15:34:00 -0500
Date: Wed, 11 Nov 2009 12:33:40 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Mount -o sync regression in 2.6.31
Message-ID: <20091111123340.703f5c86@nehalam>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One of the configurations supported in our specialized distribution is using
floppy to store configuration information (and live cd for everything else).
The floppy is mounted with '-o sync' so that if floppy is removed the files
are still updated. The floppy is formatted with ext2 filesystem.

This broke somewhere between 2.6.30 and 2.6.31-rc1, and was caught by our
release regression system (with VMware pseudo-floppys) but it is easily
reproducible with real hardware.

The following sequence demonstrates this:

# mount /dev/fd0 /mnt -o sync,noatime,noexec,nosuid 
# cp /etc/motd /mnt/motd.$$

(Manually eject floppy)

# umount /mnt

(I/O errors occur)

With -o sync, all I/O should have been completed when the copy was done.

This may also effect people using -o sync on USB thumb drives as well.

I tried the obvious bisection, but git bisect seems to wonder off into the
weeds now. There is no reason that bisecting between v2.6.30 and v2.6.31-rc1
should go off into v2.6.30-rc2

