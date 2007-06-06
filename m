Return-Path: <linux-kernel-owner+w=401wt.eu-S935219AbXFFUoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935219AbXFFUoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 16:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763601AbXFFUoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 16:44:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:42063 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbXFFUoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 16:44:05 -0400
Date: Wed, 6 Jun 2007 20:44:04 +0000
From: Willy Tarreau <wtarreau@hera.kernel.org>
To: linux-kernel@vger.kernel.org
Subject: Linux 2.4.35-pre5
Message-ID: <20070606204404.GA5708@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've just released Linux 2.4.35-pre5.

It contains two important fixes. One is a fix for a regression I
introduced when trying to fix CVE-2007-1353 (bluetooth), which
fortunately was noticed by Marcel Holtmann. Basically, I turned
a memory leak bug into a memory corruption bug :-(

The other fix is for a bug which was causing oopses when loading ide-disk
as a module. This problem was reported by Zbigniew Baniewski but its cause
was not obvious at all even after long debugging sessions. Finally, PaX
Team noticed that init_idle() is marked __init while (indirectly) called
by restinit() explicitly stating that it must not call __init functions.
Once the problem identified and explained, the obvious patch definitely
fixed the problem.

One of the remaining patches includes the fixes that LVM users
systematically have to apply to mainline kernels (except one which is
wrong). Other fixes are minor.

I will open -rc1 soon with the very few last pending updates, and I hope
to be able to release an unquestionably perfect 2.4.35 around the end
of this month :-)

So please, if you encounter any problems, it's the moment to complain
loudly. Please not that I have not recompiled this one since LVM changes. 

Regards,
Willy

--

The patch and changelog will appear soon at the following locations:
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/testing/
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/testing/patch-2.4.35-pre5.bz2
  ftp://ftp.kernel.org/pub/linux/kernel/v2.4/testing/patch-2.4.35.log

Git repository:
   git://git.kernel.org/pub/scm/linux/kernel/git/wtarreau/linux-2.4.git
  http://www.kernel.org/pub/scm/linux/kernel/git/wtarreau/linux-2.4.git/

Git repository through the gitweb interface:
  http://git.kernel.org/?p=linux/kernel/git/wtarreau/linux-2.4.git


Summary of changes from v2.4.35-pre4 to v2.4.35-pre5
============================================

Brian Maly (1):
      fix 'pc_keyb: controller jammed (0xA7)' error on systems with KVM

Willy Tarreau (7):
      do not mark init_idle() __init
      Bluetooth: correct fix for CVE-2007-1353
      [BACKPORT] Bluetooth: Fix NULL pointer dereference in HCI line discipline
      [BACKPORT] Bluetooth: Fix unintentional fall-through in HCI line discipline
      lvm: update to latest fixes from the LVM package
      lvm: do not update extent count if snapshot allocation fails
      Change VERSION to 2.4.35-pre5

