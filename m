Return-Path: <linux-kernel-owner+w=401wt.eu-S933211AbYEBLcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933211AbYEBLcd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 07:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758003AbYEBLc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 07:32:26 -0400
Received: from colobus.isomerica.net ([216.93.242.10]:55993 "EHLO
	colobus.isomerica.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757017AbYEBLcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 07:32:25 -0400
Message-ID: <481AFBC8.9050602@isomerica.net>
Date: Fri, 02 May 2008 07:32:24 -0400
From: =?ISO-8859-1?Q?Dan_No=E9?= <dpn@isomerica.net>
Reply-To: dpn@isomerica.net
Organization: isomerica.net
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: =?ISO-8859-1?Q?Lothar_Wa=DFmann?= <LW@KARO-electronics.de>,
       linux-kernel@vger.kernel.org
Subject: Re: linux-2.6.25: 'mkdir -p' does not work with rootdir as mount
 point inside a read only filesystem
References: <18456.34604.472989.35082@ipc1.ka-ro> <20080501215231.297e0d9d.akpm@linux-foundation.org>
In-Reply-To: <20080501215231.297e0d9d.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> |root@triton1:/# mount
>> |rootfs on / type rootfs (rw)
>> |/dev/root on / type jffs2 (ro)
>> |proc on /proc type proc (rw)
>> |sysfs on /sys type sysfs (rw)
>> |/dev/root on /dev/.static/dev type jffs2 (ro)
>> |tmpfs on /dev type tmpfs (rw,size=10240k,mode=755)
>> |tmpfs on /var type tmpfs (rw)
>> |tmpfs on /tmp type tmpfs (rw)
>> |devpts on /dev/pts type devpts (rw,gid=5,mode=620)
>> |tmpfs on /dev/shm type tmpfs (rw)
>> |root@triton1:/# mkdir -p /dev/.udev/db
>> |mkdir: Cannot create directory `/dev/': Read-only file system
>>
>> While:
>> |root@triton1:/# cd /dev
>> |root@triton1:/# mkdir -p .udev/db
>> works as expected...
>>
>> Has anyone else encountered this problem already?
>> I've searched the archives but could not find anything related to this
>> problem.
> 
> I had a shot at scripting this, but for me, everything works OK.
> 
> #!/bin/sh
> dd if=/dev/zero of=file1 bs=1M count=32
> dd if=/dev/zero of=file2 bs=1M count=32
> yes | mkfs -t ext2 file1
> yes | mkfs -t ext2 file2
> mkdir -p mountpoint
> mount -o loop file1 mountpoint
> mkdir mountpoint/dir
> umount mountpoint
> mount -o loop,ro file1 mountpoint
> mount -o loop file2 mountpoint/dir
> mkdir -p $(/bin/pwd)/mountpoint/dir/subdir

Hmmm.  The thing you are doing differently is that the reporter's root 
filesystem is mounted read only but in your case (and the quick try I 
had at it) the read only file system is mounted below root.

However, I tried reproducing that scenario with a chroot and I still 
couldn't get it to happen.  No time to try a real root mount ro this 
morning but perhaps others can.

Cheers,
Dan

-- 
                     /--------------- - -  -  -   -   -
                     |  Dan Noé
                     |  http://isomerica.net/~dpn/
