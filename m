Return-Path: <linux-kernel-owner+w=401wt.eu-S1754785AbZCYBT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbZCYBT6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 21:19:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280AbZCYBTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 21:19:50 -0400
Received: from THUNK.ORG ([69.25.196.29]:41399 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753177AbZCYBTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 21:19:49 -0400
Date: Tue, 24 Mar 2009 21:19:42 -0400
From: Theodore Tso <tytso@mit.edu>
To: Niel Lambrechts <niel.lambrechts@gmail.com>
Cc: "linux.kernel" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.29: EXT4: __ext4_get_inode_loc errors after s2disk
Message-ID: <20090325011942.GH32307@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Niel Lambrechts <niel.lambrechts@gmail.com>,
	"linux.kernel" <linux-kernel@vger.kernel.org>
References: <49C941D5.1000509@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C941D5.1000509@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24, 2009 at 10:25:57PM +0200, Niel Lambrechts wrote:
> Hi,
> 
> After upgrading to 2.6.29 I get the below errors after resuming from
> hibernating with s2disk. I ran fsck and tried doing the same thing again
> in 2.6.28.9-pae, but do not get any errors there.

The ext4 errors are interleaved with hardware errors, and the ext4
errors are about I/O errors.

EXT4-fs error (device sda6): __ext4_get_inode_loc: unable to read inode block - inode=2346519
EXT4-fs error (device sda6) in ext4_reserve_inode_write: IO failure

This looks more like a hibernation problem than an ext4 problem.
Looks like the hard drive is being left in some inconsistent state
after resuming from hibernation.

     	   	       		   	   - Ted

> sd 0:0:0:0: [sda] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
> sd 0:0:0:0: [sda] Sense Key : Aborted Command [current] [descriptor]
> sd 0:0:0:0: [sda] Add. Sense: No additional sense information
> end_request: I/O error, dev sda, sector 242190447
> sd 0:0:0:0: [sda]
> Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
> sd 0:0:0:0: [sda] Sense Key : Aborted Command [current] [descriptor]
> sd 0:0:0:0: [sda] block=9404418Add. Sense: No additional sense information end_request:
> I/O error, dev sda, sector 242190703
> sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors: (200 GB/186 GiB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
> support DPO or FUA
> sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors: (200 GB/186 GiB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
> support DPO or FUA

