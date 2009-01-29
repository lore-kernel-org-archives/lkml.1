Return-Path: <linux-kernel-owner+w=401wt.eu-S1756164AbZA2KQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbZA2KQs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 05:16:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752268AbZA2KQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 05:16:35 -0500
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]:42945 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbZA2KQe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 05:16:34 -0500
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Subject: [ANNOUNCE] GIT 1.6.1.2
cc: linux-kernel@vger.kernel.org
Date: Thu, 29 Jan 2009 02:16:25 -0800
Message-ID: <7vtz7ifmdi.fsf@gitster.siamese.dyndns.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Pobox-Relay-ID: E7257C48-EDED-11DD-AF4E-CC4CC92D7133-77302942!a-sasl-fastnet.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release GIT 1.6.1.2 is available at the
usual places:

  http://www.kernel.org/pub/software/scm/git/

  git-1.6.1.2.tar.{gz,bz2}			(source tarball)
  git-htmldocs-1.6.1.2.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.6.1.2.tar.{gz,bz2}		(preformatted docs)

The RPM binary packages for a few architectures are also provided
as courtesy.

  RPMS/$arch/git-*-1.6.1.2-1.fc9.$arch.rpm	(RPM)

People with 1.6.1 or 1.6.1.1, who push into a repository that borrows
objects from other repositories via "alternates" mechanism (most of the
linux kernel subsystems hosted on k.org, and "forks" on various public
hosting site such as repo.or.cz and github fall into this category), may
want to upgrade to this version, as these two versions have a buggy "git
push" that does not like such a repository served by git 1.6.1 or newer.


GIT v1.6.1.2 Release Notes
==========================

Fixes since v1.6.1.1
--------------------

* The logic for rename detectin in internal diff used by commands like
  "git diff" and "git blame" have been optimized to avoid loading the same
  blob repeatedly.

* We did not allow writing out a blob that is larger than 2GB for no good
  reason.

* "git format-patch -o $dir", when $dir is a relative directory, used it
  as relative to the root of the work tree, not relative to the current
  directory.

* v1.6.1 introduced an optimization for "git push" into a repository (A)
  that borrows its objects from another repository (B) to avoid sending
  objects that are available in repository B, when they are not yet used
  by repository A.  However the code on the "git push" sender side was
  buggy and did not work when repository B had new objects that are not
  known by the sender.  This caused pushing into a "forked" repository
  served by v1.6.1 software using "git push" from v1.6.1 sometimes did not
  work.  The bug was purely on the "git push" sender side, and has been
  corrected.

* "git status -v" did not paint its diff output in colour even when
  color.ui configuration was set.

* "git ls-tree" learned --full-tree option to help Porcelain scripts that
  want to always see the full path regardless of the current working
  directory.

* "git grep" incorrectly searched in work tree paths even when they are
  marked as assume-unchanged.  It now searches in the index entries.

* "git gc" with no grace period needlessly ejected packed but unreachable
  objects in their loose form, only to delete them right away.

----------------------------------------------------------------

Changes since v1.6.1.1 are as follows:

Björn Steinbrink (1):
      Rename detection: Avoid repeated filespec population

Jeff King (1):
      avoid 31-bit truncation in write_loose_object

Johannes Schindelin (2):
      get_sha1_basic(): fix invalid memory access, found by valgrind
      test-path-utils: Fix off by one, found by valgrind

Junio C Hamano (4):
      ls-tree: add --full-tree option
      Teach format-patch to handle output directory relative to cwd
      send-pack: do not send unknown object name from ".have" to pack-objects
      GIT 1.6.1.2

Marcel M. Cary (1):
      git-sh-setup: Fix scripts whose PWD is a symlink to a work-dir on OS X

Markus Heidelberg (2):
      git-commit: color status output when color.ui is set
      git-status -v: color diff output when color.ui is set

Nanako Shiraishi (1):
      Document git-ls-tree --full-tree

Nguyễn Thái Ngọc Duy (2):
      grep: support --no-ext-grep to test builtin grep
      grep: grep cache entries if they are "assume unchanged"

Nicolas Pitre (1):
      objects to be pruned immediately don't have to be loosened

