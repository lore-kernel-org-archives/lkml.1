Return-Path: <linux-kernel-owner+w=401wt.eu-S1755505AbYKEJCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbYKEJCb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 04:02:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753563AbYKEJCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 04:02:18 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:26551 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbYKEJCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 04:02:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QpJAdga385wusjZCG3lezNgCCCTi+AgLRjM3XO97U+JFHWidv7xiYC88PAKVqMeNP5
         78Uop+gG4aHaHvs4tvqCGUz2Y8IFQgW0/Xtfh96e1fIjEqRLKXCsdzIGZxKG9bCsfqwi
         f5jxZz2Xf/Z2VhkAxF6ABlUoWe4eAYAO0bvR8=
Date: Wed, 5 Nov 2008 12:05:22 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.28-rc3: kernel mounts the same device twice? Or
	/proc/mounts lies?
Message-ID: <20081105090522.GB3570@x200.localdomain>
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
> Out of some infinite wisdom something on my system decided to add
> fstab entry for "new" device after switching from IDE to PATA:
> 
> # Entry for /dev/LABEL=/ :
> LABEL=/ / reiserfs relatime,tail 1 1
> none /proc proc defaults 0 0
> none /sys sysfs defaults 0 0
> none /tmp tmpfs defaults 0 0
> # Entry for /dev/LABEL=swap :
> LABEL=swap swap swap defaults 0 0
> # Entry for /dev/sda2 :
> UUID=72973377-c299-4ca6-ae94-2022b7dca58f /media/hd reiserfs defaults 0 0
> 
> Note that both / and /media/hd refer to the same device:
> 
> {pts/0}% sudo blkid
> /dev/sda1: TYPE="swap" LABEL="swap" UUID="3b4dc82c-a6e6-4609-be9e-16d9206ab7fd"
> /dev/sda2: UUID="72973377-c299-4ca6-ae94-2022b7dca58f" LABEL="/" TYPE="reiserfs"
> 
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

bind mount or some userspace from LinuxOnDesktop crowd is actually mounted it second time.
