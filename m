Return-Path: <linux-kernel-owner+w=401wt.eu-S1758608AbYFYPSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608AbYFYPSo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 11:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbYFYPSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 11:18:35 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:45765 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291AbYFYPSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 11:18:34 -0400
Date: Wed, 25 Jun 2008 11:15:50 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: e2fsck vs sata_sil & 400GB drive
To: LKML <linux-kernel@vger.kernel.org>
Message-id: <200806251115.50981.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-disposition: inline
User-Agent: KMail/1.9.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings all;

I got a rather unpleasant surprise this morning while rebooting to 2.6.26-rc8

The drive I use for amanda's virtual tapes is a 400GB Deathstar on a sata_sil 
based pci card.

I didn't think too much of it when the bootup said it had been mounted 26 times, 
check forced.  So I knew I was in for a 30+ minute wait, but e2fsck normally 
outputs about the first 24% of the check's progress on that particular drive 
fairly quickly before entering a silent phase that may last 15+ minutes, then 
resume, but do another long pause somewhere in the 80% finished area.  These 
pauses have been part of an e2fsck session since drives went above 40GB IIRC.

But this morning it just sat there without any drive activity or any sign that 
it may have been working, but the keyboard was apparently alive, return keys 
were getting a 1 line scroll.  I let it sit for about 40 minutes while I made 
preps to get to work on a garage attachment for our house.  Then I then tried 
several other kernels in the 2.6.26-rcx category, and all did the same, no 
progress bar from e2fsck at all.

I was forced to reboot to a rescue disk and edit /etc/fstab to remove that drive 
from the fstab list, then rebooted to 2.6.26-rc8 which was then normal, and I 
was able to execute "e2fsck -C0 -p /dev/sdc1", and it ran as expected.  
Re-enabling the entry in fstab, it wouldn't mount, IMO it should have, but did 
on yet another reboot.  All told, a simple reboot took well over 2.5 hours to 
get back to a fully mounted, functioning system.

Catching some total newbie on something like this, and his answer will be to 
reach for the windows install disks, never again to touch linux with a 20 foot 
pole.

I have no idea what the problem is, but this needs moved to the top 5 on the 
list of fixit's.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
George Orwell was an optimist.
