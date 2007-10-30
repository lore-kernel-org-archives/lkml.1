Return-Path: <linux-kernel-owner+w=401wt.eu-S1754852AbXJ3N7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbXJ3N7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 09:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753323AbXJ3N70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 09:59:26 -0400
Received: from zakalwe.fi ([80.83.5.154]:42564 "EHLO zakalwe.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752453AbXJ3N7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 09:59:25 -0400
Date: Tue, 30 Oct 2007 15:59:24 +0200
From: Heikki Orsila <shdl@zakalwe.fi>
To: Chris Holvenstot <cholvenstot@comcast.net>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Major SATA / EXT3 Issue?
Message-ID: <20071030135923.GA3441@zakalwe.fi>
References: <1193451712.6639.13.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1193451712.6639.13.camel@localhost>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2007 at 09:21:52PM -0500, Chris Holvenstot wrote:
> In each case the failure mode appears to have been the same ??? the system
> appears to lock up. When rebooted I get a long string of messages like:
> 
> 
> Oct 26 20:07:37 localhost kernel: [ 101.581091] ata2: timeout waiting
> for ADMA IDLE, stat=0x440
> 
> Oct 26 20:07:37 localhost kernel: [ 101.581096] sd 1:0:0:0: [sda] Write
> Protect is off
> 
> Oct 26 20:07:37 localhost kernel: [ 101.581174] res
> 71/04:08:00:00:00/04:00:1d:00:00/e0 Emask 0x1 (device error)
> 
> Oct 26 20:07:37 localhost kernel: [ 101.644992] ata2.00: configured for
> UDMA/33
> 
> Oct 26 20:07:37 localhost kernel: [ 101.644994] ata2: EH complete
> 
> Oct 26 20:07:37 localhost kernel: [ 101.645006] sd 1:0:0:0: [sda] Write
> cache: disabled, read cache: enabled, doesn't support DPO or FUA

As it turns out, our organizations version control server just blew up 
last night. The filesystem is rather corrupt at the moment, fortunately 
we have backups.

We are running 2.6.22.5 (vanilla) on Debian 4.0. It has two SATA devices 
with Linux software raid mirror (mdadm) on Intel ata_piix chipset.
The filesystem is EXT3.

1. This happened during nightly backup:

init_special_inode: bogus i_mode (177777)
ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata1.00: cmd ca/00:68:6f:3a:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 53248 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata1: port is slow to respond, please be patient (Status 0xd0)
ata1: device not ready (errno=-16), forcing hardreset
ata1: soft resetting port
ata1.00: revalidation failed (errno=-2)
ata1: failed to recover some devices, retrying in 5 secs
ata1: soft resetting port
ata1.00: configured for UDMA/133
ata1: EH complete
sd 0:0:0:0: [sda] 488397168 512-byte hardware sectors (250059 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
init_special_inode: bogus i_mode (177777)
init_special_inode: bogus i_mode (177777)
init_special_inode: bogus i_mode (177777)
journal_bmap: journal block not found at offset 5133 on md2
Aborting journal on device md2.
ext3_abort called.
EXT3-fs error (device md2): ext3_journal_start_sb: Detected aborted journal
Remounting filesystem read-only
__journal_remove_journal_head: freeing b_committed_data

2. I rebooted

3. fsck -p on boot failed

(it is very probable not many files were corrupted at this stage)

4. I ran fsck.ext3 -y

=> that corrupted lots and lots of files. This went 
into a loop, the fsck.ext3 restarted checking over and over again.

Heikki Orsila
