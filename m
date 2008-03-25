Return-Path: <linux-kernel-owner+w=401wt.eu-S1758009AbYCYSUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009AbYCYSUV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 14:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753553AbYCYSUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 14:20:08 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:47845 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211AbYCYSUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 14:20:07 -0400
Date: Tue, 25 Mar 2008 19:20:06 +0100
From: Jan Kara <jack@suse.cz>
To: Cesar Suga <sartre@linuxbr.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: BUG: at fs/inotify.c:182 set_dentry_child_flags() - second
Message-ID: <20080325182006.GC21732@atrey.karlin.mff.cuni.cz>
References: <47E1A935.9030705@linuxbr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47E1A935.9030705@linuxbr.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

> I second Patrick McLean's e-mail from 2007/02/27.
> 
> Patrick also said he was using nfsd at that point.
> 
> WARNING: at fs/inotify.c:182 set_dentry_child_flags()
> Pid: 19103, comm: gam_server Tainted: P        2.6.24.3-smp #1
> [<c01a2087>] set_dentry_child_flags+0x127/0x160
> [<c01a2110>] remove_watch_no_event+0x50/0x60
> [<c01a2228>] inotify_remove_watch_locked+0x18/0x50
> [<c01a258c>] inotify_rm_wd+0x6c/0xb0
> [<c01a2ba8>] sys_inotify_rm_watch+0x38/0x60
> [<c0104336>] syscall_call+0x7/0xb
> =======================
> 
> Running Slackware 2.6.24.3-smp stock kernel. However, ntpdate ran 1 
> minute before this occurred (offset 7.4 seconds). Machine was running 
> rsync to a remote NFS server (common rsync, not using rsync protocol) 
> mounted at the local machine.
  Here, the check itself has been racy (and producing bogus warnings) and
is already removed in current Linus's tree. Thanks for report.

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
