Return-Path: <linux-kernel-owner+w=401wt.eu-S1758246AbZIFXuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758246AbZIFXuW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 19:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752895AbZIFXuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 19:50:21 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:64336 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889AbZIFXuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 19:50:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :x-enigmail-version:content-type:content-transfer-encoding;
        b=ZpRJe2AtlL5mHMn9L976+Ca2ldxyizedyl8zzvL2+UYS4AQJlNQHc5ALTZhnFfia6b
         D2UU2IKfgACnKlYwyyHYzqGLGRr9ZCD31ZBUoIOJxlqvb9V7pkzWecwJE6EB5EmZN67J
         3JXpjnkcim7EpKa6hSJHewd7XHbsDKIih5XtM=
Message-ID: <4AA44ABC.1040305@gmail.com>
Date: Sun, 06 Sep 2009 20:50:20 -0300
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090829)
MIME-Version: 1.0
To: Eric Paris <eparis@parisplace.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.31-rc9
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Eric,

I am not sure all of the inotify issues have been corrected in 2.6.31-rc9:

[  165.823580] ------------[ cut here ]------------
[  165.823600] WARNING: at fs/notify/inotify/inotify_fsnotify.c:129 idr_callback+0x43/0x67()
[  165.823604] Hardware name: MS-6702
[  165.823607] inotify closing but id=0 for entry=ffff88004ce36a28 in group=ffff88004a2229c0 still in idr.  Probably leaking memory
[  165.823610] Modules linked in: k8temp
[  165.823618] Pid: 1555, comm: gam_server Not tainted 2.6.31-rc9 #392
[  165.823621] Call Trace:
[  165.823626]  [<ffffffff810c405e>] ? idr_callback+0x43/0x67
[  165.823635]  [<ffffffff8103204c>] warn_slowpath_common+0x7c/0xa9
[  165.823640]  [<ffffffff810320f8>] warn_slowpath_fmt+0x69/0x6b
[  165.823646]  [<ffffffff8109a140>] ? lookup_object+0x37/0x6e
[  165.823653]  [<ffffffff8105a90a>] ? call_rcu+0x15/0x17
[  165.823657]  [<ffffffff8109a21d>] ? put_object+0x44/0x48
[  165.823661]  [<ffffffff810c405e>] idr_callback+0x43/0x67
[  165.823667]  [<ffffffff8115de32>] idr_for_each+0x6f/0xb2
[  165.823671]  [<ffffffff810c401b>] ? idr_callback+0x0/0x67
[  165.823676]  [<ffffffff810c4007>] inotify_free_group_priv+0x27/0x3b
[  165.823680]  [<ffffffff810c2a11>] fsnotify_final_destroy_group+0x28/0x34
[  165.823684]  [<ffffffff810c2b02>] fsnotify_put_group+0x93/0x97
[  165.823688]  [<ffffffff810c41e4>] inotify_release+0x2a/0x3b
[  165.823692]  [<ffffffff8109e185>] __fput+0x112/0x1c4
[  165.823696]  [<ffffffff8109e253>] fput+0x1c/0x1e
[  165.823700]  [<ffffffff8109b6a5>] filp_close+0x5e/0x68
[  165.823704]  [<ffffffff810336c5>] put_files_struct+0x6f/0xc6
[  165.823708]  [<ffffffff81033744>] exit_files+0x28/0x2a
[  165.823711]  [<ffffffff81034b81>] do_exit+0x186/0x59d
[  165.823716]  [<ffffffff810225b3>] ? do_page_fault+0x21b/0x24d
[  165.823720]  [<ffffffff81034feb>] do_group_exit+0x53/0x7d
[  165.823723]  [<ffffffff8103502c>] sys_exit_group+0x17/0x1b
[  165.823728]  [<ffffffff8100afd8>] system_call_fastpath+0x16/0x1b
[  165.823731] ---[ end trace 34f3b8e033c3e431 ]---
[  165.823735] entry->group=(null) inode=(null) wd=4096

Is there anything I can do to help debug this?

-- 
Kevin Winchester

