Return-Path: <linux-kernel-owner+w=401wt.eu-S1759456AbZAVXLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759456AbZAVXLm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 18:11:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbZAVXLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 18:11:35 -0500
Received: from hpsmtp-eml17.KPNXCHANGE.COM ([213.75.38.117]:17967 "EHLO
	hpsmtp-eml17.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753437AbZAVXLe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 18:11:34 -0500
From: Frans Pop <elendil@planet.nl>
To: Pavel Machek <pavel@suse.cz>
Subject: Re: HP accelerometer driver: testers wanted
Date: Fri, 23 Jan 2009 00:11:31 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <20090122213139.GD2159@elf.ucw.cz> <200901222301.57681.elendil@planet.nl> <20090122221708.GA3430@elf.ucw.cz>
In-Reply-To: <20090122221708.GA3430@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901230011.31871.elendil@planet.nl>
X-OriginalArrivalTime: 22 Jan 2009 23:11:32.0372 (UTC) FILETIME=[C3A8ED40:01C97CE6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor issue in the patch: hpfall.c should not be executable:
-rwxr-xr-x 1 fjp fjp  1759 2009-01-22 23:31 hpfall.c

With patch applied:
$ ls -l /dev/freefall
crw-rw---- 1 root root 10, 59 2009-01-22 23:44 /dev/freefall

$ gcc -o hpfall -Os hpfall.c
hpfall.c: In function ‘main’:
hpfall.c:73: warning: passing argument 2 of ‘signal’ from incompatible 
pointer type

> Run hpfall, and see if LED lights and disk parks if you "drop" a
> computer. (*)

$ sudo ./hpfall &

The LED lights up yellow, but I have problems telling if the disk gets 
parked or not. One time I got a green led and seemingly a fair amount of 
activity immediately after getting the yellow led.

After looking at hpfall.c, I checked /sys/block/sda/device/unload_heads 
after a drop:
$ cat /sys/block/sda/device/unload_heads
19616
$ cat /sys/block/sda/device/unload_heads
0

The last was at most 2 seconds after the first, certainly not 20...

Wouldn't it be good to have locks/unlocks registered in the logs when
/sys/block/sda/device/unload_heads changes (assuming the actual write will 
get delayed until the head is unparked)?

Cheers,
FJP
