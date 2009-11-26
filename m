Return-Path: <linux-kernel-owner+w=401wt.eu-S1758366AbZKZDnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758366AbZKZDnb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 22:43:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753741AbZKZDnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 22:43:31 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:46940 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420AbZKZDna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 22:43:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=sl6D6Hojpnh4ZxZz/Cr8nK/QOvNWXlAgIQv4GMTWlBCYUbxJ4TdINbMD+KcEpX7/Zu
         Pm0nS6ph9rEDw47hxrFnvNUG6lPFWTfExdnHlAfqHrYnQhx4DTHQZfREaiesiBZ/nvEa
         GB/NLCSW3YlRBeG4mOGlnlw7EGvzvamv5KMyk=
MIME-Version: 1.0
Date: Thu, 26 Nov 2009 11:43:36 +0800
Message-ID: <3877989d0911251943j6860e88ci93e237ba65835bc7@mail.gmail.com>
Subject: ia64 lockdep: trying to register non-static key (mm->mmap_sem)
From: Luming Yu <luming.yu@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "Luck, Tony" <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anybody know how I should do to fix the lockdep
warning below, which is triggered in
ia64_brk doing "down_write(&mm->mmap_sem)"

Any comments are appreciated.


INFO: trying to register non-static key.
the code is fine but needs lockdep annotation.
turning off the locking correctness validator.

Call Trace:
 [<a000000100017330>] show_stack+0x70/0xc0
                                sp=e0000004807a7c50 bsp=e0000004807a1c78
 [<a0000001000173d0>] dump_stack+0x50/0x80
                                sp=e0000004807a7e20 bsp=e0000004807a1c58
 [<a0000001000f7ca0>] __lock_acquire+0x1a0/0x13e0
                                sp=e0000004807a7e20 bsp=e0000004807a1bc0
 [<a0000001000fc310>] lock_acquire+0x170/0x1e0
                                sp=e0000004807a7e20 bsp=e0000004807a1b60
 [<a0000001008338d0>] down_write+0x70/0x180
                                sp=e0000004807a7e20 bsp=e0000004807a1b28
 [<a00000010003b960>] ia64_brk+0x60/0x280
                                sp=e0000004807a7e20 bsp=e0000004807a1aa0
 [<a00000010000c620>] ia64_ret_from_syscall+0x0/0x20


Thanks,
Luming
