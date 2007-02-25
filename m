Return-Path: <linux-kernel-owner+w=401wt.eu-S1752305AbXBYEVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305AbXBYEVz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 23:21:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752300AbXBYEVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 23:21:55 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:50655 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbXBYEVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 23:21:54 -0500
Date: Sat, 24 Feb 2007 20:19:02 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mario Vanoni <vanonim@alice.it>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.16.41 & 2.6.18.7 OK,   2.6.19.5 NOT,   2.6.18.8 KERNEL
 PANIC
Message-Id: <20070224201902.a2a7b3da.randy.dunlap@oracle.com>
In-Reply-To: <45E05D54.10508@alice.it>
References: <45E05D54.10508@alice.it>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Feb 2007 16:44:20 +0100 Mario Vanoni wrote:

> 2.6.18.7 vanilla & 2.6.16.41 vanilla:
> /dev/hda CD/DVD
> /dev/hda1 / IDE HD 160GB
> /dev/hda2 swap
> /dev/sda1 /xyz SATA HD 320GB
> /dev/sda2 swap
> /dev/sdb1 /zzz SATA HD 320GB
> /dev/sdb2 swap
> /dev/sdc1 /usb USB KEY 512MB
> all 100% OK since 12-Dec-2006
> 
> 2.6.19.5 vanilla:
> /dev/hda, /dev/hdb OK
> 
> fsck 1.38 (30-Jun-2005)
> /dev/sda1: clean 2960/125696 files, 12379/125692 blocks
> but /dev/sda1 is only partially mounted, du -hs says 33M
> ...
> /sbin/e2fsck: No such file or directory while trying to open /dev/sdb1
> ...
> same for /dev/sdc1
> ...
> swapon: cannot stat /dev/sda2: No such file or directory
> same for /dev/sdb2,
> so only 2GB swap, not 6GB

For 2.6.19.*, does .config contain any CONFIG_ATA* entries?
FYI, in 2.6.19, CONFIG_SCSI_SATA* config symbols were renamed to
CONFIG_ATA*, so just using an oldconfig won't be sufficient
for SATA support.

> ---
> 2.6.18.8 vanilla: !!!
> screen eating leftmost characters, then
> kernel panic - not syncing: VFS: Unable to mount root fs on
> unknown-block(3,65)
> POWER SWITCH ultima ratio
> ---
> 
> all 4 kernels same .config from 2.6.18.6,
> make oldconfig, Enter on all new questions
> 
> AUSUS P4R800V, P4HT3400, 2GB mem
> Slackware 11.0, udev-105, gcc-3.4.6, glibc-2.3.6,
> all ext2 4096 formated
> 
> Rebooting 2.6.18.7 vanilla:
> all devices OK, 6GB swap
> 
> FEEDBACK ONLY, _not_ in LMKL



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
