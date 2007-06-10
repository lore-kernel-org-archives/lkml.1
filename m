Return-Path: <linux-kernel-owner+w=401wt.eu-S932073AbXFJW4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073AbXFJW4t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 18:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760205AbXFJW4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 18:56:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36228 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759215AbXFJW4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 18:56:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: 2.6.22-rc4-mm2: GPF during suspend to RAM on HPC nx6325
Date: Mon, 11 Jun 2007 01:02:52 +0200
User-Agent: KMail/1.9.5
Cc: Greg KH <greg@kroah.com>, Tejun Heo <htejun@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706110102.52946.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

gregkh-driver-sysfs-use-singly-linked-list-for-sysfs_dirent-tree.patch breaks
suspend to RAM on HPC nx6325 (x86_64).

With this patch applied I get a general protection fault in mutex_lock+0x15
(kernel/mutex.c:91), called by sysfs_hash_and_remove() (fs/sysfs/inode.c:298),
called by threshold_cpu_callback(), called from _cpu_down().

Without the patch, the suspend to RAM works (the resume doesn't - there is
another patch that prevents the video from being restored after the resume -
but I'll carry out the bisection tomorrow. ;-)]

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
