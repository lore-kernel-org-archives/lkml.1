Return-Path: <linux-kernel-owner+w=401wt.eu-S1755234AbYEZLVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbYEZLVR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 07:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753377AbYEZLVF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 07:21:05 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:15001 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210AbYEZLVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 07:21:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PiLyq4zogYZLCoZ+D55T+nFYcZ9gr0PnyEB5WZ8FJ5cDP7iYC+k7BA+NALfBOwjVJRUbxM1Cat5l+1zC+gH6QQ4RRw0dwn3E52Prg3XjXVjzODvKiTJwFjV2JUO0fgjSc2kr9jfv2DlrI5Yqd/5QVO3LE9Vyu+Uik8ibsmVd3bY=
Message-ID: <19f34abd0805260421o363f61c3r9682d3c6a38056f8@mail.gmail.com>
Date: Mon, 26 May 2008 13:21:01 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Georges Toth" <georges@trypill.org>
Subject: Re: PROBLEM: BUG: unable to handle kernel paging request at ffff81013a612000
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <483A8D59.2070302@trypill.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <483A8D59.2070302@trypill.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, May 26, 2008 at 12:13 PM, Georges Toth <georges@trypill.org> wrote:
> Hi,
>
> Please CC me with any replies as I'm not subscribed to the list.
>
> I'm running a vanilla 2.6.25.4 kernel.
>
> I apparently hit a bug in the kernel.
> When the problem starts my system becomes very unstable, many programs crash
> others I can barely shut down correctly and a reboot fails.
>
> I've hit the problem once trying to do "echo disk > /sys/power/state" and
> another time while writing do the disk inside a vmware guest.
> And a couple of times it happened randomly, e.g. while converting some files
> to mp3's and writing them to a usb device.
>

Thanks for the report.

> BUG: unable to handle kernel paging request at ffff81013a612000
> IP: [<ffffffff8027391b>] __slab_alloc+0x24a/0x4f8
> PGD 8063 PUD d063 PMD 800040013a6001e3
> Oops: 000b [1] SMP
> CPU 0
> Modules linked in: vmnet(PF) vmmon(PF) vmblock pwc compat_ioctl32 videodev
> v4l1_compat snd_usb_audio snd_usb_lib snd_rawmidi snd_hwdep it87 hwmon_vid
> xts gf128mul dm_crypt bridge llc tun vfat fat usb_storage nvidia(P) i2c_i801
> snd_hda_intel
> Pid: 15862, comm: pdflush Tainted: PF        2.6.25.4 #5

It seems that you have three proprietary modules loaded: vmnet, vmmon,
and nvidia (identified by the (P) suffix in module list above).
Especially the vmnet and vmmon modules which have been loaded forcibly
(the F suffix).

This means that it will be very hard for the mainline developers to
debug your problem. Most likely your report will be ignored.

I suggest starting your system without loading these kernel modules in
the first place. Note: It is important that the modules are not loaded
in the first place. Simply unloading them won't work, as the damage
may have been done already. If you can reproduce the problem when
these modules have not been loaded, then I am sure it will be
inspected properly.

If you cannot reproduce the problem, however, I would try to narrow
down the problem by loading only one or the other of the modules, then
contact the vendor(s) of the offending modules.

The easiest way to prevent a module from loading at boot is to remove
the corresponding .ko file from /lib/modules/<kernel-version>/. (But
keep the original file if you want to move it back later.)

Good luck.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
