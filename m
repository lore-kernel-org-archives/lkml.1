Return-Path: <linux-kernel-owner+w=401wt.eu-S1752885AbXKRFkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbXKRFkg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 00:40:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751021AbXKRFk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 00:40:29 -0500
Received: from gherkin.frus.com ([192.158.254.49]:39873 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856AbXKRFk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 00:40:28 -0500
X-Greylist: delayed 1190 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 Nov 2007 00:40:28 EST
Subject: [BUG] 2.6.23-rc3 can't see sd partitions on Alpha
To: linux-kernel@vger.kernel.org
Date: Sat, 17 Nov 2007 23:20:36 -0600 (CST)
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20071118052036.11B45DBA2@gherkin.frus.com>
From: rct@gherkin.frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Completely reproducible... 2.6.23-rc3 kernel boots, and normal messages
are seen on console as far as disks found and partitions on each.  However,
once /dev is populated and the boottime scripts attempt to check filesystem
status, no partitions on either of the two disks attached to the SCSI
controller are seen.  Dropping into a single-user root shell confirms
the sudden "blindness": fdisk can't open /dev/sda.

When I reboot on 2.6.24-rc2, everything works normally.

System environment is Debian Etch.  Both 2.6.24-rc2 and -rc3 were built
from the respective unaltered kernel.org source trees, using the same
kernel configuration modulo saying "no" to CONFIG_SENSORS_I5K_AMB and
CONFIG_PID_NS in -rc3.  No problems with -rc3 on a x86 box.

-- 
------------------------------------------------------------------------
Bob Tracy          |  "They couldn't hit an elephant at this dist- "
rct@frus.com       |   - Last words of Union General John Sedgwick,
                   |  Battle of Spotsylvania Court House, U.S. Civil War
------------------------------------------------------------------------
