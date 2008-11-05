Return-Path: <linux-kernel-owner+w=401wt.eu-S1755837AbYKEJd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837AbYKEJd7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 04:33:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753941AbYKEJdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 04:33:51 -0500
Received: from mx2.redhat.com ([66.187.237.31]:39416 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753670AbYKEJdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 04:33:50 -0500
Date: Wed, 5 Nov 2008 10:33:44 +0100
From: Karel Zak <kzak@redhat.com>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.28-rc3: kernel mounts the same device twice? Or
	/proc/mounts lies?
Message-ID: <20081105093344.GA7791@nb.net.home>
References: <200811041213.07717.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811041213.07717.arvidjaar@mail.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2008 at 12:13:07PM +0300, Andrey Borzenkov wrote:
> And according to /proc/mounts both are mounted at the same time:
> 
> {pts/0}% cat /proc/mounts
> rootfs / rootfs rw 0 0
> /dev/root / reiserfs rw 0 0
> /dev /dev tmpfs rw 0 0
> /proc /proc proc rw 0 0
> /sys /sys sysfs rw 0 0
> /proc/bus/usb /proc/bus/usb usbfs rw,devgid=43,devmode=664 0 0
> none /dev/pts devpts rw,mode=620 0 0
> none /dev/shm tmpfs rw 0 0
> none /tmp tmpfs rw 0 0
> none /proc/sys/fs/binfmt_misc binfmt_misc rw 0 0
> /dev/sda2 /media/hd reiserfs rw 0 0
> {pts/0}% ll /dev/root
> brw------- 1 root root 8, 2 2008-11-04 12:01 /dev/root
> {pts/0}% ll /dev/sda2
> brw-rw---- 1 root disk 8, 2 2008-11-04 12:01 /dev/sda2
> 
> Bug or feature?

 Feature. This is typical FAQ-like question.

 # mount /dev/sda2 /mnt/test
 # mount /dev/sda2 /mnt/test2

 # df | grep sda2
 /dev/sda2             14877092    168740  13940448   2% /mnt/test
 /dev/sda2             14877092    168740  13940448   2% /mnt/test2

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
