Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752524AbYLRJ1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbYLRJ1z (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 04:27:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751434AbYLRJ1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 04:27:45 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:2327 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbYLRJ1m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 04:27:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=BkDkyf1+VyHDYzURQi3/P+hrxqVu161X3AB8vKMnFmxhZ6OX8EdoWQPHUuJR+a2RCC
         lrL+eUHkaY39oJ82DtHAnXVtUglCrYAug6kq/xpetHJOa8GUU2nydUGXFiUYzTsg3LMo
         4WYKXy7jwrAvpYHk6ERgJ4fe7nhu/7TeLSIu8=
Message-ID: <9b06e8d20812180127s2b6cdbl410333336c7c9beb@mail.gmail.com>
Date: Thu, 18 Dec 2008 10:27:40 +0100
From: "=?ISO-8859-1?Q?Lo=EFc_Greni=E9?=" <loic.grenie@gmail.com>
To: "Neil Horman" <nhorman@tuxdriver.com>
Subject: Re: Dracut -- Cross distribution initramfs infrastructure
Cc: initramfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kay Sievers" <kay.sievers@vrfy.org>, "Dave Jones" <davej@redhat.com>,
        cjwatson@ubuntu.com
In-Reply-To: <20081217193151.GA7356@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1229540094.28858.150.camel@aglarond.local>
	 <20081217193151.GA7356@hmsreliant.think-freely.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/12/17 Neil Horman <nhorman@tuxdriver.com>:
> On Wed, Dec 17, 2008 at 01:54:54PM -0500, Jeremy Katz wrote:

[snip]

>> Therefore I've started on a new project, dracut, to try to be a new
>> initramfs tool that can be used across various distributions.  From the
>> README...
>>
>> Unlike existing initramfs's, this is an attempt at having as little as
>> possible hard-coded into the initramfs as possible.  The initramfs has
>> (basically) one purpose in life -- getting the rootfs mounted so that we
>> can transition to the real rootfs.

[snip]

> Not that I don't think a unifying tool to create an initramfs is a bad idea
> (quite the contrary, I think it would be great), but I'd like to point out that
> one of your underlying premises is a bit shaky.  That an initramfs has one
> purpose, that being to get the rootfs mounted, isn't entirely accurate.  Kdump
> and various embedded systems being the prime examples here.  Many embedded
> systems run entirely out of the initramfs, and contain all the code they need to
> do so in them.  Additionally, kdump in most environments, attemps to capture
> core files entirely from the initramfs as well, operating under the assumption
> that the rootfs may not be functioning properly after a crash.  By and large
> these initramfs images tend to be larger and offer a more typical (if not
> standard) user operating environment.  I'm looking at your tree now, and it
> looks like a good start on standardizing the initramfs for the nominal case.  Do
> you have plans to include (or are you interested in including) support for
> alternate infrastructure (like busybox instead of nash), interactive setup, etc?

    Seconded: as a user of (various) distributions, I've come across
the following
  problem: sometimes the initramfs, for whatever reason, does not manage to
  find or mount the rootfs. In those cases I hate the developpers of
the distribution
  because there is basically nothing that can be done in the initramfs
to see, test,
  try, mount, modprobe, umount, ping, telnet, etc... Please, please, throw in a
  full-featured busybox. Here is a good compromise I use:

Currently defined functions:
        [, [[, arp, arping, ash, awk, basename, brctl, bunzip2, bzcat,
        bzip2, cat, chgrp, chmod, chown, chroot, chvt, clear, cmp, comm,
        cp, cpio, cut, date, dc, dd, deallocvt, depmod, df, diff, dirname,
        dmesg, dos2unix, dpkg, dpkg-deb, du, dumpkmap, echo, egrep, eject,
        env, expr, false, fbset, fdflush, fdformat, fdisk, fgrep, find,
        findfs, ftpget, ftpput, grep, gunzip, gzip, halt, head, hexdump,
        hostname, hwclock, ifconfig, ifenslave, insmod, ip, ipcalc, kbd_mode,
        kill, killall, killall5, less, linux32, linux64, ln, loadfont,
        loadkmap, losetup, ls, lsmod, md5sum, microcom, mkdir, mkfifo,
        mknod, mkswap, mktemp, more, mount, mv, nice, od, openvt, patch,
        pgrep, pidof, ping, ping6, pivot_root, pkill, poweroff, printf,
        ps, pwd, readlink, reboot, reset, rm, rmdir, rmmod, route, rpm2cpio,
        rtcwake, sed, setarch, setkeycodes, sh, sha1sum, sleep, sort,
        stat, strings, stty, su, swapoff, swapon, switch_root, sync, tac,
        tail, tar, tee, telnet, test, touch, tr, traceroute, true, tty,
        udhcpc, umount, uname, uniq, unix2dos, unzip, vi, wc, wget, which,
        xargs, yes, zcat

  (linux32 and linux64 are probably not useful for general initramfs). With that
  configuration, busybox (v1.13.0.svn, x86-32 executable) is 416224 bytes long
  (dynamically linked with libc as only library needed).

          Loïc Grenié
