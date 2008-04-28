Return-Path: <linux-kernel-owner+w=401wt.eu-S936262AbYD1Rag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936262AbYD1Rag (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 13:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933114AbYD1RaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 13:30:23 -0400
Received: from hobbit.corpit.ru ([81.13.94.6]:24123 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934069AbYD1RaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 13:30:20 -0400
Message-ID: <481609A5.1080905@msgid.tls.msk.ru>
Date: Mon, 28 Apr 2008 21:30:13 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080406)
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: umount(/proc) after CLONE_NEWNS in 2.6.25?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since 2.6.25, it isn't possible anymore to umount
/proc after clone(CLONE_NEWNS).  It worked fine
before.  E.g:

# strace newnamespace umount -n /proc

2.6.24:

[pid 30121] clone(child_stack=0xff8c21f4, flags=CLONE_NEWNS|SIGCHLD) = 30122
[pid 30122] execve("/usr/sbin/umount", ["umount", "-n", "/proc"])
...
[pid 30122] oldumount("/proc")          = 0


2.6.25:

[pid 6308] clone(child_stack=0xbfc9de94, flags=CLONE_NEWNS|SIGCHLD) = 6309
[pid  6309] execve("/usr/sbin/umount", ["umount", "-n", "/proc"])
...
[pid  6309] oldumount("/proc")          = -1 EBUSY (Device or resource busy)
umount: /proc: device is busy

Yes, various NAMESPACEs are enabled (i'm trying to experiment with
those).

Is it intentional?

Thanks.

/mjt
