Return-Path: <linux-kernel-owner+w=401wt.eu-S1752097AbYIBKg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbYIBKg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 06:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751178AbYIBKgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 06:36:49 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:2962 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbYIBKgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 06:36:48 -0400
Message-ID: <48BD173B.3090600@hp.com>
Date: Tue, 02 Sep 2008 06:36:43 -0400
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: device-mapper development <dm-devel@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, tj@kernel.org
Subject: Problem w/ CONFIG_DEBUG_BLOCK_EXT_DEVT
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have found two problems in LVM2/DM w/ a potential new "experimental
feature" in 2.6.28: CONFIG_DEBUG_BLOCK_EXT_DEVT (this is from Jens
Axboe's origin/for-2.6.28 git branch)

"Conventionally, block device numbers are allocated from predetermined
contiguous area.  However, extended block area may introduce
non-contiguous block device numbers.  This option forces most block
device numbers to be allocated from the extended space and spreads them
to discover kernel or userland code paths which assume predetermined
contiguous device number allocation."

W/ LVM2 & DM there are (at least) two issues:

(1) Device major numbers for some reason are /not/ being entered
correctly into /proc/devices -- w/ CONFIG_DEBUG_BLOCK_EXT_DEVT=y I am
seeing some devices w/ major "259" (a SATA controller) but no entry in
/proc/devices. LVM2/DM will not find the entry in /proc/devices, and not
allow any device w/ that major to be used with LVM commands.

(2) Device minor numbers can be quite large, and the 10-character limits
in dm/lib/libdm-deptree.c are too small.

Alan
