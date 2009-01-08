Return-Path: <linux-kernel-owner+w=401wt.eu-S1757612AbZAHIHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612AbZAHIHd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 03:07:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756806AbZAHIHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 03:07:13 -0500
Received: from rv-out-0506.google.com ([209.85.198.226]:57479 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757276AbZAHIHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 03:07:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=lf8tX5t+AG1Oze3/D+OAoMT97/wSpwuOggvQocP3kLC8kH45H5HZW08sUulFJzK8rm
         fat4EzeQwqYVDcNyPtQkMuyFg/Wb62hXT/pspW6qpOpFYBL1L5ixchFq3mCzl5UQLTbE
         iv/kQ5SgbpSfm/u1fHSHM8lPviAfQK1WsjxXk=
Message-ID: <a0adeea50901080007q5a3ed5c8y5a744ce37e677325@mail.gmail.com>
Date: Thu, 8 Jan 2009 16:07:08 +0800
From: Grissiom <chaos.proton@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: "BUG: scheduling while atomic: pdflush/30/0x00000002" in latest git
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I using the latest git version, I occasionally got this in dmesg:

[ 2008.237234] BUG: scheduling while atomic: pdflush/30/0x00000002
[ 2008.237240] 2 locks held by pdflush/30:
[ 2008.237244]  #0:  (mutex){--..}, at: [<c01a57a1>] sync_filesystems+0x11/0x120
[ 2008.237258]  #1:  (sb_lock){--..}, at: [<c01a57ab>]
sync_filesystems+0x1b/0x120
[ 2008.237277] Modules linked in: fuse ricoh_mmc b43
[ 2008.237288] Pid: 30, comm: pdflush Not tainted
2.6.28-g14-rfkill-nophy-ledon-07485-g9e42d0c #62
[ 2008.237294] Call Trace:
[ 2008.237303]  [<c04d7576>] schedule+0x326/0x8e0
[ 2008.237311]  [<c01500d3>] __lock_acquire+0x293/0xa20
[ 2008.237321]  [<c014e307>] mark_held_locks+0x67/0x80
[ 2008.237330]  [<c04da58c>] _spin_unlock_irqrestore+0x4c/0x60
[ 2008.237339]  [<c014e519>] trace_hardirqs_on_caller+0x149/0x1a0
[ 2008.237351]  [<c0143d55>] async_synchronize_cookie_special+0xb5/0x140
[ 2008.237362]  [<c013e1a0>] autoremove_wake_function+0x0/0x40
[ 2008.237372]  [<c01a57fc>] sync_filesystems+0x6c/0x120
[ 2008.237381]  [<c017ee90>] pdflush+0x0/0x1e0
[ 2008.237392]  [<c01c0b90>] do_sync+0x20/0x60
[ 2008.237402]  [<c01c0bda>] sys_sync+0xa/0x10
[ 2008.237412]  [<c017ef9e>] pdflush+0x10e/0x1e0
[ 2008.237420]  [<c014e519>] trace_hardirqs_on_caller+0x149/0x1a0
[ 2008.237429]  [<c017de80>] laptop_flush+0x0/0x10
[ 2008.237437]  [<c013dea2>] kthread+0x42/0x70
[ 2008.237444]  [<c013de60>] kthread+0x0/0x70
[ 2008.237452]  [<c0103c03>] kernel_thread_helper+0x7/0x14
(repeat some times)

Is there any resolution?
Please add me to the CC list. Thanks.

--
Cheers,
Grissiom
