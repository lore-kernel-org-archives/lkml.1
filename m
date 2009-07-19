Return-Path: <linux-kernel-owner+w=401wt.eu-S1751996AbZGSXtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996AbZGSXtT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 19:49:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916AbZGSXtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 19:49:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:56566 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585AbZGSXtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 19:49:15 -0400
Date: Sun, 19 Jul 2009 23:49:14 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.4.37.3
Message-ID: <20090719234914.GA3765@hera.kernel.org>
Reply-To: w@1wt.eu
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 19 Jul 2009 23:49:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linux 2.4.37.3 has just been released.

The main fixes are the addition of '-fno-delete-null-pointer-checks'
to gcc CFLAGS to prevent it from removing important checks and opening
security issues, and fixes to the r8169 driver in relation with
CVE-2009-1389. The rest are minor fixes for br2684, vlan and usb.

The addition of the gcc flag already revealed that it was previously
hiding a possible null dereference in journal.c (which is apparently
not the case, and 2.6 has removed the test). The rest of the code
needs to be compared with/without the option in order to track possible
dereference bugs hidden by default. The addition of this option will
not make the code more nor less stable, it just reduces the risk that
a bug normally causing an oops or panic would be maliciously exploited
to gain privileges.

The second major issue concerns the r8169 driver. Approximately one
month ago was revealed an issue with this driver, causing kernel
panics and possibly more if too large frames were sent to the chip
(CVE-2009-1389). 2.4 was not affected by the bug, but showed the
same symptoms. It turned out that there were multiple issues with
the setting of RX descriptors after reuse, and some recent 2.6
fixes allowing automatic recovery were missing. So after two long
days trying to figure out why that damn chip insisted in writing
more bytes than allowed (and crashing my box), I could spot and
fix the issues.

If there are 2.4 users with this cheap NIC, I strongly suggest that
they upgrade, especially if they're used to encounter freezes or
lack of network connectivity once in a while ; for others, well, do
not buy that NIC.

Last, while reviewing gcc flags, I might have found a solution to
make gcc 4.2 produce correct code on 2.4. There's nothing certain
yet, I still have to run a lot of tests. Volunteers are welcome,
as usual.

The patch and changelog will appear soon at the following locations:
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/patch-2.4.37.3.bz2
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/ChangeLog-2.4.37.3

Git repository:
   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.4.37.y.git
  http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.4.37.y.git

Git repository through the gitweb interface:
  http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.4.37.y.git

Willy
--

Summary of changes from v2.4.37.2 to v2.4.37.3
============================================

Arne Redlich (2):
      vlan: Slab memleak fix
      br2684: allocation out of atomic context

Eugene Teo (1):
      Add '-fno-delete-null-pointer-checks' to gcc CFLAGS

Frank Seidel (1):
      br2684: fix double freeing skb

Mario Witkowski (1):
      usb: pr_debug ehci structure bug

Rudolf Svanda (1):
      usb: Add support for Teac HD-35PU

Willy Tarreau (7):
      r8169: fix erroneous receive packet size settings
      r8169: reject fragmented frames to prevent panics with large frames
      r8169: avoid rx descriptors leak when receiving erroneous frames
      r8169: reset the chip on receive fifo overflows
      r8169: rate-limit the messages displayed in interrupt context
      lib: export memcmp for external modules to build with gcc 3.4
      Change VERSION to 2.4.37.3

serue@us.ibm.com (1):
      agp: remove uid comparison as security check

