Return-Path: <linux-kernel-owner+w=401wt.eu-S1757214AbYCARHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214AbYCARHi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 12:07:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbYCARH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 12:07:29 -0500
Received: from mga02.intel.com ([134.134.136.20]:2192 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030AbYCARH2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 12:07:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,432,1199692800"; 
   d="scan'208";a="348309026"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: CLONE_NEWNS and bind mounts to make "chroot" jail
Date: Sat, 1 Mar 2008 09:05:18 -0800
Message-ID: <645B0EE4078B7C49A6C12F5E7B3B6C2603D3D607@orsmsx418.amr.corp.intel.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: CLONE_NEWNS and bind mounts to make "chroot" jail
thread-index: Ach7vm0Hz/4QqS9NQ7OQ6d8lqCgz2g==
From: "Leibowitz, Michael" <michael.leibowitz@intel.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 01 Mar 2008 17:05:19.0272 (UTC) FILETIME=[6D97B280:01C87BBE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have been trying to use the combination of CLONE_NEWNS and bind mounts
to create a better (than) chroot jail.  I wish to have the ability to
bind (ro will be possible in the future, I understand) certain
directories into the jail (perhaps /bin, /lib, /usr), but not have
parallel directories in the jail (no /etc, ..., /home). 

I have heard that this should be possible, but have yet to get a working
solution.

I have tried something analogous to:
chdir("/jail");
unshare(CLONE_NEWNS);
/* mount(8) syntax given for simplicity, but mount(2) used below */
mount --bind / /jail/old_root
mount --bind /jail/old_root/bin /jail/bin
mount --bind /jail/old_root/usr /jail/usr
mount --bind /jail/old_root/lib /jail/lib
mount --bind /jail /               # does nothing?
umount2("/old_root", MNT_DETACH);  # never happens.
exec("bin/sh");

When bin/sh runs, I can still see old_root from /jail and the bind of
/jail over / seems to have not done anything.  

Is it possible to create such a jail with bind mounts?  Is there a
recommended method for doing so?  Thank you for your time.

--
Michael Leibowitz
Software Engineer, UMG
Intel Corporation
michael.leibowitz at intel.com


