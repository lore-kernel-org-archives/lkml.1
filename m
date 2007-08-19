Return-Path: <linux-kernel-owner+w=401wt.eu-S1755616AbXHSPQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616AbXHSPQ5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 11:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753513AbXHSPQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 11:16:47 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:6707 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505AbXHSPQp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 11:16:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=EDEkTfJqRfx0Z3RLQbZtL8HJ9IK30lugplGFmtzWYjcldDA9aBb3S7uBofAmjiU67IJ2LO7Q6ELOwKB4jU5WCpclK6rrq71DS6LhViWtgZUUkg/V2fxGIcZ3j32jwxFGP8Z2TyQG335SsVmDRWpBb7dCHzt7WtA9+2SwNYz0Xb8=
Message-ID: <46C85ED8.5080801@gmail.com>
Date: Sun, 19 Aug 2007 17:16:40 +0200
From: Maciek Rutecki <maciej.rutecki@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
CC: Linux-kernel <linux-kernel@vger.kernel.org>, htejun@gmail.com,
       linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, rjw@sisk.pl
Subject: Re: SATA error while resume
References: <46C80999.1060700@gmail.com> <46C852DE.8040701@rtr.ca>
In-Reply-To: <46C852DE.8040701@rtr.ca>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord pisze:

> 
> Looks like a bad sector in the swap partition.
> You can probably repair it by using this sequence of commands:
> 
> swapoff /dev/sdX    <--- replace sdX with actual swap partition dev name
> sync
> cat /dev/zero > /dev/sdX
> mkswap /dev/sdX
> swapon /dev/sdX
> 
> If it recurs after doing that, then it's time for a new drive.
> 
> -ml
> -

rutek:/home/maciek# swapoff /dev/sda6
rutek:/home/maciek# sync
rutek:/home/maciek# cat /dev/zero > /dev/sda6
cat: błąd zapisu: Błąd wejścia/wyjścia (write error, after few minutes,
probably sda6 is full)

rutek:/home/maciek# dd if=/dev/zero of=/dev/sda6
dd: zapis do `/dev/sda6': Błąd wejścia/wyjścia
5992177+0 przeczytanych recordów
5992176+0 zapisanych recordów
skopiowane 3067994112 bajtów (3,1 GB), 298,159 sekund, 10,3 MB/s
rutek:/home/maciek# mkswap /dev/sda6
Setting up swapspace version 1, size = 3067990 kB
no label, UUID=2061df6e-d385-4367-9a4c-c8431e57b73a
rutek:/home/maciek# swapon /dev/sda6


dmesg:
Adding 2996080k swap on /dev/sda6.  Priority:-2 extents:1 across:2996080k

Also I try:
dd if==/dev/sda... of=/dev/null for all partitions
Test disk with bios utility and smartctl. Use autotest (bash shared
mapping and disktest). No errors/warnings. Only (sometimes) while system
resume from suspend to disk. Disk 10 months old...

Regards
-- 
Maciej Rutecki
http://www.unixy.pl


