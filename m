Return-Path: <linux-kernel-owner+w=401wt.eu-S1756864AbZKJQNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864AbZKJQNG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 11:13:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756828AbZKJQNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 11:13:05 -0500
Received: from adelie.canonical.com ([91.189.90.139]:59708 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756771AbZKJQNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 11:13:04 -0500
From: John Johansen <john.johansen@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Subject: [AppArmor #3 0/12] AppArmor security module
Date: Tue, 10 Nov 2009 08:12:53 -0800
Message-Id: <1257869585-7092-1-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the newest version of the AppArmor security module it has been
rewritten to use the security_path hooks instead of the previous vfs
approach.  The current implementation is aimed at being as semantically
close to previous versions of AppArmor as possible while using the
existing LSM infrastructure.

The rewrite is functional and roughly equivalent to previous versions
of AppArmor based off of vfs patching.  Development is on going and
improvements to file, capability, network, resource usage and ipc mediation
are planned.

_Issues NOT currently addressed and will be address in the next post_
* AppArmor audit framework has not yet been updated as suggested by
  Eric Paris in
  http://marc.info/?l=linux-security-module&m=125778105017307&w=2
* AppArmor mmap_min_addr is broken and needs to be fixed as pointed out by
  Eric Paris in
  http://marc.info/?l=linux-security-module&m=125778004815241&w=2

_Issues Addressed Since Last Time AppArmor was Posted_
* Implemented change recommended by Tetsuo Handa in feedback:
   http://marc.info/?l=linux-security-module&m=125730973023168&w=2
   http://marc.info/?l=linux-security-module&m=125740018700307&w=2
   - removed read head reset in policy_unpack
   - added addition comments on locking, refcounting, and memory allocation
   - reworked ref counting some so that more references are held explicitly
   - drop dead/unreachable code
   - fix oops in putting caps cache cpu_local var
   - fix refcounting bug causing leak of creds
   - reworked __d_path race detection and removal of (deleted) string
* fixed bug in nameresolution failure in apparmor_bprm_set_creds that could
  cause a null pointer dereference oops
* fix bug in removal of child profiles that would lead to null pointer
  dereference oops.  Cleaned up code and removed dead portions
* rework filter and newest profile cleaning them up after changes made for
  above removal bug.
* Cleanup namespace code, removing unused fns and adding addition comments
* move profile load/replace/remove routines from policy_unpack.c to policy.c
  this allowed cleaning up the interface, allowing for more core policy
  functions to be static, and also allows policy_unpack to only contain
  unpack code.


AppArmor documentation can currently be found at
  http://developer.novell.com/wiki/index.php/Apparmor

The unflattened AppArmor git tree can be found at
  git://kernel.ubuntu.com/jj/apparmor-mainline.git


The AppArmor project is currently in transition and will be moving
away from Novell forge.  The current upstream for the AppArmor tools
can be found at
  https://launchpad.net/apparmor

The final location of the documentation and mailing lists have
not been determined and will be updated when known.


