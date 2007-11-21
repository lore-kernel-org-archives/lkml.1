Return-Path: <linux-kernel-owner+w=401wt.eu-S1754556AbXKUTp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbXKUTp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 14:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752529AbXKUTpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 14:45:15 -0500
Received: from tac.ki.iif.hu ([193.6.222.43]:55030 "EHLO tac.ki.iif.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720AbXKUTpO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 14:45:14 -0500
From: Ferenc Wagner <wferi@niif.hu>
To: linux-kernel@vger.kernel.org
Subject: network driver usage count
Date: Wed, 21 Nov 2007 20:45:11 +0100
Message-ID: <87hcjf9yd4.fsf@tac.ki.iif.hu>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Under 2.6.23.1, my lsmod output shows this:

$ lsmod | grep tg3
tg3                   100580  0 

The usage count is zero, even though it drives my two physical
interfaces:

$ ls -l /sys/class/net/eth-gb?/device/driver
lrwxrwxrwx 1 root root 0 2007-11-21 19:58 /sys/class/net/eth-gb1/device/driver -> ../../../bus/pci/drivers/tg3
lrwxrwxrwx 1 root root 0 2007-11-21 19:58 /sys/class/net/eth-gb2/device/driver -> ../../../bus/pci/drivers/tg3

These interfaces are up and bonded together, but that doesn't seem to
matter at all.  I also checked other machines, the network driver
(tg3, e1000) usage counts are always zero under various recent 2.6
kernels, but nonzero under 2.4.21 for example.

And really, the module could be removed, cutting my ssh session. :)

Was this made possible intentionally?  If yes, why?
-- 
Thanks,
Feri.

PS. please Cc: me, I'm not on the list.

PPS. on loading tg3, I get messages like:
     eth-gb1: device_rename: sysfs_create_symlink failed (-17)
     I configured renaming by udev, did I make a mistake?
