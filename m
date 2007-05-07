Return-Path: <linux-kernel-owner+w=401wt.eu-S967053AbXEGWDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967053AbXEGWDl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 18:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966717AbXEGWDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 18:03:37 -0400
Received: from lazybastard.de ([212.112.238.170]:53613 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966527AbXEGWDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 18:03:36 -0400
Date: Mon, 7 May 2007 23:59:14 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, David Chinner <dgc@sgi.com>
Subject: [PATCH 0/2] LogFS take two
Message-ID: <20070507215913.GA15054@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Motivation:

Linux currently has 1-2 flash filesystems to choose from, JFFS2 and
YAFFS.  The latter has never made a serious attempt of kernel
integration, which may disqualify it to some.

The two main problems of JFFS2 are memory consumption and mount time.
Unlike most filesystems, there is no tree structure of any sorts on
the medium, so the complete medium needs to be scanned at mount time
and a tree structure kept in-memory while the filesystem is mounted.
With bigger devices, both mount time and memory consumption increase
linearly.

JFFS2 has recently gained summary support, which helps reduce mount
time by a constant factor.  Linear scalability remains.  YAFFS also
appears to be better by a constant factor, yet still scales linearly.

LogFS has an on-medium tree, fairly similar to Ext2 in structure, so
mount times are O(1).  In absolute terms, the OLPC system has mount
times of ~3.3s for JFFS2 and ~60ms for LogFS.


Motivation 2:

Flash is becoming increasingly common in standard PC hardware.  Nearly
a dozen different manufacturers have announced Solid State Disks
(SSDs), the OLPC and the Intel Classmate no longer contain hard disks
and ASUS announced a flash-only Laptop series for regular consumers.
And that doesn't even mention the ubiquitous USB-Sticks, SD-Cards,
etc.

Flash behaves significantly different to hard disks.  In order to use
flash, the current standard practice is to add an emulation layer and
an old-fashioned hard disk filesystem.  As can be expected, this is
eating up some of the benefits flash can offer over hard disks.

In principle it is possible to achieve better performance with a flash
filesystem than with the current emulated approach.  In practice our
current flash filesystems are not even near that theoretical goal.
LogFS in its current state is already closer.


Current state:

LogFS works and survives my testcases.  It has fairly good chances of
not eating your data during regular operation.  There are still two
known bugs that will eat data if the filesystem is uncleanly
unmounted.  Also still missing is wear leveling.

Handling of read/write/erase errors currently is BUG().  It is on my
list, no need to remind me. :)

Overall I consider this to be -mm material.  It would be good to get
some review and have the usual allyesconfig crowd build it and find
coverity bugs and the like.

http://logfs.org/logfs/ may have some further information.


Shameless plug:

I have quit my job last November to concentrate on LogFS.  While I
have found one sponsor kind enough to fund me, my monetary reserves
are fairly stressed.  Fairly soon I will be forced to take an
old-fashioned job again and work on other less exciting stuff.  So if
anyone needs a fast flash filesystem and has spare money to spend,
please contact me.

Jörn

-- 
Everything should be made as simple as possible, but not simpler.
-- Albert Einstein
