Return-Path: <linux-kernel-owner+w=401wt.eu-S1757919AbYFWIDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919AbYFWIDZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 04:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755637AbYFWICI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 04:02:08 -0400
Received: from mail.jambit.com ([62.245.207.83]:55854 "EHLO mail.jambit.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642AbYFWICE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 04:02:04 -0400
Message-ID: <485DFFB4.3080008@gmail.com>
Date: Sun, 22 Jun 2008 09:31:00 +0200
From: Michael Kerrisk <mtk.manpages@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Laurent Vivier <Laurent.Vivier@bull.net>
CC: Samuel Thibault <samuel.thibault@ens-lyon.org>, ap@zip.com.au,
       lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: /proc 2.6.24 changes for guest CPU accounting
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

A note and patch from Samuel alerted me to your commits
9ac52315d4cf5f561f36dabaf0720c00d3553162 and
5e84cfde51cf303d368fcb48f22059f37b3872de, which in 2.6.24 changed /proc/stat
and /proc/PID/stat.  Would you please CC me on kernel-userspace interface
changes, so that they have a chance of getting documented in man-pages.

(I see that Andrew P tried to get something added to
Documentation/filesystems/proc.txt, but that doesn't seem to have made it in.)

Below is a patch against the proc.5 man page by Samuel and I to document these
changes.  Do the changes look okay to you?  The first part is the change for
/proc/<pid>/stat, and the other is for /proc/stat.

Cheers,

Michael



===================================================================
--- proc.5      (revision 4046)
+++ proc.5      (working copy)
@@ -753,6 +753,13 @@
  .TP
  \fIdelayacct_blkio_ticks\fP %llu (since Linux 2.6.18)
  Aggregated block I/O delays, measured in clock ticks (centiseconds).
+.TP
+\fIguest_time\fP %lu (since Linux 2.6.24)
+Guest time of the process (time spent running a virtual CPU
+for a guest operating system), in centiseconds.
+.TP
+\fIcguest_time\fP %ld (since Linux 2.6.24)
+Guest time of the process's children, in centiseconds.
  .RE
  .TP
  .I /proc/[number]/statm
@@ -1510,6 +1517,12 @@
  .I steal
  \- stolen time, which is the time spent in other operating systems when
  running in a virtualized environment
+
+Since Linux 2.6.24, there is a ninth column,
+.IR guest ,
+which is the time spent running a virtual CPU for guest
+operating systems under teh control of the Linux kernel.
+.\" See Changelog entry for 5e84cfde51cf303d368fcb48f22059f37b3872de
  .TP
  \fIpage 5741 1808\fP
  The number of pages the system paged in and the number that were paged



