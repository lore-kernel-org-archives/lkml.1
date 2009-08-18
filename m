Return-Path: <linux-kernel-owner+w=401wt.eu-S1758077AbZHRJ5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077AbZHRJ5X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 05:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753839AbZHRJ5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 05:57:22 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34013 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbZHRJ5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 05:57:21 -0400
Date: Tue, 18 Aug 2009 11:57:18 +0200
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: fs/namespace.c:638 mntput_no_expire warn_on in 2.6.30.2
Message-ID: <20090818095718.GA21869@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


To whom it concerns or for kerneloops.org. I didn't look too closely,
but it seems to have leaked a reference on a device mapper mount point
so I couldn't umount anymore. This was with a kpartx loop back mount
of a file.

Kernel 2.6.30.2 (+ some totally unrelated patches)

-Andi

------------[ cut here ]------------
WARNING: at /home/lsrc/linux-2.6.30/fs/namespace.c:638 mntput_no_expire+0xcf/0x11b()
Hardware name:         
Modules linked in:  ...
Pid: 7180, comm: umount Tainted: G      D    2.6.30.2-BASIL #7
Call Trace:
 [<ffffffff8020e284>] dump_trace+0x6e/0x292
 [<ffffffff805bccb3>] dump_stack+0x69/0x6f
 [<ffffffff802376db>] warn_slowpath_common+0x77/0xa2
 [<ffffffff802b78a1>] mntput_no_expire+0xcf/0x11b
 [<ffffffff802b7e27>] sys_umount+0x2b7/0x2e2
 [<ffffffff8020ba6b>] system_call_fastpath+0x16/0x1b
 [<00007fa4d9d1c1c7>] 0x7fa4d9d1c1c7
---[ end trace 12f3f532ce924b4b ]---


-- 
ak@linux.intel.com -- Speaking for myself only.
