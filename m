Return-Path: <linux-kernel-owner+w=401wt.eu-S1754166AbZFBXms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166AbZFBXms (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 19:42:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751178AbZFBXml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 19:42:41 -0400
Received: from mga14.intel.com ([143.182.124.37]:25894 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088AbZFBXmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 19:42:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,294,1241420400"; 
   d="scan'208";a="149963563"
From: "Luck, Tony" <tony.luck@intel.com>
To: linux-kernel@vger.kernel.org
Subject: linux-next end of partition problems?
Date: Tue, 02 Jun 2009 16:42:33 -0700
Message-Id: <4a25b8e987329b28c@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed an odd message in the kernel log while booting
linux-next (tag: next-20090602[*])

attempt to access beyond end of device
sdb3: rw=0, want=31664120, limit=31664115

sdb3 is an ext3 filesystem mounted as /home

$ grep sdb3 /proc/partitions
   8       19   15832057 sdb3

I think /proc/partitions in in KBytes ... so the block (512 Byte)
count for this partition is 2*15832057 = 31664114 ... so the
"limit" in the console log looks reasonable, and since the "want"
is a bigger number, it does seem that we are trying to access
beyond the device.

BUT ... I don't get this message when booting a kernel built
from Linus' tree.

I see other weird stuff too.  Running a Linus kernel I get:
$ dd if=/dev/sdb3 of=/dev/null bs=1024
15832057+1 records in
15832057+1 records out

this neatly matches the reported size in /proc/partitions,
and no messages on the console.


With linux-next I see:
dd if=/dev/sdb3 of=/dev/null bs=1024
dd: reading `/dev/sdb3': Input/output error
15831936+0 records in
15831936+0 records out

and the same
attempt to access beyond end of device
sdb3: rw=0, want=31664120, limit=31664115


Note that on linux-next the "dd" gets the I/O error 121 blocks
earlier than we see end-of-file for this partition on the Linus
kernel.

-Tony

[*] grepping through boot logs I see this message appears in earlier
tags too.  All builds since next-20090428 show this problem (but I
wasn't being very diligent in April ... the previous build for
which I have a recorded console log was next-20090417).
