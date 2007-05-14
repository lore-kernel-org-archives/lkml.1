Return-Path: <linux-kernel-owner+w=401wt.eu-S1755003AbXENNEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755003AbXENNEx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 09:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753072AbXENNEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 09:04:46 -0400
Received: from relay4.usu.ru ([194.226.235.39]:51872 "EHLO relay4.usu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753043AbXENNEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 09:04:45 -0400
Message-ID: <46485EC7.8040006@ums.usu.ru>
Date: Mon, 14 May 2007 19:06:15 +0600
From: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
User-Agent: IceDove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Christian Hesse <mail@earthworm.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: dm(-crypt) and /dev/disk/by-label/
References: <200705141348.48099.mail@earthworm.de>
In-Reply-To: <200705141348.48099.mail@earthworm.de>
Content-Type: text/plain; charset=windows-1251; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Checked: ClamAV using ClamSMTP@relay4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Hesse wrote:
> Hello everybody,
> 
> If this is the wrong place to ask, please tell me where to ask instead.

linux-hotplug-devel, but they will tell you to ask your distro vendor.

> I have ext3 filesystems with labels on devicemapper crypted devices. These do 
> not show up in /dev/disk/by-label/, in contrast to filesystems of my "real" 
> partitions. Is this the expected behaviour or what could go wrong?

Some distributions intentionally tell udev to ignore device-mapper devices 
completely, for the following reasons:

1) without this prohibition, udev creates /dev/dm-* devices, and LILO breaks 
completely if they are present instead of the correct /dev/mapper/* nodes 
created by dmsetup and similar tools

2) without this prohibition, udev tries to open snapshot devices managed by 
dm-snapshot. The problem is that LVM2 sometimes creates such snapshots with 
the intention just to see whether it can be done. Udev keeps the temporary 
device open and thus prevents LVM2 from removing the temporary snapshot cleanly.

More details can be found at:

http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=401393
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=392623
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=343671
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=344040

Since the only known way to solve the above problems at that time was to 
prevent udev from looking at device-mapper, crypted devices don't show up in 
/dev/disk/by-label/ on your system.

-- 
Alexander E. Patrakov
