Return-Path: <linux-kernel-owner+w=401wt.eu-S1757975AbXFZXKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975AbXFZXKM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 19:10:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757206AbXFZXJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 19:09:50 -0400
Received: from cantor.suse.de ([195.135.220.2]:42873 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754974AbXFZXJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 19:09:49 -0400
Message-Id: <20070626230756.519733902@suse.de>
User-Agent: quilt/0.46-14
Date: Tue, 26 Jun 2007 16:07:56 -0700
From: jjohansen@suse.de
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: [AppArmor 00/44] AppArmor security module overview
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This post contains patches to include the AppArmor application security
framework, with request for inclusion into -mm for wider testing.

These patches are currently against lkml but we will gladly rebase them
against -mm so that they will apply cleanly.

Any comments and feedback to improve implementation are appreciated.

A second post dealing with the issue of passing NULL nameidata, will be
posted to lkml for discussion.

Changes since previous post:
- remove custom pathname mangling
- rework apparmor auditing to cleanup message formating and better
  use audit framework
- change permission consistency checks from runtime to once at policy load
- add change_profile feature and cleanup change_hat to use change_profile

The patch series consists of five areas:

 (1) Pass struct vfsmount through to LSM hooks.

 (2) Fixes and improvements to __d_path():

     (a) make it unambiguous and exclude unreachable paths from
         /proc/mounts,

     (b) make its result consistent in the face of remounts,

     (c) introduce d_namespace_path(), a variant of d_path that goes up
         to the namespace root instead of the chroot.

     (d) the behavior of d_path() and getcwd() remain unchanged, and
     there is no hidding of unreachable paths in /proc/mounts.  The
     patches addressing these have been seperated from the AppArmor
     submission and will be introduced at a later date.
 
     Part (a) has been in the -mm tree for a while; this series includes
     an updated copy of the -mm patch. Parts (b) and (c) shouldn't be too
     controversial.

 (3) Be able to distinguish file descriptor access from access by name
     in LSM hooks.

     Applications expect different behavior from file descriptor
     accesses and accesses by name in some cases. We need to pass this
     information down the LSM hooks to allow AppArmor to tell which is
     which.

 (4) Convert the selinux sysctl pathname computation code into a standalone
     function.

 (5) The AppArmor LSM itself.

     (See below.)

A tarball of the kernel patches, base user-space utilities, example
profiles, and technical documentation (including a walk-through) are
available at:

  http://forgeftp.novell.com//apparmor/LKML_Submission-June-07/

Explaining the AppArmor design in detail would take by far too much
space here, so let me refer you to the technical documentation for that.
Included is a low-level walk-through of the system and basic tools, and
some examples.  The manual pages included in the apparmor-parser package
are worth a read as well.
-- 
