Return-Path: <linux-kernel-owner+w=401wt.eu-S1754006AbYI0C2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006AbYI0C2n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 22:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751772AbYI0C2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 22:28:11 -0400
Received: from igw2.watson.ibm.com ([129.34.20.6]:54590 "EHLO
	igw2.watson.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbYI0C2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 22:28:08 -0400
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Subject: [PATCH 0/6] file capabilities cleanups: introduction
Date: Fri, 26 Sep 2008 22:27:44 -0400
Message-Id: <1222482472-12847-1-git-send-email-serue@us.ibm.com>
X-Mailer: git-send-email 1.6.0.2.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Following is a set of file capabilities cleanups.  The first
two patches are a repost of my previous patches which
introduce a no_file_caps boot option, and remove the
CONFIG_SECURITY_FILE_CAPABILITIES config option.  The rest
of the patches both clean up some of the capabilities code
and reduce the kernel size (since enabling file capabilities
grew it).

Andrew Morgan, if you have a moment, please do take a close look
and make sure I'm not doing anything stupid/wrong in the cleanups!
However ltp shows no difference with and without the patchset.

Following are the kernel sizes after some of the patches.

original, pre-patch, with file capabilities compiled out:
   text    data     bss     dec     hex filename
4188468  234432  316472 4739372  48512c vmlinux

original, pre-patch, with file capabilities compiled in:
4189356  234432  316472 4740260  4854a4 vmlinux

plain with fcaps always-on:
4189392  234456  316472 4740320  4854e0 vmlinux

with non-inline cap_safe_nice:
4189112  234456  316472 4740040  4853c8 vmlinux

with cleaned-up setcap:
4189120  234456  316472 4740048  4853d0 vmlinux

with needless check for target!=current removed from cap_capset:
4189104  234456  316472 4740032  4853c0 vmlinux

with needless(?) bprm_clear_caps calls removed:
4189088  234456  316472 4740016  4853b0 vmlinux


thanks,
-serge
