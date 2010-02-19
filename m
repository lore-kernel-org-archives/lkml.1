Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653Ab0BSJgl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 04:36:41 -0500
Received: from adelie.canonical.com ([91.189.90.139]:43531 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab0BSJgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 04:36:37 -0500
From: john.johansen@canonical.com
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Subject: [AppArmor #4 0/12] AppArmor security module
Date: Fri, 19 Feb 2010 01:36:16 -0800
Message-Id: <1266572188-26529-1-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the foruth general posting of the newest version of the
AppArmor security module it has been rewritten to use the security_path
hooks instead of the previous vfs approach.  The current implementation
is aimed at being as semantically close to previous versions of AppArmor
as possible while using the existing LSM infrastructure.

The rewrite is functional and roughly equivalent to previous versions
of AppArmor based off of vfs patching.  Development is on going and
improvements to file, capability, network, resource usage and ipc mediation
are planned.

_Issues NOT currently addressed and will be address in the next post_
* The full conversion of AppArmor audit framework has not yet been updated
 as suggested by
  Eric Paris in
  http://marc.info/?l=linux-security-module&m=125778105017307&w=2
* The user space interface CONFIG_APPARMOR_COMPAT_24 has not been removed,
  as the replacement interface isn't ready yet.  It will become a separate
  patch that distros can carry to provide backwards compatibility.


_Issues Addressed Since Last Time AppArmor was Posted_
* The majority of issues raised from the previous posting have been
  addressed.  Those that weren't are waiting on the completion of the
  two major items addressed above.
* The dfa code was fully separated from the rest of the AppArmor code
  generalizing it so that it could be used by other projects.
* mixed use of NULL of null and unconfined profiles to mean unconfined
  has been removed.  This lead to some significant cleanups that
  makes the code smaller and easier to read.
* the task_context has been cleaned up and the context_group has been
  removed.  This lead to several cleanups in the code.  The functionality
  of the context_group will be reintroduced later with a newer more
  generic implementation.
* Provide full basic implementation of hierarchial Profile namespaces.
  The profile namespace code existed before but it was in a half finished
  experimental state.  It wasn't hierarchical and had other issues.
  Move to root namespace instead of default namespace and get rid of the
  ns_list_lock.

  This necessitated an updating of the locking, which remains course
  at the profile namespace level.  The unused lock from the profile was
  removed and a couple locking bugs were discovered in the process and
  fixed.  The auto removal of unused null learning profiles has been
  removed until the profile lists have been converted over to RCU lists.
* CAP_MAC_ADMIN is now used to control all policy manipulations
* The upack interface had several minor tweeks and comments cleanups
  The dfa permission checking was moved into it and made more rigourous.
* chmod and chown path mediation were reintroduced.
* d_namespace path was updated to make it more flexible providing better
  control of how pathnames are generated.
* merged interface_add_profile and interface_replace_profile as they
  were slight variation of each other
* Reworked domain code to not use error pointers
* removed incomplete set capability functionality.  It provided similar
  abilities as fscaps and pam_cap, which cover the majority of uses
  it was intended for.
* get_procattr code cleaned up and generalized
* full implementation of the change_hat interface added allowing specifying
  more than one potential targets reducing user space probing
* updated change_hat error codes, to match documentation
* update and rename policy_common struct to policy
* fixed a couple of oops in profile unpacking and verification
* update PROFILE_xxx macros to better reflect what they do
* Updated and expanded commenting on several functions


  A Detailed list of all changes and patches are available from the AppArmor
  git repository


The AppArmor project is has recently transitioned away from Novell forge.
Code and Documentation can be found at the following locations
* Documentation (early wip) - http://apparmor.wiki.kernel.org/
* User space tools -  https://launchpad.net/apparmor
* Kernel module -
  git://git.kernel.org/pub/scm/linux/kernel/git/jj/linux-apparmor.git

The location of the new mailing lists have not been finalized.

