Return-Path: <linux-kernel-owner+w=401wt.eu-S1030749AbXDJOmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030749AbXDJOmA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 10:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030759AbXDJOmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 10:42:00 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:49272 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030749AbXDJOl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 10:41:58 -0400
Date: Tue, 10 Apr 2007 16:44:16 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: gregkh@suse.de, maneesh@in.ibm.com, dmitry.torokhov@gmail.com,
       oneukum@suse.de, rpurdie@rpsys.net, James.Bottomley@SteelEye.com,
       stern@rowland.harvard.edu, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET #master] sysfs: make sysfs disconnect immediately on
 deletion, take 2
Message-ID: <20070410164416.63469474@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <11760923261269-git-send-email-htejun@gmail.com>
References: <11760923261269-git-send-email-htejun@gmail.com>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.8.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Apr 2007 13:18:46 +0900,
Tejun Heo <htejun@gmail.com> wrote:

> With all the patches applied, the same test used in the last take ran
> 9+hrs without any problem.

I get the following on startup:

=====================================
[ BUG: bad unlock balance detected! ]
-------------------------------------
start_udev/197 is trying to release lock (&sd->s_active) at:
[<0000000000209024>] release_sysfs_dirent+0x8c/0x118
but there are no more locks to release!

other info that might help us debug this:
no locks held by start_udev/197.

stack backtrace:
000000001ea4fad8 0000000000000002 0000000000000000 000000001ea4fbe8 
       000000001ea4fb60 00000000004bebf6 00000000004bebf6 0000000000103854
       0000000000000000 0000000000000000 0000000000000000 0000000000602cb0
       0000000000000000 000000001ea4fba8 000000001ea4fb48 000000000000000e
       000000000042a810 000000000010389e 000000001ea4fb48 000000001ea4fb98
Call Trace:
([<00000000001037f4>] show_trace+0xf8/0xfc)
 [<00000000001038ce>] show_stack+0xd6/0x100
 [<0000000000103926>] dump_stack+0x2e/0x3c
 [<0000000000153c98>] print_unlock_inbalance_bug+0x114/0x138
 [<0000000000156dce>] lock_release+0x166/0x1bc
 [<000000000014f8c2>] up_write+0x3e/0x98
 [<0000000000209024>] release_sysfs_dirent+0x8c/0x118
 [<000000000020912e>] sysfs_dir_close+0x7e/0x90
 [<00000000001a7088>] __fput+0xe4/0x20c
 [<00000000001a71fc>] fput+0x4c/0x5c
 [<00000000001a3aa4>] filp_close+0x7c/0xb4
 [<00000000001a3fcc>] sys_close+0xdc/0x128
 [<00000000001107c8>] sysc_noemu+0x10/0x16
 [<0000020000107dd0>] 0x20000107dd0
