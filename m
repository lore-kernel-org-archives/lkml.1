Return-Path: <linux-kernel-owner+w=401wt.eu-S1755165AbZCVOwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165AbZCVOwj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 10:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753903AbZCVOwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 10:52:30 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:45743 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509AbZCVOw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 10:52:29 -0400
Message-ID: <49C650A8.60308@davidnewall.com>
Date: Mon, 23 Mar 2009 01:22:24 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: df -h shows ~10 times bigger size when umounting pendrive
References: <200903220150.16004.a.miskiewicz@gmail.com> <49C5DEE5.6090205@davidnewall.com> <200903221125.16860.a.miskiewicz@gmail.com>
In-Reply-To: <200903221125.16860.a.miskiewicz@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arkadiusz Miskiewicz wrote:
> /etc/mtab contains:
>
> /dev/sdb1 /media/floppy vfat rw 0 0
>
> statfs() returns:
>
> statfs("/media/floppy", {f_type=0x58465342, f_bsize=4096, f_blocks=2497555, 
> f_bfree=1410716, f_bavail=1410716, f_files=10000448, f_ffree=9842679, 
> f_fsid={2051, 0}, f_namelen=255, f_frsize=4096}) = 0
>   

The statfs(), above, is not a stat for the file system at /media/floppy,
it's a stat for the file system which *contains* /media/floppy.  If
/dev/sdb1 has been unmounted (which was in fact in occurring at the
time) the stat refers to (in your case) the root filesystem.  And look
at the returned information: 2497555 4K blocks, 1410716 of them
available; that's 9.6GB file system with 5.5GB available, same as /dev/sda3.

Truly, this is what I said it was; and it's normal, and it's reasonable.

> /dev/sdb1             9,6G  4,2G  5,4G  44% /media/floppy
>
> So why statfs() lies on a being unmounted filesystem?

There is a lie, which is that /media/floppy is on /dev/sdb1.  That
ceases to be true as soon as the umount starts.  The reason df lies is
because it trusts the mtab, which has not yet had the entry for
/dev/sdb1 removed.
