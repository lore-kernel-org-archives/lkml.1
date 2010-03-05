Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab0CEQ3L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 11:29:11 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:44691 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865Ab0CEQ3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 11:29:08 -0500
Date: Fri, 5 Mar 2010 16:29:08 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] vfs part 2
Message-ID: <20100305162907.GW30031@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Next part of VFS stuff: getting do_filp_open() to relative
sanity.  There will be more piles (the next one is dealing with
write_inode mess, in an hour or so).  Please, pull from 
git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

Shortlog:
Al Viro (18):
      beginning to untangle do_filp_open()
      gut do_filp_open() a bit more (do_last separation)
      Shift releasing nd->root from do_last() to its caller
      unroll do_last: loop in do_filp_open()
      postpone __putname() until after do_last()
      pull the common predecessors into do_last()
      bail out with ELOOP earlier in do_link loop
      pull more into do_last()
      Don't pass mangled open_flag to finish_open()
      Get rid of passing mangled flag to do_last()
      Leave mangled flag only for setting nd.intent.open.flag
      Pull handling of LAST_BIND into do_last(), clean up ok: part in do_filp_open()
      Kill is_link argument of do_last()
      Unify exits in O_CREAT handling
      Turn do_link spaghetty into a normal loop
      Finish pulling of -ESTALE handling to upper level in do_filp_open()
      Get rid of symlink body copying
      Switch !O_CREAT case to use of do_last()

Diffstat:
 fs/namei.c |  523 ++++++++++++++++++++++++++++++------------------------------
 1 files changed, 263 insertions(+), 260 deletions(-)
