Return-Path: <linux-kernel-owner+w=401wt.eu-S967547AbYCTAeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967547AbYCTAeT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939665AbYCTAHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 20:07:49 -0400
Received: from clustermail5.digiweb.com.br ([189.38.50.59]:42668 "EHLO
	lvs.digiweb.com.br" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756546AbYCTAHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 20:07:45 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Mar 2008 20:07:45 EDT
Message-ID: <47E1A935.9030705@linuxbr.com>
Date: Wed, 19 Mar 2008 21:00:53 -0300
From: Cesar Suga <sartre@linuxbr.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: BUG: at fs/inotify.c:182 set_dentry_child_flags() - second
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I second Patrick McLean's e-mail from 2007/02/27.

Patrick also said he was using nfsd at that point.

WARNING: at fs/inotify.c:182 set_dentry_child_flags()
Pid: 19103, comm: gam_server Tainted: P        2.6.24.3-smp #1
 [<c01a2087>] set_dentry_child_flags+0x127/0x160
 [<c01a2110>] remove_watch_no_event+0x50/0x60
 [<c01a2228>] inotify_remove_watch_locked+0x18/0x50
 [<c01a258c>] inotify_rm_wd+0x6c/0xb0
 [<c01a2ba8>] sys_inotify_rm_watch+0x38/0x60
 [<c0104336>] syscall_call+0x7/0xb
 =======================

Running Slackware 2.6.24.3-smp stock kernel. However, ntpdate ran 1 
minute before this occurred (offset 7.4 seconds). Machine was running 
rsync to a remote NFS server (common rsync, not using rsync protocol) 
mounted at the local machine.

Regards,
Cesar

--- quote ---
I have this message in the dmesg on a mail server running on an xfs
filesystem. It appears to have happened at some point when nfsd was
restarted, but I can't seem to convince it to reproduce.

The machine is running Gentoo's 2.6.20 kernel.

BUG: at fs/inotify.c:182 set_dentry_child_flags()

Call Trace:
[<ffffffff802b7e2a>] set_dentry_child_flags+0xd4/0x132
[<ffffffff802b7eef>] remove_watch_no_event+0x67/0x76
[<ffffffff802b7f16>] inotify_remove_watch_locked+0x18/0x3b
[<ffffffff802b8004>] inotify_rm_wd+0x7e/0xa1
[<ffffffff802b8519>] sys_inotify_rm_watch+0x46/0x62
[<ffffffff80253e6e>] system_call+0x7e/0x83

