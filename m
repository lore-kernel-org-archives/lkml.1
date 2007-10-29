Return-Path: <linux-kernel-owner+w=401wt.eu-S1757473AbXJ2PZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473AbXJ2PZP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 11:25:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756658AbXJ2PZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 11:25:00 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:60602 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007AbXJ2PY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 11:24:59 -0400
Message-ID: <4725FB46.70802@tiscali.nl>
Date: Mon, 29 Oct 2007 16:24:54 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: build failure, missing libvdeplug.h?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Building uml with an allyesconfig and a few changes in UML only fails with:

...
  CC      arch/um/drivers/vde_user.o
/home/roel/dnld/src/kernel/git/linux-2.6/arch/um/drivers/vde_user.c:8:24: error: libvdeplug.h: No such file or directory
/home/roel/dnld/src/kernel/git/linux-2.6/arch/um/drivers/vde_user.c: In function 'vde_user_init':
/home/roel/dnld/src/kernel/git/linux-2.6/arch/um/drivers/vde_user.c:18: error: 'VDECONN' undeclared (first use in this function)
...

the file libvdeplug.h is missing and I can't find it neither in the tree or on
the net. 'git-grep VDECONN' shows that VDECONN isn't defined anywhere.

this code was added in this commit:

--
commit ad43c3565bebada7e5a13288e37542fd940369e8
Author: Jeff Dike <jdike@addtoit.com>
Date:   Tue Oct 16 01:26:48 2007 -0700

    uml: add VDE networking support

    Added vde network backend in uml to introduce native Virtual Distributed
    Ethernet support (using libvdeplug).

    Signed-off-by: Luca Bigliardi <shammash@artha.org>
    Signed-off-by: Jeff Dike <jdike@linux.intel.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
--

There is a reference to http://wiki.virtualsquare.org/index.php/Main_Page in
the Kconfig (also added by this commit).
After reverting this commit the build continues. possibly the header 
libvdeplug.h was forgotten?

Roel
