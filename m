Return-Path: <linux-kernel-owner+w=401wt.eu-S1760457AbXJERLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760457AbXJERLf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 13:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756684AbXJERL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 13:11:26 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:56501 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242AbXJERL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 13:11:26 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: apw@shadowen.org, rdunlap@xenotime.net, jschopp@austin.ibm.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] 0/3 checkpatch updates, new checkfiles script
Date: Fri,  5 Oct 2007 12:56:05 -0400
Message-Id: <11916033681196-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This series of patches adds a -t option to checkpatch, so it can print terse
messages one per line, in a format compatible with g/cc
(filename:linenumber:message).  This format can be parsed by various tools
and editors that can help show the errors in one window and the offending
file+line in another window.

This patch series also introduces a new small shell script wrapper, called
scripts/checkfiles, that checks the compliance of source files (not in diff
format); the script can operate on any mix of files and directories
(recursively checking).  For example, to check the entire Linux kernel, run:

$ ./scripts/checkfiles .

So, I ran the above script and it found nearly 1.5 million reported
warnings/errors, with drivers being the largest abuser, not surprisingly.
Here's the sorted breakdown per top-level subsystem:

     32 usr
    162 init
    266 block
    293 Documentation
    471 ipc
    819 mm
   1115 security
   1915 scripts
   1948 kernel
   4569 lib
   4793 crypto
  13851 net
  80025 sound
  86484 include
 115789 arch
 116623 fs
1035158 drivers
-------+-------
1464313 TOTAL

Any volunteers? :-)


Erez Zadok (3):
      CHECKPATCH: update usage string for checkpatch.pl
      CHECKPATCH: add terse output option to checkpatch.pl
      CHECKFILES: new small shell script to check multiple source files

 checkfiles    |   34 ++++++++++++++++++++++++++++++++++
 checkpatch.pl |   21 +++++++++++++++++----
 2 files changed, 51 insertions(+), 4 deletions(-)

---
Erez Zadok
ezk@cs.sunysb.edu
