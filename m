Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933329Ab0CMI41 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 03:56:27 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:61748 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932875Ab0CMI40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 03:56:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=oU9vTGj+qJ2DaEbe2zvtcQ3JZpUDaP+QwVt5dypPEnKv8w2XkfL2ptVDKT6vIdnDFG
         BqEAKvyDXiVZ2Oji/p2/hVtTZIJvDRUfshMzYjg4HD0cBEgvLJA5QEK1W1aalWFcWYUl
         0AgZMa3ojxOg1vWIADd2/2Q1FD9XOG476bFec=
MIME-Version: 1.0
Date: Sat, 13 Mar 2010 09:56:25 +0100
Message-ID: <38b2ab8a1003130056u4b025839i556a797ccad894de@mail.gmail.com>
Subject: sys_umount() returns EBUSY when doing: sh -c "mount /dev/sdc1 /mnt; 
	umount /mnt"
From: Francis Moreau <francis.moro@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

I've some shell scripts which try to find out the filesystem hosted by
a block device.

They basically do this:

    mount /dev/sdc1 /mnt
    fs=$(stat -f -c %T $mount_point)
    umount /mnt

It happens to work but since an unknown upgrade (kernel, libs or tools
upgrade), umount(8) returns -EBUSY.

I found that it's actually the sys_umount() which return -EBUSY.

So the question, is this expected or is this a regression ?

If it's expected then which operation should I add between the
mount(8) and umount(8) to make the mount operation completely finish
(inside the kernel) so the next umount won't return -EBUSY ?

Oh I'm currently using the kernel shipped with F12: 2.6.32.9-67.fc12.x86_64

Thanks
-- 
Francis
