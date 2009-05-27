Return-Path: <linux-kernel-owner+w=401wt.eu-S1761619AbZE0U5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761619AbZE0U5U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 16:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761268AbZE0U5B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 16:57:01 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:43629 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760654AbZE0U5A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 16:57:00 -0400
MIME-Version: 1.0
In-Reply-To: <20090527133125.c36381b5.akpm@linux-foundation.org>
References: <488605.71443.qm@web32605.mail.mud.yahoo.com> <20090527133125.c36381b5.akpm@linux-foundation.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 27 May 2009 22:56:45 +0200
Message-ID: <ac3eb2510905271356n1b01f273jca1f7aa8fc65c78b@mail.gmail.com>
Subject: Re: Analyzed/Solved/Bisected: Booting 2.6.30-rc2-git7 very slow
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Martin Knoblauch <knobi@knobisoft.de>, efault@gmx.de,
       viro@zeniv.linux.org.uk, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       shemminger@vyatta.com, jbarnes@virtuousgeek.org, matthew@wil.cx,
       mike.miller@hp.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 22:31, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 27 May 2009 04:25:57 -0700 (PDT)
> Martin Knoblauch <knobi@knobisoft.de> wrote:
>
>>  FWIW, I compiled the CCISS driver into the kernel. This makes the second "/sys" line in /proc/mounts go away, dmesg attached. But does it prove anything? The initialization of the CCISS hardware now happens about 2 seconds earlier in the bootup sequence. Does this hint to a problem with CCISS, or just confirms that the whole issue is really timing dependent? Anyway, I add Mike to CC.
>>
>
> It seems that the PCI change caused timing changes which triggered a
> udev/sysfs/whatever problem, which manifests as the duplicated
> /proc/mounts entry to turn up.
>
> What we don't know (afaik) is why the kernel permitted two entries in
> /proc/mounts.  That might be a bug.
>
> It could be that if dual /proc/mounts problem gets fixed, everything
> works OK - by intent or by accident, the userspace startup scripts may
> then work acceptably.
>
> I think Al asked you a few questions around the behaviour of mount(8)
> and the mount syscall, so we could delve further into why /proc/mounts
> is getting mucked up.  Did you end up running those tests?

I expect the duplicate comes from a left-over mount in initramfs which
isn't a duplicate in the sense of a bug in vfs or mount or anything. I
guess, it is just still mounted in the initial kernel rootfs, below
the root from the disk. It could be that a umount from initramfs did
go wrong because of a changed timing.

Thanks,
Kay
