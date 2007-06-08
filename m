Return-Path: <linux-kernel-owner+w=401wt.eu-S966536AbXFHHDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966536AbXFHHDV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762331AbXFHHDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:03:12 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:36171 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762074AbXFHHDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:03:11 -0400
Date: Fri, 8 Jun 2007 00:02:48 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.21.4
Message-ID: <20070608070248.GN3723@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.21.4 kernel.
This release has three security fixes in it:
 
374f167d: random: fix error in entropy extraction (CVE-2007-2453 1 of 2)
7bd369b1: random: fix seeding with zero entropy (CVE-2007-2453 2 of 2)
c23e7e4c: cpuset: prevent information leak in cpuset_tasks_read (CVE-2007-2875)
8c640bd0: NETFILTER: {ip, nf}_conntrack_sctp: fix remotely triggerable NULL ptr dereference (CVE-2007-2876)

The /dev/[u]random fix is especially important for machines with no
entropy source (e.g. keyboard, mice, or disk drives) and no realtime clock
since successive boots could generate same output from RNG.  The cpuset
bug is a possible information leak when reading from /dev/cpuset/tasks
(assuming cpusets support is compiled in and the cpuset fs mounted
on /dev/cpuset).  The SCTP bug is remotely triggerable when using SCTP
conntrack.


I'll also be replying to this message with a copy of the patch between
2.6.21.3 and 2.6.21.4

The updated 2.6.21.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.21.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.21.y.git;a=summary

thanks,
-chris

---------

 Makefile                                     |    2 
 drivers/char/random.c                        |   67 +++++++++++++++------------
 kernel/cpuset.c                              |    7 --
 net/ipv4/netfilter/ip_conntrack_proto_sctp.c |    3 -
 net/netfilter/nf_conntrack_proto_sctp.c      |    3 -
 5 files changed, 44 insertions(+), 38 deletions(-)

Summary of changes from v2.6.21.3 to v2.6.21.4
==============================================

Chris Wright (2):
      cpuset: prevent information leak in cpuset_tasks_read (CVE-2007-2875)
      Linux 2.6.21.4

Matt Mackall (2):
      random: fix error in entropy extraction (CVE-2007-2453 1 of 2)
      random: fix seeding with zero entropy (CVE-2007-2453 2 of 2)

Patrick McHardy (1):
      NETFILTER: {ip, nf}_conntrack_sctp: fix remotely triggerable NULL ptr dereference (CVE-2007-2876)

