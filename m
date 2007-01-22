Return-Path: <linux-kernel-owner+w=401wt.eu-S1751962AbXAVT2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbXAVT2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 14:28:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbXAVT2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 14:28:36 -0500
Received: from fed1rmmtao05.cox.net ([68.230.241.34]:59928 "EHLO
	fed1rmmtao05.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbXAVT2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 14:28:34 -0500
From: Junio C Hamano <junkio@cox.net>
To: Carl Worth <cworth@cworth.org>
Cc: git@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Announce] GIT v1.5.0-rc2
References: <7v64b04v2e.fsf@assigned-by-dhcp.cox.net>
	<7v3b6439uh.fsf@assigned-by-dhcp.cox.net>
	<87lkjvhr2c.wl%cworth@cworth.org>
Date: Mon, 22 Jan 2007 11:28:32 -0800
In-Reply-To: <87lkjvhr2c.wl%cworth@cworth.org> (Carl Worth's message of "Mon,
	22 Jan 2007 10:08:59 -0800")
Message-ID: <7vd556uahr.fsf@assigned-by-dhcp.cox.net>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your comments; the attached probably needs
proofreading.

The changes in response to the remainder of your comments are
quite straightforward and I do not think needs proofreading, so
I'll incorporate them and push the result out in 'todo'.

diff --git a/v1.5.0.txt b/v1.5.0.txt
index c0ff071..596bfd2 100644
--- a/v1.5.0.txt
+++ b/v1.5.0.txt
@@ -107,11 +107,40 @@ Updates in v1.5.0 since v1.4.4 series
    already comfortable with your workflow with the layout.
 
  - git-clone always uses what is known as "separate remote"
-   layout for a newly created repository with a working tree;
-   i.e. tracking branches in $GIT_DIR/refs/remotes/origin/ are
-   used to track branches from the origin, instead of
-   $GIT_DIR/refs/heads/, making the difference between remotely
-   tracked and local branches more obvious.
+   layout for a newly created repository with a working tree.
+
+   A repository with the separate remote layout starts with only
+   one default branch, 'master', to be used for your own
+   development.  Unlike the traditional layout that copied all
+   the upstream branches into your branch namespace (while
+   renaming their 'master' to your 'origin'), they are not made
+   into your branches.  Instead, they are kept track of using
+   'refs/remotes/origin/$upstream_branch_name'.
+
+   This layout keeps your own branch namespace less cluttered,
+   avoids name collision with your upstream, makes it possible
+   to automatically track new branches created at the remote
+   after you clone from it, and makes it easier to interact with
+   more than one remote repositories.  There might be some
+   surprises:
+
+   * 'git branch' does not show the branches from your upstream.
+     It only lists your own branches.  Use '-r' option to view
+     the tracking branches.
+
+   * If you are forking off of a branch obtained from the
+     upstream, you would have done something like 'git branch
+     my-next next', because traditional layout dropped the
+     tracking branch 'next' into your own branch namespace.
+     With the separate remote layout, you say 'git branch next
+     origin/next', which allows you to use the matching name
+     'next' for your own branch.  It also allows you to track a
+     remote other than 'origin' (i.e. where you initially cloned
+     from) and fork off of a branch from there the same way
+     (e.g. "git branch mingw j6t/master").
+
+   Repositories initialized with the traditional layout
+   continues to work (and will continue to work).
 
  - New branches that appear on the origin side after a clone is
    made are also tracked automatically.  This is done with an

