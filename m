Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab0CCOqI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 09:46:08 -0500
Received: from thunk.org ([69.25.196.29]:33484 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754467Ab0CCOqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 09:46:06 -0500
To: linux-kernel@vger.kernel.org, lvm-devel@redhat.com
Subject: [REGRESSION] Can't boot lvm on root (Ubuntu 9.10 userspace) with 2.6.33
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
Message-Id: <E1Nmppq-0000sA-E1@closure.thunk.org>
Date: Wed, 03 Mar 2010 09:46:02 -0500
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The last kernel I could boot was 2.6.33-rc4, so this might be a
regression.   As near as I can tell, this udev rule isn't firing:

SUBSYSTEM=="block", ACTION=="add|change", ENV{ID_FS_TYPE}=="lvm*|LVM*", \
	RUN+="watershed sh -c '/sbin/lvm vgscan; /sbin/lvm vgchange -a y'"

So nothing is showing up in /dev/mapper, and so the root can't be
mounted.  After 45 seconds, it drops me into the initramfs shell, and if
I manually run "lvm vgscan" and "lvm vgscange -ay", everything is back,
but then I can't figure out how to restart the boot process from inside
a failed initramfs.   And of course, the initramfs environment is so
crappy that there are no debugging aids --- not even a working pager.

Did I mention how much I hate the whole initramfs with dynamic udev
rules as a design?

I'll probably kludge some kind of "sleep 10; lvm vgscan ; lvm vgchange
-ay" into some local initramfs script, but it would be nice to know what
happened and what the real right fix should be.  Did anything change
recently that might have caused this to fail?

						- Ted
