Return-Path: <linux-kernel-owner+w=401wt.eu-S1752212AbXBFOwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbXBFOwk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 09:52:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbXBFOwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 09:52:40 -0500
Received: from wine.ocn.ne.jp ([220.111.47.146]:59034 "EHLO
	smtp.wine.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbXBFOwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 09:52:39 -0500
X-Greylist: delayed 1946 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Feb 2007 09:52:39 EST
To: chrisw@sous-sol.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [RFC 0/28] Patches to pass vfsmount to LSM inode security hooks
From: Tetsuo Handa <penguin-fsdevel@I-love.SAKURA.ne.jp>
References: <20070205182213.12164.40927.sendpatchset@ermintrude.int.wirex.com>
	<101270.11571.qm@web36602.mail.mud.yahoo.com>
	<20070205195058.GT10475@sequoia.sous-sol.org>
In-Reply-To: <20070205195058.GT10475@sequoia.sous-sol.org>
Message-Id: <200702062320.CCD91553.QFFFOVtGEJOMHTW@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50]
X-Accept-Language: ja,en
Date: Tue, 6 Feb 2007 23:20:13 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Jones wrote:
> The following are a set of patches the goal of which is to pass vfsmounts
> through select portions of the VFS layer sufficient to be visible to the LSM
> inode operation hooks.
I was looking forward to these patches for so long.

Chris Wright wrote:
> This kind of change (or perhaps
> straight to struct path) is definitely
> needed from AA.
Not only AppArmor, but also TOMOYO Linux needs these patches.

TOMOYO Linux is a pathname based access control patch like AppArmor.
http://lwn.net/Articles/165132/
I have been asked "Why not use LSM?" and the answer is always
"I can't, for VFS helper functions and LSM functions don't receive vfsmount."
and I am manually patching locations that call VFS helper functions.

But if these Tony's patches are accepted in upstream,
TOMOYO Linux would be able to use LSM.
I think these patches are also useful for auditing functions, for
auditing logs will be able to include absolute pathname
instead of partial pathname.
I think most people want access logs in the form of pathnames
rather than security labels.
