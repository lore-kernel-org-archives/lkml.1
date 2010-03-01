Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751015Ab0CAJIl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 04:08:41 -0500
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:59864 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab0CAJIj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 04:08:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=to:subject:from
	:date:message-id:mime-version:content-type
	:content-transfer-encoding; q=dns; s=sasl; b=RkYBUmCVyGb++WnT/ul
	1SamBQwkrEr2bxh7HctbwRnn7BzEQEjjl+/GpgIwQfKE0C+t1UsViNfDh1fXddoS
	pcdc7ZUGdSc1Xckqrq2OOXpDP3l5ov4HWjYapvZwMZrGWFAVbTyk1XB1JV+xPWqk
	VSoPmOSEr2XPlf6TY4LFL9Do=
To: git@vger.kernel.org
Subject: [ANNOUNCE] Git 1.7.0.1
From: Junio C Hamano <gitster@pobox.com>
Date: Mon, 01 Mar 2010 01:08:27 -0800
Message-ID: <7vfx4kxvck.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Pobox-Relay-ID: 03A48C36-2512-11DF-AE2B-D033EE7EF46B-77302942!a-pb-sasl-quonix.pobox.com
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release Git 1.7.0.1 is available at the
usual places:

  http://www.kernel.org/pub/software/scm/git/

  git-1.7.0.1.tar.{gz,bz2}			(source tarball)
  git-htmldocs-1.7.0.1.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.7.0.1.tar.{gz,bz2}		(preformatted docs)

The RPM binary packages for a few architectures are found in:

  RPMS/$arch/git-*-1.7.0.1-1.fc11.$arch.rpm	(RPM)

Git v1.7.0.1 Release Notes
==========================

Fixes since v1.7.0
------------------

 * In a freshly created repository "rev-parse HEAD^0" complained that
   it is dangling symref, even though "rev-parse HEAD" didn't.

 * "git show :no-such-name" tried to access the index without bounds
   check, leading to a potential segfault.

 * Message from "git cherry-pick" was harder to read and use than necessary
   when it stopped due to conflicting changes.

 * We referred to ".git/refs/" throughout the documentation when we
   meant to talk about abstract notion of "ref namespace".  Because
   people's repositories often have packed refs these days, this was
   confusing.

 * "git diff --output=/path/that/cannot/be/written" did not correctly
   error out.

 * "git grep -e -pattern-that-begin-with-dash paths..." could not be
   spelled as "git grep -- -pattern-that-begin-with-dash paths..." which
   would be a GNU way to use "--" as "end of options".

 * "git grep" compiled with threading support tried to access an
   uninitialized mutex on boxes with a single CPU.

 * "git stash pop -q --index" failed because the unnecessary --index
   option was propagated to "git stash drop" that is internally run at the
   end.

And other minor fixes and documentation updates.

----------------------------------------------------------------

Changes since v1.7.0 are as follows:

Bert Wesarg (2):
      Documentation: mention conflict marker size argument (%L) for merge driver
      rerere: fix memory leak if rerere images can't be read

Evan Powers (1):
      git-p4: fix bug in symlink handling

Jacob Helwig (1):
      Documentation: Fix indentation problem in git-commit(1)

Jeff King (9):
      accept "git grep -- pattern"
      cherry-pick: rewrap advice message
      cherry-pick: refactor commit parsing code
      cherry-pick: format help message as strbuf
      cherry-pick: show commit name instead of sha1
      cherry-pick: prettify the advice message
      dwim_ref: fix dangling symref warning
      docs: don't talk about $GIT_DIR/refs/ everywhere
      rm: fix bug in recursive subdirectory removal

Johannes Sixt (1):
      t3301-notes: insert a shbang line in ./fake_editor.sh

Jonathan Nieder (1):
      am: remove rebase-apply directory before gc

Junio C Hamano (6):
      Typofixes outside documentation area
      Start 1.7.0 maintenance track
      Fix use of mutex in threaded grep
      Prepare 1.7.0.1 release notes
      Update 1.7.0.1 release notes
      Git 1.7.0.1

Larry D'Anna (1):
      diff: make sure --output=/bad/path is caught

Mark Lodato (2):
      grep documentation: clarify what files match
      Remove reference to GREP_COLORS from documentation

Markus Heidelberg (1):
      sha1_name: fix segfault caused by invalid index access

Matt Kraai (1):
      commit: quote the user name in the example

Pete Harlan (1):
      Remove hyphen from "git-command" in two error messages

René Scharfe (1):
      fix minor memory leak in get_tree_entry()

Stephen Boyd (1):
      Documentation: describe --thin more accurately

Thomas Rast (2):
      stash pop: remove 'apply' options during 'drop' invocation
      t1450: fix testcases that were wrongly expecting failure

