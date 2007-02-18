Return-Path: <linux-kernel-owner+w=401wt.eu-S1750980AbXBRMun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750980AbXBRMun (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 07:50:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750979AbXBRMum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 07:50:42 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48607 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978AbXBRMuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 07:50:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.20-mm2
Date: Sun, 18 Feb 2007 13:44:54 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>,
       Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org>
In-Reply-To: <20070217215146.30e7ffa3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702181344.54959.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 18 February 2007 06:51, Andrew Morton wrote:
> 
> Temporarily at
> 
>   http://userweb.kernel.org/~akpm/2.6.20-mm2/
> 
> Will appear later at
> 
>  ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm2/

Two problems:

1) A showstopper with the root partition on RAID1:

md: raid1 personality registered for level 1
[--snip--]
md: multipath personality registered for level -4
register_blkdev: failed to get major for mdp
[--snip--]
VFS: Cannot open root device "md1" or unknown-block(0,0)

At the moment I have no serial console attached to the box, so I had to rewrite
the messages manually.

2) On HPC nx6325 I get the following 100% of the time during the resume from
disk:

BUG: at drivers/pci/pci.c:823 pcim_enable_device()

Call Trace:
 [<ffffffff80325ff8>] pcim_enable_device+0x93/0xb3
 [<ffffffff803a974a>] ata_pci_device_do_resume+0x21/0x5e
 [<ffffffff803b5e6c>] sil_pci_device_resume+0x1c/0x51
 [<ffffffff8032800d>] pci_device_resume+0x22/0x53
 [<ffffffff8039ae58>] resume_device+0xca/0x131
 [<ffffffff8039af40>] dpm_resume+0x81/0xd3
 [<ffffffff8039afc2>] device_resume+0x30/0x45
 [<ffffffff802a0792>] snapshot_ioctl+0x245/0x63e
 [<ffffffff8023cfcc>] do_ioctl+0x5e/0x77
 [<ffffffff8022d2b3>] vfs_ioctl+0x25c/0x279
 [<ffffffff80246a80>] sys_ioctl+0x5f/0x82
 [<ffffffff80215586>] sys_write+0x47/0x70
 [<ffffffff8025711e>] system_call+0x7e/0x83

Nevertheless, the system seems to be fully functional after the resume.

[I've been observing it since 2.6.20-git10 and have reported it for a couple
of times, but apparently nobody cares. :-(]

Greetings,
Rafael
