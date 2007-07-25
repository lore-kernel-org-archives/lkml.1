Return-Path: <linux-kernel-owner+w=401wt.eu-S932725AbXGYQfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932725AbXGYQfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 12:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763058AbXGYQfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 12:35:38 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:1344 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762679AbXGYQfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 12:35:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=E7xgEaCTiJrd3Cd9/pJh6nayALXOzjzzr1qJ7fN00laIWBEarY7mOPoz5bFSLLxb8I8vp4/XK3K7m2lt4PmjqN/oqQ77rh571mkm79d9U460XUEi8gbpwncJluLXnnEA6k2oxPn5B9tTCXYd3scxdpaFQ8PFJVzkgncW4MyE/Bc=
Message-ID: <46A77B3A.8080503@googlemail.com>
Date: Wed, 25 Jul 2007 18:32:58 +0200
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org
Subject: Re: 2.6.23-rc1-mm1
References: <20070725040304.111550f4.akpm@linux-foundation.org>
In-Reply-To: <20070725040304.111550f4.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton pisze:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc1/2.6.23-rc1-mm1/
> 

nokturn vs. reiserfs 1:0

[ 1228.964379] =============================================
[ 1228.971271] [ INFO: possible recursive locking detected ]
[ 1228.976674] 2.6.23-rc1-mm1 #1
[ 1228.979655] ---------------------------------------------
[ 1228.985064] chcon/21470 is trying to acquire lock:
[ 1228.989858]  (&inode->i_mutex){--..}, at: [<c06993ea>] mutex_lock+0x1c/0x1f
[ 1228.996968] 
[ 1228.996972] but task is already holding lock:
[ 1229.002834]  (&inode->i_mutex){--..}, at: [<c06993ea>] mutex_lock+0x1c/0x1f
[ 1229.009958] 
[ 1229.009962] other info that might help us debug this:
[ 1229.016510] 3 locks held by chcon/21470:
[ 1229.020434]  #0:  (&inode->i_mutex){--..}, at: [<c06993ea>] mutex_lock+0x1c/0x1f
[ 1229.027971]  #1:  (&REISERFS_I(inode)->xattr_sem){----}, at: [<fdd59d36>] reiserfs_setxattr+0x54/0xf2 [reiserfs]
[ 1229.038282]  #2:  (&REISERFS_SB(s)->xattr_dir_sem){----}, at: [<fdd59d55>] reiserfs_setxattr+0x73/0xf2 [reiserfs]
[ 1229.048682] 
[ 1229.048687] stack backtrace:
[ 1229.053070]  [<c04053eb>] show_trace_log_lvl+0x1a/0x30
[ 1229.058254]  [<c0406073>] show_trace+0x12/0x14
[ 1229.062734]  [<c04061a8>] dump_stack+0x16/0x18
[ 1229.067222]  [<c044c887>] __lock_acquire+0xe19/0x125c
[ 1229.072309]  [<c044cd71>] lock_acquire+0xa7/0xc1
[ 1229.076967]  [<c069908e>] __mutex_lock_slowpath+0x9b/0x3db
[ 1229.082493]  [<c06993ea>] mutex_lock+0x1c/0x1f
[ 1229.086972]  [<fdd5a2d1>] reiserfs_xattr_set+0x14c/0x2db [reiserfs]
[ 1229.093281]  [<fdd5a7e2>] security_set+0x4d/0x51 [reiserfs]
[ 1229.098898]  [<fdd59d6d>] reiserfs_setxattr+0x8b/0xf2 [reiserfs]
[ 1229.104950]  [<c04aee43>] vfs_setxattr+0x8a/0x199
[ 1229.109696]  [<c04aefcf>] setxattr+0x7d/0x109
[ 1229.114087]  [<c04af0ec>] sys_setxattr+0x41/0x53
[ 1229.118737]  [<c04043ba>] syscall_call+0x7/0xb
[ 1229.123215]  =======================
[ 1229.249502] chcon used greatest stack depth: 1080 bytes left

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.23-rc1-mm1/console.log
http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.23-rc1-mm1/mm-config

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
