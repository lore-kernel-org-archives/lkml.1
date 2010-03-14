Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663Ab0CNQWC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 12:22:02 -0400
Received: from mail-iw0-f176.google.com ([209.85.223.176]:61191 "EHLO
	mail-iw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758530Ab0CNQVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 12:21:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=vCdT7YymbsU64giEKyYSzVwlBVyWorx0ngoJ7zQTqLmS0ud1vDA5vItXH4cLQDahTC
         pCj/oLqulHptEXQcJmpeyj+yq7efe8majIzQDd4mqIAk2pBqPA6ahXppZCR0EfGlX2/1
         0x1ebmuZhzqrcjmMWnSPA2dtm+rSsnZffCtWc=
Message-ID: <4B9D0D1E.3010404@gmail.com>
Date: Sun, 14 Mar 2010 10:21:50 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Francis Moreau <francis.moro@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: sys_umount() returns EBUSY when doing: sh -c "mount /dev/sdc1
 /mnt;  umount /mnt"
References: <38b2ab8a1003130056u4b025839i556a797ccad894de@mail.gmail.com>
In-Reply-To: <38b2ab8a1003130056u4b025839i556a797ccad894de@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2010 02:56 AM, Francis Moreau wrote:
> Hello
>
> I've some shell scripts which try to find out the filesystem hosted by
> a block device.
>
> They basically do this:
>
>      mount /dev/sdc1 /mnt
>      fs=$(stat -f -c %T $mount_point)
>      umount /mnt
>
> It happens to work but since an unknown upgrade (kernel, libs or tools
> upgrade), umount(8) returns -EBUSY.
>
> I found that it's actually the sys_umount() which return -EBUSY.
>
> So the question, is this expected or is this a regression ?
>
> If it's expected then which operation should I add between the
> mount(8) and umount(8) to make the mount operation completely finish
> (inside the kernel) so the next umount won't return -EBUSY ?

If no other process were involved I would say it's likely a bug. 
However, my guess is that some other process (HAL, something in GNOME, 
etc.) detects the mount and decides to start accessing the drive. Then 
when you immediately try to unmount, it fails because it's busy. I 
suspect if you try this in single-user mode with no unnecessary 
processes running you won't see this.

>
> Oh I'm currently using the kernel shipped with F12: 2.6.32.9-67.fc12.x86_64
>
> Thanks

