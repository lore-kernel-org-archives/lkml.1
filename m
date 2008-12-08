Return-Path: <linux-kernel-owner+w=401wt.eu-S1755876AbYLHCOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876AbYLHCOW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 21:14:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753978AbYLHCOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 21:14:07 -0500
Received: from a-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.25]:44547 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952AbYLHCOE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 21:14:04 -0500
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Subject: [ANNOUNCE] GIT 1.6.0.5
cc: linux-kernel@vger.kernel.org
Date: Sun, 07 Dec 2008 18:13:56 -0800
Message-ID: <7vabb7ct23.fsf@gitster.siamese.dyndns.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Pobox-Relay-ID: E2163894-C4CD-11DD-B8DC-F83E113D384A-77302942!a-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release GIT 1.6.0.5 is available at the
usual places:

  http://www.kernel.org/pub/software/scm/git/

  git-1.6.0.5.tar.{gz,bz2}			(source tarball)
  git-htmldocs-1.6.0.5.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.6.0.5.tar.{gz,bz2}		(preformatted docs)

The RPM binary packages for a few architectures are also provided
as courtesy.

  RPMS/$arch/git-*-1.6.0.5-1.fc9.$arch.rpm	(RPM)

Although we are into 1.6.1-rc cycle, we have accumulated enough fixes to
warrant a new maintenance release, so here it is.

----------------------------------------------------------------

GIT v1.6.0.5 Release Notes
==========================

Fixes since v1.6.0.4
--------------------

* "git checkout" used to crash when your HEAD was pointing at a deleted
  branch.

* "git checkout" from an un-checked-out state did not allow switching out
  of the current branch.

* "git diff" always allowed GIT_EXTERNAL_DIFF and --no-ext-diff was no-op for
  the command.

* Giving 3 or more tree-ish to "git diff" is supposed to show the combined
  diff from second and subsequent trees to the first one, but the order was
  screwed up.

* "git fast-export" did not export all tags.

* "git ls-files --with-tree=<tree>" did not work with options other
  than -c, most notably with -m.

* "git pack-objects" did not make its best effort to honor --max-pack-size
  option when a single first object already busted the given limit and
  placed many objects in a single pack.

* "git-p4" fast import frontend was too eager to trigger its keyword expansion
  logic, even on a keyword-looking string that does not have closing '$' on the
  same line.

* "git push $there" when the remote $there is defined in $GIT_DIR/branches/$there
  behaves more like what cg-push from Cogito used to work.

* when giving up resolving a conflicted merge, "git reset --hard" failed
  to remove new paths from the working tree.

* "git tag" did not complain when given mutually incompatible set of options.

* The message constructed in the internal editor was discarded when "git
  tag -s" failed to sign the message, which was often caused by the user
  not configuring GPG correctly.

* "make check" cannot be run without sparse; people may have meant to say
  "make test" instead, so suggest that.

* Internal diff machinery had a corner case performance bug that choked on
  a large file with many repeated contents.

* "git repack" used to grab objects out of packs marked with .keep
  into a new pack.

* Many unsafe call to sprintf() style varargs functions are corrected.

* Also contains quite a few documentation updates.


----------------------------------------------------------------

Changes since v1.6.0.4 are as follows:

Alexandre Julliard (2):
      checkout: Don't crash when switching away from an invalid branch.
      git-submodule: Avoid printing a spurious message.

Brandon Casey (12):
      t7700: demonstrate mishandling of objects in packs with a .keep file
      packed_git: convert pack_local flag into a bitfield and add pack_keep
      pack-objects: new option --honor-pack-keep
      repack: don't repack local objects in packs with .keep file
      repack: do not fall back to incremental repacking with [-a|-A]
      builtin-gc.c: use new pack_keep bitfield to detect .keep file existence
      t7700: demonstrate mishandling of loose objects in an alternate ODB
      sha1_file.c: split has_loose_object() into local and non-local counterparts
      pack-objects: extend --local to mean ignore non-local loose objects too
      t7700: test that 'repack -a' packs alternate packed objects
      repack: only unpack-unreachable if we are deleting redundant packs
      revision.c: use proper data type in call to sizeof() within xrealloc

Bryan Drewery (1):
      Fix misleading wording for git-cherry-pick

Christian Couder (3):
      Documentation: rev-list: change a few instances of "git-cmd" to "git cmd"
      Documentation: bisect: change a few instances of "git-cmd" to "git cmd"
      Documentation: fix links to "everyday.html"

Daniel Lowe (1):
      Fix non-literal format in printf-style calls

Davide Libenzi (1):
      xdiff: give up scanning similar lines early

Jakub Narebski (1):
      gitweb: Make project specific override for 'grep' feature work

Jan Krüger (1):
      Documentation: git-svn: fix example for centralized SVN clone

Jeff King (2):
      commit: Fix stripping of patch in verbose mode.
      tag: delete TAG_EDITMSG only on successful tag

Joey Hess (1):
      sha1_file: avoid bogus "file exists" error message

Johannes Schindelin (1):
      fast-export: use an unsorted string list for extra_refs

Johannes Sixt (1):
      compat/mingw.c: Teach mingw_rename() to replace read-only files

Junio C Hamano (8):
      Makefile: help people who run 'make check' by mistake
      checkout: Fix "initial checkout" detection
      Start 1.6.0.5 cycle
      builtin-ls-files.c: coding style fix.
      Teach ls-files --with-tree=<tree> to work with options other than -c
      Teach "git diff" to honour --[no-]ext-diff
      Update draft release notes to 1.6.0.5
      GIT 1.6.0.5

Linus Torvalds (1):
      date/time: do not get confused by fractional seconds

Martin Koegler (1):
      git push: Interpret $GIT_DIR/branches in a Cogito compatible way

Matt Kraai (1):
      Remove the period after the git-check-attr summary

Matt McCutchen (3):
      config.txt: alphabetize configuration sections
      git checkout: don't warn about unborn branch if -f is already passed
      "git diff <tree>{3,}": do not reverse order of arguments

Miklos Vajna (3):
      Add new testcase to show fast-export does not always exports all tags
      User's Manual: remove duplicated url at the end of Appendix B
      http.c: use 'git_config_string' to get 'curl_http_proxy'

Nguyễn Thái Ngọc Duy (1):
      generate-cmdlist.sh: avoid selecting synopsis at wrong place

Nicolas Pitre (1):
      Fix pack.packSizeLimit and --max-pack-size handling

Pete Wyckoff (1):
      git-p4: fix keyword-expansion regex

Ralf Wildenhues (1):
      Fix typos in the documentation.

SZEDER Gábor (2):
      bash: remove dashed command leftovers
      bash: offer refs instead of filenames for 'git revert'

Sam Vilain (1):
      sha1_file.c: resolve confusion EACCES vs EPERM

Samuel Tardieu (2):
      tag: Check that options are only allowed in the appropriate mode
      tag: Add more tests about mixing incompatible modes and options

Stefan Naewe (2):
      git ls-remote: make usage string match manpage
      request-pull: make usage string match manpage

Thomas Rast (1):
      fetch-pack: Avoid memcpy() with src==dst

