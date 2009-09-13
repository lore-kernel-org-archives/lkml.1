Return-Path: <linux-kernel-owner+w=401wt.eu-S1752613AbZIMJ73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbZIMJ73 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 05:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751627AbZIMJ70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 05:59:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:47440 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033AbZIMJ70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 05:59:26 -0400
Date: Sun, 13 Sep 2009 09:59:28 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.4.37.6
Message-ID: <20090913095928.GA23158@hera.kernel.org>
Reply-To: w@1wt.eu
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 13 Sep 2009 09:59:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've just released Linux 2.4.37.6.

This version focuses on various vulnerabilities causing information
leaks to user processes. I would personally call them minor since at
most a few bytes per call or another task's pointer can be can be
collected. Still, those were fixed in 2.6 so it's better to have 2.4
at the same level. Most of them are recent, except the proc/pid/maps
which I missed one year ago and the netlink padding issue which was
fixed 4 years ago.

Most of them have CVE numbers assigned but I forgot to check them
while committing. I don't think users are reading them that much
anyway.

If you don't know whether you need to upgrade, it's simple : if you're
running something older than 2.4.37.5, you're potentially at risk so
you should upgrade anyway. If you have untrusted local users, I would
recommend you to upgrade. Otherwise you can wait for a more sensible
update.

The patch and changelog will appear soon at the following locations:
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/patch-2.4.37.6.bz2
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/ChangeLog-2.4.37.6

Git repository:
   git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.4.37.y.git
  http://www.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.4.37.y.git

Git repository through the gitweb interface:
  http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.4.37.y.git


Willy

--
Summary of changes from v2.4.37.5 to v2.4.37.6
============================================

Eric Dumazet (6):
      tc: Fix unitialized kernel memory leak
      appletalk: fix atalk_getname() leak
      econet: Fix econet_getname() leak
      irda: Fix irda_getname() leak
      netrom: Fix nr_getname() leak
      rose: Fix rose_getname() leak

Jake Edge (1):
      proc: avoid information leaks to non-privileged processes

Linus Torvalds (1):
      do_sigaltstack: avoid copying 'stack_t' as a structure to user space

Patrick McHardy (3):
      [NETLINK]: Missing initializations in dumped data
      [NETLINK]: Clear padding in netlink messages
      [NETLINK]: Missing padding fields in dumped structures

Willy Tarreau (2):
      restrict reading from /proc/<pid>/maps to those who share ->mm or can ptrace pid
      Change VERSION to 2.4.37.6

