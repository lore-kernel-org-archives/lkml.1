Return-Path: <linux-kernel-owner+w=401wt.eu-S1755686AbYDZLCG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686AbYDZLCG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 07:02:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752291AbYDZLBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 07:01:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40000 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149AbYDZLBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 07:01:53 -0400
Date: Sat, 26 Apr 2008 13:01:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] VFS patches
Message-ID: <20080426110139.GA23867@elte.hu>
References: <20080426020221.GF5882@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080426020221.GF5882@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Al Viro <viro@ZenIV.linux.org.uk> wrote:

>      sanitize unshare_files/reset_files_struct

today's -git started crashing on me in randconfig boot tests:

[    0.124077] BUG: unable to handle kernel NULL pointer dereference at 00000296
[    0.126981] IP: [<c01217fb>] put_files_struct+0xb/0xa0
[    0.128981] *pdpt = 0000000000f73001 *pde = 0000000000000000
[    0.131231] Oops: 0002 [#1] PREEMPT

crash log and config at:

  http://redhat.com/~mingo/misc/log-Sat_Apr_26_11_20_58_CEST_2008.bad
  http://redhat.com/~mingo/misc/config-Sat_Apr_26_11_20_58_CEST_2008.bad

bisected it down to:

| 3b1253880b7a9e6db54b943b2d40bcf2202f58ab is first bad commit
| commit 3b1253880b7a9e6db54b943b2d40bcf2202f58ab
| Author: Al Viro <viro@zeniv.linux.org.uk>
| Date:   Tue Apr 22 05:31:30 2008 -0400
|
|     [PATCH] sanitize unshare_files/reset_files_struct

find the git-bisect log output below.

	Ingo

----------------->
git-bisect start
# bad: [b1721d0da266b4af8cb4419473b4ca36206ab200] v4l/dvb: add statics to avoid multiple definitions
git-bisect bad b1721d0da266b4af8cb4419473b4ca36206ab200
# bad: [cf2ec150fc5f59dbf2260863225c79aa0cfc46af] Merge branch 'for-linus' of git://linux-nfs.org/~bfields/linux
git-bisect bad cf2ec150fc5f59dbf2260863225c79aa0cfc46af
# good: [cf2ec150fc5f59dbf2260863225c79aa0cfc46af] Merge branch 'for-linus' of git://linux-nfs.org/~bfields/linux
git-bisect good cf2ec150fc5f59dbf2260863225c79aa0cfc46af
# good: [cf2ec150fc5f59dbf2260863225c79aa0cfc46af] Merge branch 'for-linus' of git://linux-nfs.org/~bfields/linux
git-bisect good cf2ec150fc5f59dbf2260863225c79aa0cfc46af
# bad: [b1721d0da266b4af8cb4419473b4ca36206ab200] v4l/dvb: add statics to avoid multiple definitions
git-bisect bad b1721d0da266b4af8cb4419473b4ca36206ab200
# good: [ad5e1b0f5d913d2c8bddfba81049cc07228da1a6] Merge git://git.kernel.org/pub/scm/linux/kernel/git/sam/kbuild
git-bisect good ad5e1b0f5d913d2c8bddfba81049cc07228da1a6
# good: [4953d141dc5db748475001cfbfdcc42e66cf900e] usb: don't update devnum for wusb devices
git-bisect good 4953d141dc5db748475001cfbfdcc42e66cf900e
# good: [bf16ae250999e76aff0491a362073a552db965fc] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86-pat
git-bisect good bf16ae250999e76aff0491a362073a552db965fc
# good: [6ec859e1b21ab42bfc36bb3b51db275480165c8a] [POWERPC] celleb: Consolidate io-workarounds code
git-bisect good 6ec859e1b21ab42bfc36bb3b51db275480165c8a
# good: [f360bf0015e5b3e82be61c68e0863b3f98852ee2] [POWERPC] Add zImage.iseries to arch/powerpc/boot/.gitignore
git-bisect good f360bf0015e5b3e82be61c68e0863b3f98852ee2
# good: [6e18933f2b6156d0a0ec9d5522ab6a6033cf7241] Merge branch 'release' of git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux-2.6
git-bisect good 6e18933f2b6156d0a0ec9d5522ab6a6033cf7241
# bad: [f8f95702f0c4529b0f59488f4509608f0c160e77] sanitize locate_fd()
git-bisect bad f8f95702f0c4529b0f59488f4509608f0c160e77
# good: [6b335d9c80d7f3c2a3f6545f664ae9007a0f3821] close race in unshare_files()
git-bisect good 6b335d9c80d7f3c2a3f6545f664ae9007a0f3821
# bad: [3b1253880b7a9e6db54b943b2d40bcf2202f58ab] sanitize unshare_files/reset_files_struct
git-bisect bad 3b1253880b7a9e6db54b943b2d40bcf2202f58ab
# good: [fd8328be874f4190a811c58cd4778ec2c74d2c05] sanitize handling of shared descriptor tables in failing execve()
git-bisect good fd8328be874f4190a811c58cd4778ec2c74d2c05

